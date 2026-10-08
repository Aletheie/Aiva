import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../platform/process_runner.dart';
import 'tool_discovery.dart';

enum JavaLanguageState { stopped, starting, ready, unavailable, error }

/// Positions use UTF-16 code units, as do Dart strings and the LSP default.
final class JavaPosition {
  const JavaPosition(this.line, this.character);
  final int line;
  final int character;

  factory JavaPosition.fromJson(Map<String, dynamic> json) => JavaPosition(
    (json['line'] as num?)?.toInt() ?? 0,
    (json['character'] as num?)?.toInt() ?? 0,
  );

  factory JavaPosition.at(String text, int offset) {
    offset = offset.clamp(0, text.length);
    var line = 0;
    var start = 0;
    for (var i = 0; i < offset; i++) {
      if (text.codeUnitAt(i) == 10) {
        line++;
        start = i + 1;
      }
    }
    return JavaPosition(line, offset - start);
  }

  int offsetIn(String text) {
    var start = 0;
    for (var i = 0; i < line; i++) {
      final end = text.indexOf('\n', start);
      if (end < 0) return text.length;
      start = end + 1;
    }
    final newline = text.indexOf('\n', start);
    final end = newline < 0 ? text.length : newline;
    return (start + character).clamp(start, end);
  }

  Map<String, int> toJson() => {'line': line, 'character': character};
}

final class JavaTextEdit {
  const JavaTextEdit({
    required this.start,
    required this.end,
    required this.text,
  });
  final JavaPosition start;
  final JavaPosition end;
  final String text;

  factory JavaTextEdit.fromJson(Map<String, dynamic> json) {
    final range = (json['range'] ?? json['replace'] ?? json['insert']) as Map;
    return JavaTextEdit(
      start: JavaPosition.fromJson(
        Map<String, dynamic>.from(range['start'] as Map),
      ),
      end: JavaPosition.fromJson(
        Map<String, dynamic>.from(range['end'] as Map),
      ),
      text: json['newText'] as String? ?? '',
    );
  }
}

final class JavaEditResult {
  const JavaEditResult(this.text, this.offset);
  final String text;
  final int offset;
}

final class JavaCompletion {
  JavaCompletion.fromJson(this.raw)
    : label = raw['label'] as String? ?? '',
      detail = raw['detail'] as String? ?? '',
      insertText =
          raw['insertText'] as String? ?? raw['label'] as String? ?? '',
      kind = (raw['kind'] as num?)?.toInt() ?? 1,
      edit = raw['textEdit'] is Map
          ? JavaTextEdit.fromJson(
              Map<String, dynamic>.from(raw['textEdit'] as Map),
            )
          : null,
      additionalEdits = [
        for (final edit in raw['additionalTextEdits'] as List? ?? const [])
          if (edit is Map)
            JavaTextEdit.fromJson(Map<String, dynamic>.from(edit)),
      ];

  final String label;
  final String detail;
  final String insertText;
  final int kind;
  final JavaTextEdit? edit;
  final List<JavaTextEdit> additionalEdits;
  final Map<String, dynamic> raw;

  /// Applies the server's replacement and import edits against the same snapshot.
  JavaEditResult apply(String text, int offset) {
    offset = offset.clamp(0, text.length);
    var wordStart = offset;
    while (wordStart > 0 && RegExp(r'[\w$]').hasMatch(text[wordStart - 1])) {
      wordStart--;
    }
    final main =
        edit ??
        JavaTextEdit(
          start: JavaPosition.at(text, wordStart),
          end: JavaPosition.at(text, offset),
          text: insertText,
        );
    final changes =
        [main, ...additionalEdits]
            .map(
              (item) => (
                start: item.start.offsetIn(text),
                end: item.end.offsetIn(text),
                text: item.text,
                main: identical(item, main),
              ),
            )
            .toList()
          ..sort((a, b) => b.start.compareTo(a.start));
    var cursor = main.start.offsetIn(text) + main.text.length;
    var result = text;
    var boundary = text.length;
    for (final change in changes) {
      if (change.end > boundary || change.end < change.start) continue;
      result = result.replaceRange(change.start, change.end, change.text);
      if (!change.main && change.end <= main.start.offsetIn(text)) {
        cursor += change.text.length - (change.end - change.start);
      }
      boundary = change.start;
    }
    return JavaEditResult(result, cursor.clamp(0, result.length));
  }
}

