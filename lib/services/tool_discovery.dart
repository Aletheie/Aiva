import 'dart:io';
import 'package:path/path.dart' as p;
import '../domain/course.dart';
import '../platform/process_runner.dart';

final class JdkInstallation {
  const JdkInstallation({
    required this.home,
    required this.java,
    required this.javac,
    required this.major,
    required this.version,
  });
  final String home;
  final String java;
  final String javac;
  final int major;
  final String version;
  String get label => 'JDK $major · $home';
}

final class EditorInstallation {
  const EditorInstallation({
    required this.name,
    required this.path,
    this.isBundle = false,
  });
  final String name;
  final String path;
  final bool isBundle;
}

final class ToolReport {
  const ToolReport({
    this.jdks = const [],
    this.editors = const [],
    this.notes = const [],
  });
  final List<JdkInstallation> jdks;
  final List<EditorInstallation> editors;
  final List<String> notes;
}

final class ToolDiscovery {
  const ToolDiscovery({this.processes = const ProcessRunner()});
  final ProcessRunner processes;

  Future<ToolReport> discover({
    String preferredJdk = '',
    String preferredEditor = '',
  }) async {
    final homes = <String>{if (preferredJdk.isNotEmpty) preferredJdk};
    final env = Platform.environment;
    for (final key in ['JAVA_HOME', 'JDK_HOME']) {
      final home = env[key];
      if (home != null && home.isNotEmpty) homes.add(home);
    }
    final javac = await _onPath(Platform.isWindows ? 'javac.exe' : 'javac');
    if (javac != null) {
      try {
        homes.add(
          p.dirname(p.dirname(await File(javac).resolveSymbolicLinks())),
        );
      } on FileSystemException {
        // Continue with installed JDK locations if PATH contains a broken link.
      }
    }
    if (Platform.isMacOS) {
      for (final root in [
        '/Library/Java/JavaVirtualMachines',
        '${env['HOME']}/Library/Java/JavaVirtualMachines',
      ]) {
        for (final directory in await _directories(root)) {
          homes.add(p.join(directory, 'Contents', 'Home'));
        }
      }
      for (final base in ['/opt/homebrew/opt', '/usr/local/opt']) {
        for (final version in ['openjdk', 'openjdk@21', 'openjdk@25']) {
          homes.add(
            p.join(base, version, 'libexec', 'openjdk.jdk', 'Contents', 'Home'),
          );
        }
      }
    } else if (Platform.isWindows) {
      for (final root in [
        env['ProgramFiles'],
        env['ProgramFiles(x86)'],
      ].whereType<String>()) {
        for (final vendor in [
          'Java',
          'Eclipse Adoptium',
          'Microsoft',
          'Amazon Corretto',
          'Zulu',
        ]) {
          homes.addAll(await _directories(p.join(root, vendor)));
        }
      }
      if (env['USERPROFILE'] != null) {
        homes.addAll(await _directories(p.join(env['USERPROFILE']!, '.jdks')));
      }
    } else {
      homes.addAll(await _directories('/usr/lib/jvm'));
      homes.addAll(await _directories('/opt/java'));
      if (env['HOME'] != null) {
        homes.addAll(await _directories(p.join(env['HOME']!, '.jdks')));
        homes.addAll(
          await _directories(
            p.join(env['HOME']!, '.sdkman', 'candidates', 'java'),
          ),
        );
      }
    }
    final jdks = <JdkInstallation>[];
    final notes = <String>[];
    final seen = <String>{};
    for (final home in homes.take(48)) {
      try {
        if (!await Directory(home).exists()) continue;
        final canonical = await Directory(home).resolveSymbolicLinks();
        if (!seen.add(canonical)) continue;
        final jdk = await inspectJdk(canonical);
        jdks.add(jdk);
      } on Object catch (error) {
        if (home == preferredJdk) notes.add('Vybrané JDK: $error');
      }
    }
    jdks.sort((a, b) {
      if (a.major == 25 && b.major != 25) return -1;
      if (b.major == 25 && a.major != 25) return 1;
      return b.major.compareTo(a.major);
    });
    final candidates = <EditorInstallation>[];
    if (preferredEditor.isNotEmpty) {
      try {
        candidates.add(await inspectEditor(preferredEditor));
      } on Object catch (e) {
        notes.add('Vybraný editor: $e');
      }
    }
    if (Platform.isMacOS) {
      for (final root in ['/Applications', '${env['HOME']}/Applications']) {
        for (final name in [
          'IntelliJ IDEA.app',
          'IntelliJ IDEA CE.app',
          'Visual Studio Code.app',
        ]) {
          final path = p.join(root, name);
          if (await Directory(path).exists()) {
            candidates.add(
              EditorInstallation(
                name: name.replaceAll('.app', ''),
                path: path,
                isBundle: true,
              ),
            );
          }
        }
        for (final directory in await _directories(root)) {
          if (p.basename(directory).startsWith('IntelliJ IDEA') &&
              directory.endsWith('.app')) {
            candidates.add(
              EditorInstallation(
                name: 'IntelliJ IDEA',
                path: directory,
                isBundle: true,
              ),
            );
          }
        }
      }
    } else if (Platform.isWindows) {
      for (final root in [
        env['ProgramFiles'],
        env['LOCALAPPDATA'] == null
            ? null
            : p.join(env['LOCALAPPDATA']!, 'Programs'),
      ].whereType<String>()) {
        final code = p.join(root, 'Microsoft VS Code', 'Code.exe');
        if (await File(code).exists()) {
          candidates.add(EditorInstallation(name: 'VS Code', path: code));
        }
        for (final idea in await _directories(p.join(root, 'JetBrains'))) {
          final exe = p.join(idea, 'bin', 'idea64.exe');
          if (await File(exe).exists()) {
            candidates.add(
              EditorInstallation(name: 'IntelliJ IDEA', path: exe),
            );
          }
        }
      }
    }
    for (final name
        in Platform.isWindows
            ? ['idea64.exe', 'Code.exe']
            : ['idea', 'idea.sh', 'code']) {
      final path = await _onPath(name);
      if (path != null) {
        candidates.add(
          EditorInstallation(
            name: name.toLowerCase().contains('idea')
                ? 'IntelliJ IDEA'
                : 'VS Code',
            path: path,
          ),
        );
      }
    }
    final unique = <String>{};
    final editors = candidates.where((e) => unique.add(e.path)).toList();
    // Prefer IDEA when no editor was selected explicitly.
    editors.sort(
      (a, b) => (a.name.contains('IntelliJ') ? 0 : 1).compareTo(
        b.name.contains('IntelliJ') ? 0 : 1,
      ),
    );
    return ToolReport(
      jdks: List.unmodifiable(jdks),
      editors: List.unmodifiable(editors),
      notes: List.unmodifiable(notes),
    );
  }

