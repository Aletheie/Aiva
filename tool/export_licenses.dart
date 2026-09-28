// Export actual resolved-package license notices; no third-party tooling needed.
// Run only after flutter pub get. The UI also exposes Flutter LicenseRegistry.
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final root = File.fromUri(Platform.script).parent.parent;
  final configuration = File('${root.path}/.dart_tool/package_config.json');
  if (!await configuration.exists()) {
    throw StateError('Run flutter pub get before exporting licenses.');
  }
  final data =
      jsonDecode(await configuration.readAsString()) as Map<String, dynamic>;
  final packages = (data['packages'] as List<dynamic>)
      .cast<Map<String, dynamic>>();
  final output = StringBuffer(
    'AIVA resolved-package notices\n'
    'Generated from the installed package sources. Includes development dependencies.\n\n',
  );
  var notices = 0;
  for (final package in packages) {
    final name = package['name'] as String;
    if (name == 'aiva') continue;
    final uri = configuration.uri.resolve(package['rootUri'] as String);
    final directory = Directory.fromUri(uri);
    final candidates = <File>[];
    await for (final entry in directory.list(followLinks: true)) {
      if (entry is File &&
          RegExp(
            r'^(LICENSE|LICENCE|COPYING|NOTICE)(\..*)?$',
            caseSensitive: false,
          ).hasMatch(entry.uri.pathSegments.last)) {
        candidates.add(entry);
      }
    }
    // Flutter's package LICENSE can live at the SDK root.
    if (name == 'flutter') {
      final sdkLicense = File('${directory.parent.parent.path}/LICENSE');
      if (await sdkLicense.exists()) candidates.add(sdkLicense);
    }
    final seen = <String>{};
    for (final file in candidates) {
      final text = await file.readAsString();
      if (!seen.add(text)) continue;
      output.writeln(
        '================================================================',
      );
      output.writeln(name);
      output.writeln(
        '================================================================',
      );
      output.writeln(text);
      output.writeln();
      notices++;
    }
    if (candidates.isEmpty) {
      output.writeln(
        '$name: no top-level license file found; review upstream.\n',
      );
    }
  }
  if (notices == 0) {
    throw StateError(
      'No package licenses were found; do not ship an empty notice file.',
    );
  }
  final file = File('${root.path}/build/legal/DEPENDENCY-LICENSES.txt');
  await file.parent.create(recursive: true);
  await file.writeAsString(output.toString());
  stdout.writeln('$notices license texts exported to ${file.path}');
}