final class JavaDiagnostic {
  const JavaDiagnostic({
    required this.message,
    required this.start,
    required this.end,
    this.severity = 1,
  });
  final String message;
  final JavaPosition start;
  final JavaPosition end;

  /// LSP severity: 1 error, 2 warning, 3 information, 4 hint.
  final int severity;
  int get line => start.line;

  factory JavaDiagnostic.fromJson(Map<String, dynamic> json) {
    final range = json['range'] as Map;
    return JavaDiagnostic(
      message: json['message'] as String? ?? '',
      start: JavaPosition.fromJson(
        Map<String, dynamic>.from(range['start'] as Map),
      ),
      end: JavaPosition.fromJson(
        Map<String, dynamic>.from(range['end'] as Map),
      ),
      severity: (json['severity'] as num?)?.toInt() ?? 1,
    );
  }
}

/// Incremental, byte-based framing: Content-Length counts UTF-8 bytes, not chars.
final class LspMessageDecoder {
  final List<int> _buffer = [];
  static const maxMessageBytes = 32 * 1024 * 1024;

  List<Map<String, dynamic>> add(List<int> bytes) {
    _buffer.addAll(bytes);
    final messages = <Map<String, dynamic>>[];
    while (_buffer.isNotEmpty) {
      var headerEnd = -1;
      for (var i = 0; i + 3 < _buffer.length; i++) {
        if (_buffer[i] == 13 &&
            _buffer[i + 1] == 10 &&
            _buffer[i + 2] == 13 &&
            _buffer[i + 3] == 10) {
          headerEnd = i;
          break;
        }
      }
      if (headerEnd < 0) {
        if (_buffer.length > 8192) {
          throw const FormatException('LSP header too large.');
        }
        break;
      }
      final header = ascii.decode(_buffer.sublist(0, headerEnd));
      final match = RegExp(
        r'^Content-Length:\s*(\d+)\s*$',
        multiLine: true,
        caseSensitive: false,
      ).firstMatch(header);
      final length = match == null ? null : int.tryParse(match.group(1)!);
      if (length == null || length > maxMessageBytes) {
        throw const FormatException('Invalid LSP Content-Length.');
      }
      final end = headerEnd + 4 + length;
      if (_buffer.length < end) break;
      final body = utf8.decode(_buffer.sublist(headerEnd + 4, end));
      _buffer.removeRange(0, end);
      messages.add(Map<String, dynamic>.from(jsonDecode(body) as Map));
    }
    return messages;
  }
}

/// Runs Eclipse JDT LS locally over stdio; source code never leaves the device.
final class JavaLanguageService extends ChangeNotifier {
  JavaLanguageState state = JavaLanguageState.stopped;
  String statusMessage = 'Java IntelliSense';
  final Map<String, List<JavaDiagnostic>> diagnostics = {};
  final Map<int, Completer<dynamic>> _pending = {};
  final Map<String, ({int version, String text})> _documents = {};
  Process? _process;
  Directory? _session;
  Map<String, dynamic> _settings = {};
  int _nextId = 0;
  int _generation = 0;
  bool _disposed = false;
  bool get isReady => state == JavaLanguageState.ready;

  /// The pinned JDT LS distribution supports Java 21–25. Its bytecode tools
  /// cannot start on Java 27, even when the exercise targets an older release.
  /// Keep the language-server runtime independent from the exercise compiler.
  static JdkInstallation? selectRuntime({
    required JdkInstallation preferred,
    Iterable<JdkInstallation> available = const [],
  }) {
    bool supported(JdkInstallation jdk) => jdk.major >= 21 && jdk.major <= 25;
    if (supported(preferred)) return preferred;
    final candidates = available.where(supported).toList()
      ..sort((a, b) => b.major.compareTo(a.major));
    return candidates.isEmpty ? null : candidates.first;
  }