  Future<JdkInstallation> inspectJdk(String selected) async {
    if (!p.isAbsolute(selected)) {
      throw ArgumentError('Vyber absolutní cestu k JDK.');
    }
    var home = selected;
    if (home.endsWith('.jdk')) home = p.join(home, 'Contents', 'Home');
    home = await Directory(home).resolveSymbolicLinks();
    final suffix = Platform.isWindows ? '.exe' : '';
    final java = p.join(home, 'bin', 'java$suffix');
    final javac = p.join(home, 'bin', 'javac$suffix');
    if (!await File(java).exists() || !await File(javac).exists()) {
      throw ArgumentError(
        'Složka musí obsahovat bin/java a bin/javac, ne jen JRE.',
      );
    }
    final runtime = await processes.run(
      Command(java, ['--version']),
      timeout: const Duration(seconds: 3),
    );
    final compiler = await processes.run(
      Command(javac, ['--version']),
      timeout: const Duration(seconds: 3),
    );
    final major = parseJdkMajor('${runtime.stdout}\n${runtime.stderr}');
    final compilerMajor = parseJdkMajor(
      '${compiler.stdout}\n${compiler.stderr}',
    );
    if (!runtime.succeeded ||
        !compiler.succeeded ||
        major == null ||
        major < 21 ||
        major != compilerMajor) {
      throw ArgumentError(
        'Potřebujeme funkční JDK 21+ se stejnou verzí java a javac.',
      );
    }
    return JdkInstallation(
      home: home,
      java: java,
      javac: javac,
      major: major,
      version: '${runtime.stdout}${runtime.stderr}'.trim(),
    );
  }

  Future<EditorInstallation> inspectEditor(String path) async {
    if (!p.isAbsolute(path)) {
      throw ArgumentError('Vyber absolutní cestu k editoru.');
    }
    if (Platform.isMacOS &&
        path.endsWith('.app') &&
        await Directory(path).exists()) {
      return EditorInstallation(
        name: p.basenameWithoutExtension(path),
        path: path,
        isBundle: true,
      );
    }
    if (!await File(path).exists()) {
      throw ArgumentError('Spustitelný soubor editoru neexistuje.');
    }
    Command(path, const []).validate();
    return EditorInstallation(
      name: p.basenameWithoutExtension(path),
      path: path,
    );
  }

  static Future<String?> _onPath(String name) async {
    final separator = Platform.isWindows ? ';' : ':';
    for (final directory in (Platform.environment['PATH'] ?? '').split(
      separator,
    )) {
      // Relative PATH entries could resolve to a program in the workspace.
      if (!p.isAbsolute(directory)) continue;
      final candidate = p.join(directory, name);
      if (await File(candidate).exists()) return candidate;
    }
    return null;
  }

  static Future<List<String>> _directories(String root) async {
    try {
      if (!await Directory(root).exists()) return const [];
      final result = <String>[];
      await for (final entry in Directory(root).list(followLinks: true)) {
        if (entry is Directory) result.add(entry.path);
        if (result.length >= 128) break;
      }
      return result;
    } on FileSystemException {
      return const [];
    }
  }
}

Command editorCommand(EditorInstallation editor, String workspace) {
  if (!p.isAbsolute(workspace)) throw ArgumentError('Neplatný workspace.');
  if (editor.isBundle) {
    return Command('/usr/bin/open', ['-a', editor.path, '--', workspace]);
  }
  final command = Command(editor.path, [workspace]);
  command.validate();
  return command;
}

Future<void> openEditor(EditorInstallation editor, String workspace) async {
  final command = editorCommand(editor, workspace);
  if (editor.isBundle) {
    final report = await const ProcessRunner().run(command);
    if (!report.succeeded) {
      throw ProcessException(
        command.executable,
        command.arguments,
        report.stderr,
      );
    }
  } else {
    await Process.start(
      command.executable,
      command.arguments,
      runInShell: false,
      mode: ProcessStartMode.detached,
    );
  }
}
