// Generate missing desktop runners and refresh the content index.
import 'dart:io';

Future<void> run(String executable, List<String> args, {String? cwd}) async {
  stdout.writeln('> $executable ${args.join(' ')}');
  final child = await Process.start(
    executable,
    args,
    workingDirectory: cwd,
    runInShell: Platform.isWindows && executable.endsWith('.bat'),
    mode: ProcessStartMode.inheritStdio,
  );
  final code = await child.exitCode;
  if (code != 0) {
    throw ProcessException(executable, args, 'Command failed', code);
  }
}

Future<void> copyTree(Directory source, Directory target) async {
  await target.create(recursive: true);
  await for (final entry in source.list(followLinks: false)) {
    final name = entry.uri.pathSegments.where((e) => e.isNotEmpty).last;
    final path = '${target.path}/$name';
    if (entry is Directory) {
      await copyTree(entry, Directory(path));
    } else if (entry is File) {
      await entry.copy(path);
    } else {
      throw FileSystemException(
        'Unexpected symlink in host template.',
        entry.path,
      );
    }
  }
}

Future<void> replaceIn(
  File file,
  String from,
  String to, {
  bool required = true,
}) async {
  if (!await file.exists()) {
    if (required) {
      throw FileSystemException(
        'Flutter template changed: missing file.',
        file.path,
      );
    }
    return;
  }
  final text = await file.readAsString();
  if (!text.contains(from)) {
    if (required) {
      throw StateError(
        'Flutter template changed: ${file.path} is missing $from',
      );
    }
    return;
  }
  await file.writeAsString(text.replaceAll(from, to));
}

Future<void> main() async {
  final root = File.fromUri(Platform.script).parent.parent;
  final flutter =
      Platform.environment['FLUTTER_EXECUTABLE'] ??
      (Platform.isWindows ? 'flutter.bat' : 'flutter');
  final missing = [
    for (final os in ['macos', 'windows', 'linux'])
      if (!await Directory('${root.path}/$os').exists()) os,
  ];
  if (missing.isNotEmpty) {
    final temporary = await Directory.systemTemp.createTemp('aiva-host-');
    try {
      final generated = Directory('${temporary.path}/aiva');
      await run(flutter, [
        'create',
        '--no-pub',
        '--template=app',
        '--project-name=aiva',
        '--org=dev.aiva',
        '--platforms=${missing.join(',')}',
        generated.path,
      ]);
      for (final os in missing) {
        // Finish template patches before installing the host directory.
        final host = Directory('${generated.path}/$os');
        if (os == 'macos') {
          await copyTree(
            Directory('${root.path}/platform_overlays/macos'),
            host,
          );
          await replaceIn(
            File('${host.path}/Runner.xcodeproj/project.pbxproj'),
            'aiva.app',
            'AIVA.app',
          );
          await replaceIn(
            File('${host.path}/Runner.xcodeproj/project.pbxproj'),
            r'$(BUNDLE_EXECUTABLE_FOLDER_PATH)/aiva',
            r'$(BUNDLE_EXECUTABLE_FOLDER_PATH)/AIVA',
          );
          await replaceIn(
            File('${host.path}/Runner.xcodeproj/project.pbxproj'),
            'dev.aiva.aiva.RunnerTests',
            'dev.aiva.desktop.RunnerTests',
          );
          await replaceIn(
            File(
              '${host.path}/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme',
            ),
            'aiva.app',
            'AIVA.app',
          );
        } else if (os == 'windows') {
          await replaceIn(
            File('${host.path}/CMakeLists.txt'),
            'set(BINARY_NAME "aiva")',
            'set(BINARY_NAME "AIVA")',
          );
          final main = File('${host.path}/runner/main.cpp');
          await replaceIn(main, 'L"aiva"', 'L"AIVA"');
          await replaceIn(main, '1280, 720', '1320, 880', required: false);
          await File(
            '${root.path}/packaging/windows/app_icon.ico',
          ).copy('${host.path}/runner/resources/app_icon.ico');
          await replaceIn(
            File('${host.path}/runner/Runner.rc'),
            'aiva',
            'AIVA',
            required: false,
          );
          await replaceIn(
            File('${host.path}/runner/win32_window.cpp'),
            'switch (message) {',
            '''switch (message) {
    case WM_GETMINMAXINFO: {
      auto info = reinterpret_cast<MINMAXINFO*>(lparam);
      const UINT dpi = GetDpiForWindow(hwnd);
      info->ptMinTrackSize.x = MulDiv(840, dpi, 96);
      info->ptMinTrackSize.y = MulDiv(600, dpi, 96);
      return 0;
    }''',
            required: false,
          );
        } else {
          var app = File('${host.path}/runner/my_application.cc');
          if (!await app.exists()) app = File('${host.path}/my_application.cc');
          await replaceIn(app, '"aiva"', '"AIVA"', required: false);
          await replaceIn(app, '1280, 720', '1320, 880', required: false);
        }
        await host.rename('${root.path}/$os').catchError((Object _) async {
          // Cross-volume temporary directories cannot be renamed atomically.
          await copyTree(host, Directory('${root.path}/$os'));
          return Directory('${root.path}/$os');
        });
      }
      final metadata = File('${root.path}/.metadata');
      if (!await metadata.exists()) {
        await File('${generated.path}/.metadata').copy(metadata.path);
      }
    } finally {
      await temporary.delete(recursive: true);
    }
  }
  // App Sandbox would prevent execution of the student's JDK.
  final entitlements = File('${root.path}/macos/Runner/Release.entitlements');
  if (await entitlements.exists()) {
    final text = await entitlements.readAsString();
    if (!RegExp(
      r'<key>com\.apple\.security\.app-sandbox</key>\s*<false\s*/>',
    ).hasMatch(text)) {
      throw StateError(
        'Set com.apple.security.app-sandbox to false in macos/Runner/Release.entitlements to allow external JDK execution.',
      );
    }
  }
  await run(Platform.resolvedExecutable, [
    '${root.path}/tool/content_index.dart',
  ], cwd: root.path);
  stdout.writeln(
    'Host runners ready. Next: flutter pub get, then flutter run -d ${Platform.operatingSystem}',
  );
}