  static Future<JdkInstallation?> _bundledRuntime() async {
    final homes = <String>[];
    final env = Platform.environment;
    if (Platform.isMacOS) {
      for (final root in [
        '/Applications',
        if (env['HOME'] != null) p.join(env['HOME']!, 'Applications'),
      ]) {
        for (final app in [
          'IntelliJ IDEA',
          'IntelliJ IDEA CE',
          'Android Studio',
          'PyCharm',
        ]) {
          homes.add(
            p.join(root, '$app.app', 'Contents', 'jbr', 'Contents', 'Home'),
          );
        }
      }
    } else if (Platform.isWindows) {
      final root = env['ProgramFiles'];
      if (root != null) {
        homes.add(p.join(root, 'Android', 'Android Studio', 'jbr'));
        for (final editor in await _directories(p.join(root, 'JetBrains'))) {
          homes.add(p.join(editor, 'jbr'));
        }
      }
    } else {
      homes.addAll(['/opt/idea/jbr', '/opt/android-studio/jbr']);
    }
    for (final home in homes) {
      try {
        if (!await Directory(home).exists()) continue;
        final jdk = await const ToolDiscovery().inspectJdk(home);
        if (selectRuntime(preferred: jdk) != null) return jdk;
      } on Object {
        // An incomplete IDE installation must not prevent another fallback.
      }
    }
    return null;
  }

  static Future<String?> discoverServer({
    String serverPath = '',
    String managedRoot = '',
  }) async {
    if (serverPath.trim().isNotEmpty) return _validServer(serverPath.trim());
    final candidates = <String>[];
    final env = Platform.environment;
    if (env['JDTLS_HOME'] case final String path) candidates.add(path);
    if (managedRoot.isNotEmpty) {
      candidates.add(managedRoot);
      candidates.addAll(await _directories(managedRoot));
    }
    final home = env[Platform.isWindows ? 'USERPROFILE' : 'HOME'];
    if (home != null) {
      for (final editor in [
        '.vscode',
        '.vscode-insiders',
        '.cursor',
        '.vscodium',
      ]) {
        final extensions = [
          ...await _directories(p.join(home, editor, 'extensions')),
        ];
        extensions.sort((a, b) => b.compareTo(a));
        for (final extension in extensions) {
          if (p.basename(extension).startsWith('redhat.java-')) {
            candidates.add(p.join(extension, 'server'));
          }
        }
      }
      candidates.add(p.join(home, '.local', 'share', 'jdtls'));
    }
    candidates.addAll([
      '/usr/share/java/jdtls',
      '/usr/share/jdtls',
      '/opt/homebrew/opt/jdtls/libexec',
      '/usr/local/opt/jdtls/libexec',
    ]);
    for (final candidate in candidates) {
      final path = await _validServer(candidate);
      if (path != null) return path;
    }
    return null;
  }

  static Future<String?> _validServer(String root) async {
    if (!p.isAbsolute(root)) return null;
    try {
      final plugins = Directory(p.join(root, 'plugins'));
      if (!await plugins.exists()) return null;
      var launcher = false;
      await for (final entry in plugins.list()) {
        if (entry is File &&
            p
                .basename(entry.path)
                .startsWith('org.eclipse.equinox.launcher_') &&
            entry.path.endsWith('.jar')) {
          launcher = true;
        }
      }
      if (!launcher) return null;
      final config = await _configuration(root);
      return config == null
          ? null
          : await Directory(root).resolveSymbolicLinks();
    } on FileSystemException {
      return null;
    }
  }

  static Future<String?> _configuration(String root) async {
    final platform = Platform.isMacOS
        ? 'mac'
        : Platform.isWindows
        ? 'win'
        : 'linux';
    // Recent distributions also ship architecture-specific configurations.
    final arm = Abi.current().toString().contains('arm64');
    for (final name in [
      if (arm) 'config_${platform}_arm',
      'config_$platform',
      'config_${platform}_aarch64',
    ]) {
      final path = p.join(root, name);
      if (await File(p.join(path, 'config.ini')).exists()) return path;
    }
    return null;
  }

