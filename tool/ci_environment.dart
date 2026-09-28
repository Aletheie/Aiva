import 'dart:io';

Future<void> main() async {
  final file = Platform.environment['GITHUB_ENV'];
  if (file == null) throw StateError('GITHUB_ENV missing');
  await File(file).writeAsString(
    'DART_EXECUTABLE=${Platform.resolvedExecutable}\n',
    mode: FileMode.append,
  );
}
