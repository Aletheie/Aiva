import 'dart:convert';
import 'dart:io';

import 'package:aiva/services/java_language_service.dart';
import 'package:aiva/services/tool_discovery.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  JdkInstallation runtime(int major) => JdkInstallation(
    home: '/jdk/$major',
    java: '/jdk/$major/bin/java',
    javac: '/jdk/$major/bin/javac',
    major: major,
    version: '$major',
  );

  test('language server keeps a compatible preferred JDK', () {
    final preferred = runtime(21);
    expect(
      JavaLanguageService.selectRuntime(
        preferred: preferred,
        available: [runtime(25)],
      ),
      same(preferred),
    );
  });

  test(
    'language server selects a compatible runtime independently of JDK27',
    () {
      final lts = runtime(25);
      expect(
        JavaLanguageService.selectRuntime(
          preferred: runtime(27),
          available: [runtime(17), runtime(21), lts, runtime(27)],
        ),
        same(lts),
      );
      expect(
        JavaLanguageService.selectRuntime(
          preferred: runtime(27),
          available: [runtime(17), runtime(27)],
        ),
        isNull,
      );
    },
  );

  test(
    'automatic discovery tolerates missing editor extension directories',
    () async {
      final discovered = await JavaLanguageService.discoverServer();
      expect(discovered, anyOf(isNull, isA<String>()));
    },
  );

  test('LSP framing preserves unicode across arbitrary byte boundaries', () {
    final message = {
      'jsonrpc': '2.0',
      'id': 1,
      'result': 'Příliš žluťoučký 🦊',
    };
    final payload = utf8.encode(jsonEncode(message));
    final framed = [
      ...ascii.encode(
        'Content-Length: ${payload.length}\r\nContent-Type: application/vscode-jsonrpc; charset=utf-8\r\n\r\n',
      ),
      ...payload,
    ];
    final decoder = LspMessageDecoder();
    final received = <Map<String, dynamic>>[];
    for (final byte in [...framed, ...framed]) {
      received.addAll(decoder.add([byte]));
    }
    expect(received, [message, message]);
  });

  test('LSP rejects invalid and oversized messages before allocation', () {
    expect(
      () => LspMessageDecoder().add(
        ascii.encode('Content-Length: 9999999999\r\n\r\n'),
      ),
      throwsFormatException,
    );
    expect(
      () => LspMessageDecoder().add(ascii.encode('No-Length: 5\r\n\r\n')),
      throwsFormatException,
    );
  });

  test('Java positions roundtrip UTF-16 offsets including emoji and CRLF', () {
    const text = 'class Příliš { // 🦊\r\n  String value;\r\n}';
    final offset = text.indexOf('value') + 3;
    final position = JavaPosition.at(text, offset);
    expect(position.line, 1);
    expect(position.character, 12);
    expect(position.offsetIn(text), offset);
  });

  test('semantic completion replaces a range and adds the server import', () {
    const source = 'class Main {\n  Arr value;\n}\n';
    final completion = JavaCompletion.fromJson({
      'label': 'ArrayList',
      'detail': 'java.util.ArrayList',
      'textEdit': {
        'range': {
          'start': {'line': 1, 'character': 2},
          'end': {'line': 1, 'character': 5},
        },
        'newText': 'ArrayList',
      },
      'additionalTextEdits': [
        {
          'range': {
            'start': {'line': 0, 'character': 0},
            'end': {'line': 0, 'character': 0},
          },
          'newText': 'import java.util.ArrayList;\n\n',
        },
      ],
    });
    final result = completion.apply(source, source.indexOf('Arr') + 3);
    expect(
      result.text,
      'import java.util.ArrayList;\n\nclass Main {\n  ArrayList value;\n}\n',
    );
    expect(
      result.offset,
      result.text.lastIndexOf('ArrayList') + 'ArrayList'.length,
    );
  });

  test(
    'completion without a text edit only replaces the current identifier',
    () {
      const source = 'System.out.pr';
      final result = JavaCompletion.fromJson({
        'label': 'println',
        'insertText': 'println()',
      }).apply(source, source.length);
      expect(result.text, 'System.out.println()');
      expect(result.offset, result.text.length);
    },
  );

  test(
    'explicit invalid server selection never falls back to another server',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'aiva-jdtls-discovery-test-',
      );
      addTearDown(() => root.delete(recursive: true));
      final plugins = await Directory(p.join(root.path, 'plugins')).create();
      await File(
        p.join(plugins.path, 'org.eclipse.equinox.launcher_1.0.jar'),
      ).writeAsString('fake');
      expect(
        await JavaLanguageService.discoverServer(serverPath: root.path),
        isNull,
      );
      final platform = Platform.isMacOS
          ? 'mac'
          : Platform.isWindows
          ? 'win'
          : 'linux';
      final config = await Directory(
        p.join(root.path, 'config_$platform'),
      ).create();
      await File(p.join(config.path, 'config.ini')).writeAsString('');
      expect(
        await JavaLanguageService.discoverServer(serverPath: root.path),
        await root.resolveSymbolicLinks(),
      );
      expect(
        await JavaLanguageService.discoverServer(
          serverPath: p.join(root.path, 'missing'),
          managedRoot: root.path,
        ),
        isNull,
      );
    },
  );

  test(
    'managed installation reuses an existing server without network access',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'aiva-jdtls-install-test-',
      );
      addTearDown(() => root.delete(recursive: true));
      final installation = Directory(
        p.join(root.path, JavaLanguageServerInstaller.version),
      );
      final plugins = await Directory(
        p.join(installation.path, 'plugins'),
      ).create(recursive: true);
      await File(
        p.join(plugins.path, 'org.eclipse.equinox.launcher_1.0.jar'),
      ).writeAsString('fake');
      final platform = Platform.isMacOS
          ? 'mac'
          : Platform.isWindows
          ? 'win'
          : 'linux';
      final config = await Directory(
        p.join(installation.path, 'config_$platform'),
      ).create();
      await File(p.join(config.path, 'config.ini')).writeAsString('');
      final first = JavaLanguageServerInstaller.install(installRoot: root.path);
      final second = JavaLanguageServerInstaller.install(
        installRoot: root.path,
      );
      expect(identical(first, second), isTrue);
      expect(
        await first.timeout(const Duration(seconds: 3)),
        await installation.resolveSymbolicLinks(),
      );
    },
  );
}