  Future<void> start({
    required JdkInstallation jdk,
    required String workspacePath,
    int javaRelease = 21,
    Iterable<JdkInstallation> availableRuntimes = const [],
    String serverPath = '',
    String managedRoot = '',
  }) async {
    await stop();
    if (_disposed) return;
    final generation = ++_generation;
    _setState(JavaLanguageState.starting, 'Spouštím Java IntelliSense…');
    try {
      final root = await discoverServer(
        serverPath: serverPath,
        managedRoot: managedRoot,
      );
      if (_disposed || generation != _generation) return;
      if (root == null) {
        _setState(
          JavaLanguageState.unavailable,
          'Zapni Java IntelliSense v nastavení editoru.',
        );
        return;
      }
      final runtime =
          selectRuntime(preferred: jdk, available: availableRuntimes) ??
          await _bundledRuntime();
      if (_disposed || generation != _generation) return;
      if (runtime == null) {
        throw StateError(
          'Java IntelliSense potřebuje JDK 21 až 25. Nainstaluj JDK 25; '
          'vybrané JDK ${jdk.major} zůstane pro spouštění cvičení.',
        );
      }
      final workspace = await Directory(workspacePath).resolveSymbolicLinks();
      final session = await Directory.systemTemp.createTemp('aiva-jdtls-');
      if (_disposed || generation != _generation) {
        await session.delete(recursive: true);
        return;
      }
      _session = session;
      final configuration = await _configuration(root);
      await _copyDirectory(
        Directory(configuration!),
        Directory(p.join(session.path, 'config')),
      );
      final launchers = await Directory(p.join(root, 'plugins'))
          .list()
          .where(
            (f) =>
                p
                    .basename(f.path)
                    .startsWith('org.eclipse.equinox.launcher_') &&
                f.path.endsWith('.jar'),
          )
          .toList();
      launchers.sort((a, b) => b.path.compareTo(a.path));
      final environment = cleanJavaEnvironment(Platform.environment)
        ..removeWhere(
          (key, value) => {
            'CLIENT_PORT',
            'CLIENT_HOST',
            'CLIENT_IN_PORT',
            'CLIENT_OUT_PORT',
            'CLIENT_IN_HOST',
            'CLIENT_OUT_HOST',
            'CLIENT_IN_PATH',
            'CLIENT_OUT_PATH',
          }.contains(key.toUpperCase()),
        );
      final command = Command(runtime.java, [
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.level=ERROR',
        if (runtime.major >= 24) ...[
          '-Djdk.xml.maxGeneralEntitySizeLimit=0',
          '-Djdk.xml.totalEntitySizeLimit=0',
        ],
        '-Xmx768m',
        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',
        '-jar',
        launchers.first.path,
        '-configuration',
        p.join(session.path, 'config'),
        '-data',
        p.join(session.path, 'data'),
      ], workingDirectory: root);
      command.validate();
      final process = await Process.start(
        command.executable,
        command.arguments,
        workingDirectory: command.workingDirectory,
        environment: environment,
        includeParentEnvironment: false,
        runInShell: false,
      );
      if (_disposed || generation != _generation) {
        process.kill();
        return;
      }
      _process = process;
      // Always consume stderr, keeping diagnostics out of the LSP stream.
      process.stderr.listen((_) {});
      unawaited(process.stdin.done.catchError((Object _) {}));
      final decoder = LspMessageDecoder();
      process.stdout.listen((bytes) {
        if (generation != _generation) return;
        try {
          for (final message in decoder.add(bytes)) {
            _receive(message);
          }
        } on Object catch (error) {
          _failed(error, generation);
        }
      }, onError: (Object error) => _failed(error, generation));
      unawaited(
        process.exitCode.then((code) {
          if (generation == _generation && !_disposed) {
            _failed(StateError('Java server skončil (kód $code).'), generation);
          }
        }),
      );
      final sourcePaths = <String>[];
      for (final sourcePath in ['src/main/java', 'src/test/java', 'src']) {
        if (sourcePath == 'src' && sourcePaths.isNotEmpty) continue;
        if (await Directory(p.join(workspace, sourcePath)).exists()) {
          sourcePaths.add(sourcePath);
        }
      }
      // Maven-shaped folders are deliberately excluded from JDT's invisible
      // source projects even with Maven import disabled. A disposable Eclipse
      // project links the real source tree without changing IDE metadata in
      // the learner's workspace, and enables cross-file semantic diagnostics.
      final project = Directory(p.join(session.path, 'source-project'));
      await project.create();
      const xml = HtmlEscape(HtmlEscapeMode.element);
      await File(p.join(project.path, '.project')).writeAsString('''
<?xml version="1.0" encoding="UTF-8"?>
<projectDescription>
  <name>aiva-exercise</name>
  <buildSpec><buildCommand><name>org.eclipse.jdt.core.javabuilder</name><arguments/></buildCommand></buildSpec>
  <natures><nature>org.eclipse.jdt.core.javanature</nature></natures>
  <linkedResources><link><name>sources</name><type>2</type><locationURI>${xml.convert(Uri.directory(workspace).toString())}</locationURI></link></linkedResources>
</projectDescription>
''');
      final roots = sourcePaths.isEmpty ? [''] : sourcePaths;
      await File(p.join(project.path, '.classpath')).writeAsString('''
<?xml version="1.0" encoding="UTF-8"?>
<classpath>
${roots.map((root) => '  <classpathentry kind="src" path="sources${root.isEmpty ? '' : '/$root'}"/>').join('\n')}
  <classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER"/>
  <classpathentry kind="output" path="bin"/>
</classpath>
''');
      final projectSettings = Directory(p.join(project.path, '.settings'));
      await projectSettings.create();
      await File(
        p.join(projectSettings.path, 'org.eclipse.jdt.core.prefs'),
      ).writeAsString('''
eclipse.preferences.version=1
org.eclipse.jdt.core.compiler.codegen.targetPlatform=$javaRelease
org.eclipse.jdt.core.compiler.compliance=$javaRelease
org.eclipse.jdt.core.compiler.source=$javaRelease
''');
      _settings = {
        'java': {
          'home': runtime.home,
          'project': {
            'sourcePaths': sourcePaths.isEmpty ? ['.'] : sourcePaths,
          },
          'configuration': {
            'updateBuildConfiguration': 'automatic',
            'runtimes': [
              {
                'name': 'JavaSE-${runtime.major}',
                'path': runtime.home,
                'default': true,
              },
            ],
          },
          'completion': {'enabled': true, 'guessMethodArguments': false},
          'signatureHelp': {'enabled': true},
          'autobuild': {'enabled': true},
          'import': {
            // Course exercises are compiled directly with javac. Import them
            // as plain Java sources too, so editor assistance never waits for
            // Maven build plugins or downloads before becoming usable.
            'gradle': {'enabled': false},
            'maven': {'enabled': false},
          },
          'telemetry': {'enabled': false},
        },
      };
      final uri = Uri.directory(project.path).toString();
      await _request('initialize', {
        'processId': pid,
        'clientInfo': {'name': 'Aiva', 'version': '1.0'},
        'rootUri': uri,
        'workspaceFolders': [
          {'uri': uri, 'name': p.basename(workspace)},
        ],
        'capabilities': {
          'workspace': {'configuration': true, 'workspaceFolders': true},
          'textDocument': {
            'synchronization': {'didSave': true},
            'completion': {
              'completionItem': {
                'snippetSupport': false,
                'documentationFormat': ['plaintext'],
                'resolveSupport': {
                  'properties': [
                    'documentation',
                    'detail',
                    'additionalTextEdits',
                  ],
                },
              },
            },
            'hover': {
              'contentFormat': ['plaintext'],
            },
            'publishDiagnostics': {'versionSupport': true},
          },
        },
        'initializationOptions': {
          'workspaceFolders': [uri],
          'settings': _settings,
        },
      }, timeout: const Duration(seconds: 90));
      if (generation != _generation || _disposed) return;
      _notify('initialized', <String, dynamic>{});
      _notify('workspace/didChangeConfiguration', {'settings': _settings});
      _setState(
        JavaLanguageState.ready,
        'Java IntelliSense připraveno · JDK ${runtime.major}',
      );
    } on Object catch (error) {
      _failed(error, generation);
    }
  }

  void openDocument(String path, String text) {
    if (!isReady) return;
    final uri = Uri.file(path).toString();
    if (_documents.containsKey(uri)) {
      changeDocument(path, text);
      return;
    }
    _documents[uri] = (version: 1, text: text);
    _notify('textDocument/didOpen', {
      'textDocument': {
        'uri': uri,
        'languageId': 'java',
        'version': 1,
        'text': text,
      },
    });
  }

  void changeDocument(String path, String text) {
    if (!isReady) return;
    final uri = Uri.file(path).toString();
    final previous = _documents[uri];
    if (previous == null) {
      openDocument(path, text);
      return;
    }
    if (previous.text == text) return;
    final version = previous.version + 1;
    _documents[uri] = (version: version, text: text);
    _notify('textDocument/didChange', {
      'textDocument': {'uri': uri, 'version': version},
      'contentChanges': [
        {'text': text},
      ],
    });
  }

  void saveDocument(String path) {
    if (isReady) {
      _notify('textDocument/didSave', {
        'textDocument': {'uri': Uri.file(path).toString()},
      });
    }
  }

  void closeDocument(String path) {
    final uri = Uri.file(path).toString();
    if (_documents.remove(uri) != null && isReady) {
      _notify('textDocument/didClose', {
        'textDocument': {'uri': uri},
      });
    }
    diagnostics.remove(path);
  }

  Future<List<JavaCompletion>> complete(
    String path,
    String text,
    int offset,
  ) async {
    if (!isReady) return const [];
    changeDocument(path, text);
    final result = await _request('textDocument/completion', {
      'textDocument': {'uri': Uri.file(path).toString()},
      'position': JavaPosition.at(text, offset).toJson(),
      'context': {'triggerKind': 1},
    });
    final List<dynamic> items = result is List
        ? result
        : result is Map
        ? result['items'] as List? ?? const []
        : const [];
    return items
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => JavaCompletion.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<JavaCompletion> resolveCompletion(JavaCompletion completion) async {
    if (!isReady) return completion;
    final result = await _request('completionItem/resolve', completion.raw);
    return result is Map
        ? JavaCompletion.fromJson(Map<String, dynamic>.from(result))
        : completion;
  }

  Future<String?> hover(String path, String text, int offset) async {
    if (!isReady) return null;
    changeDocument(path, text);
    final result = await _request('textDocument/hover', {
      'textDocument': {'uri': Uri.file(path).toString()},
      'position': JavaPosition.at(text, offset).toJson(),
    });
    if (result is! Map) return null;
    String value(dynamic content) => content is String
        ? content
        : content is Map
        ? content['value'] as String? ?? ''
        : '';
    final contents = result['contents'];
    return contents is List
        ? contents.map(value).join('\n\n')
        : value(contents);
  }

  Future<dynamic> _request(
    String method,
    dynamic params, {
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final id = ++_nextId;
    final completer = Completer<dynamic>();
    _pending[id] = completer;
    try {
      _send({'jsonrpc': '2.0', 'id': id, 'method': method, 'params': params});
      return await completer.future.timeout(timeout);
    } on TimeoutException {
      _notify(r'$/cancelRequest', {'id': id});
      rethrow;
    } finally {
      _pending.remove(id);
    }
  }

  void _notify(String method, dynamic params) =>
      _send({'jsonrpc': '2.0', 'method': method, 'params': params});

  void _send(Map<String, dynamic> message) {
    final process = _process;
    if (process == null) return;
    final bytes = utf8.encode(jsonEncode(message));
    process.stdin.add(ascii.encode('Content-Length: ${bytes.length}\r\n\r\n'));
    process.stdin.add(bytes);
  }

  void _receive(Map<String, dynamic> message) {
    final method = message['method'];
    final id = message['id'];
    if (method == null && id is int) {
      final pending = _pending.remove(id);
      if (pending == null || pending.isCompleted) return;
      if (message['error'] != null) {
        final error = message['error'];
        pending.completeError(
          StateError(
            error is Map ? error['message'].toString() : error.toString(),
          ),
        );
      } else {
        pending.complete(message['result']);
      }
      return;
    }
    final params = message['params'];
    if (id != null) {
      dynamic result;
      if (method == 'workspace/configuration' && params is Map) {
        result = [
          for (final item in params['items'] as List? ?? const [])
            _section(item is Map ? item['section'] as String? : null),
        ];
      } else if (method == 'workspace/applyEdit') {
        result = {
          'applied': false,
          'failureReason': 'Edits must be selected in the editor.',
        };
      }
      _send({'jsonrpc': '2.0', 'id': id, 'result': result});
      return;
    }
    if (method == 'textDocument/publishDiagnostics' && params is Map) {
      final uri = Uri.tryParse(params['uri'] as String? ?? '');
      if (uri == null || uri.scheme != 'file') return;
      var documentUri = uri.toString();
      if (!_documents.containsKey(documentUri)) {
        // Eclipse may canonicalize linked locations with different casing
        // (e.g. /PRIVATE on macOS). Preserve the editor's original path while
        // still distinguishing files on case-sensitive volumes.
        for (final candidate in _documents.keys) {
          try {
            if (FileSystemEntity.identicalSync(
              uri.toFilePath(),
              Uri.parse(candidate).toFilePath(),
            )) {
              documentUri = candidate;
              break;
            }
          } on FileSystemException {
            // A deleted file cannot match an open document by identity.
          }
        }
      }
      final version = params['version'];
      final current = _documents[documentUri];
      if (version is int && current != null && version < current.version) {
        return;
      }
      diagnostics[Uri.parse(documentUri).toFilePath()] = [
        for (final item in params['diagnostics'] as List? ?? const [])
          if (item is Map)
            JavaDiagnostic.fromJson(Map<String, dynamic>.from(item)),
      ];
      if (!_disposed) notifyListeners();
    }
  }

  dynamic _section(String? name) {
    dynamic value = _settings;
    if (name == null || name.isEmpty) return value;
    for (final part in name.split('.')) {
      value = value is Map ? value[part] : null;
    }
    return value;
  }

  void _failed(Object error, int generation) {
    if (_disposed || generation != _generation) return;
    ++_generation;
    _setState(
      JavaLanguageState.error,
      'Java IntelliSense: ${error.toString().replaceFirst('Bad state: ', '')}',
    );
    final process = _process;
    _process = null;
    process?.kill();
    for (final pending in _pending.values) {
      if (!pending.isCompleted) pending.completeError(error);
    }
    _pending.clear();
  }

  void _setState(JavaLanguageState value, String message) {
    if (_disposed) return;
    state = value;
    statusMessage = message;
    notifyListeners();
  }

  Future<void> stop() async {
    ++_generation;
    _setState(JavaLanguageState.stopped, 'Java IntelliSense');
    final process = _process;
    final session = _session;
    _process = null;
    _session = null;
    _documents.clear();
    diagnostics.clear();
    for (final pending in _pending.values) {
      if (!pending.isCompleted) {
        pending.completeError(StateError('Java server byl zastaven.'));
      }
    }
    _pending.clear();
    if (process != null) {
      process.kill();
      try {
        await process.exitCode.timeout(const Duration(seconds: 2));
      } on TimeoutException {
        process.kill(ProcessSignal.sigkill);
      }
    }
    if (session != null) {
      try {
        await session.delete(recursive: true);
      } on FileSystemException {
        /* OS may retain a short-lived file lock. */
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(stop());
    super.dispose();
  }
}

/// Explicit, one-time installation from the official Eclipse release archive.
final class JavaLanguageServerInstaller {
  static final Map<String, Future<String>> _installations = {};
  static const version = '1.57.0';
  static const archiveName = 'jdt-language-server-1.57.0-202602261110.tar.gz';
  static const archiveSha256 =
      'f7ffa93fe1bbbea95dac13dd97cdcd25c582d6e56db67258da0dcceb2302601e';
  static final downloadUri = Uri.parse(
    'https://download.eclipse.org/jdtls/milestones/$version/$archiveName',
  );

  static Future<String> install({
    required String installRoot,
    void Function(double? progress, String message)? onProgress,
  }) {
    final key = p.normalize(installRoot);
    return _installations.putIfAbsent(
      key,
      () => _install(installRoot: installRoot, onProgress: onProgress)
          .whenComplete(() {
            _installations.remove(key);
          }),
    );
  }

  static Future<String> _install({
    required String installRoot,
    void Function(double? progress, String message)? onProgress,
  }) async {
    if (!p.isAbsolute(installRoot)) {
      throw ArgumentError('Instalace potřebuje absolutní cestu.');
    }
    await Directory(installRoot).create(recursive: true);
    final destination = p.join(installRoot, version);
    final existing = await JavaLanguageService.discoverServer(
      serverPath: destination,
    );
    if (existing != null) return existing;
    final staging = await Directory(installRoot).createTemp('.download-');
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 30);
    try {
      onProgress?.call(null, 'Stahuji Java IntelliSense z Eclipse…');
      final request = await client
          .getUrl(downloadUri)
          .timeout(const Duration(seconds: 30));
      request.followRedirects = false;
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('Eclipse vrátil HTTP ${response.statusCode}.');
      }
      final archive = File(p.join(staging.path, 'server.tar.gz'));
      final sink = archive.openWrite();
      var received = 0;
      try {
        await for (final chunk in response.timeout(
          const Duration(seconds: 30),
        )) {
          received += chunk.length;
          if (received > 100 * 1024 * 1024) {
            throw const FormatException('Instalace překročila limit 100 MB.');
          }
          sink.add(chunk);
          onProgress?.call(
            response.contentLength > 0
                ? received / response.contentLength
                : null,
            'Stahuji Java IntelliSense… ${(received / 1024 / 1024).toStringAsFixed(1)} MB',
          );
        }
      } finally {
        await sink.close();
      }
      final digest = await sha256.bind(archive.openRead()).first;
      if (digest.toString() != archiveSha256) {
        throw const FormatException(
          'Stažený soubor neprošel ověřením SHA-256. Zkus instalaci znovu.',
        );
      }
      onProgress?.call(null, 'Připravuji Java IntelliSense…');
      final tar = Platform.isWindows
          ? p.join(
              Platform.environment['SystemRoot'] ?? r'C:\Windows',
              'System32',
              'tar.exe',
            )
          : '/usr/bin/tar';
      if (!await File(tar).exists()) {
        throw StateError(
          'Chybí systémový tar. Rozbal Eclipse JDT LS ručně a vyber jeho složku.',
        );
      }
      final listing = await const ProcessRunner().run(
        Command(tar, ['-tzf', archive.path]),
        timeout: const Duration(seconds: 30),
        maxOutputBytes: 1024 * 1024,
      );
      if (!listing.succeeded) {
        throw StateError('Archiv Java serveru nelze přečíst.');
      }
      for (final entry in const LineSplitter().convert(listing.stdout)) {
        if (entry.startsWith('/') ||
            entry.contains('\\') ||
            entry.split('/').contains('..')) {
          throw const FormatException('Archiv obsahuje neplatnou cestu.');
        }
      }
      final extracted = await Directory(
        p.join(staging.path, 'server'),
      ).create();
      final unpack = await const ProcessRunner().run(
        Command(tar, ['-xzf', archive.path, '-C', extracted.path]),
        timeout: const Duration(seconds: 60),
      );
      if (!unpack.succeeded ||
          await JavaLanguageService.discoverServer(
                serverPath: extracted.path,
              ) ==
              null) {
        throw StateError('Java server se nepodařilo rozbalit.');
      }
      if (await Directory(destination).exists()) {
        throw StateError(
          'Cílová složka už existuje, ale neobsahuje platný Java server. Vyber jinou složku.',
        );
      }
      await extracted.rename(destination);
      onProgress?.call(1, 'Java IntelliSense je připraveno.');
      return destination;
    } finally {
      client.close(force: true);
      await staging.delete(recursive: true);
    }
  }
}

Future<List<String>> _directories(String path) async {
  try {
    return await Directory(path)
        .list()
        .where((item) => item is Directory)
        .map((item) => item.path)
        .take(128)
        .toList();
  } on FileSystemException {
    return const [];
  }
}

Future<void> _copyDirectory(Directory source, Directory destination) async {
  await destination.create(recursive: true);
  await for (final entity in source.list(followLinks: false)) {
    final target = p.join(destination.path, p.basename(entity.path));
    if (entity is File) await entity.copy(target);
    if (entity is Directory) await _copyDirectory(entity, Directory(target));
  }
}
