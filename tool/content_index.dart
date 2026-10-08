import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> arguments) async {
  final root = File.fromUri(Platform.script).parent.parent;
  final content = Directory('${root.path}/content');
  final files = <Map<String, Object>>[];
  await for (final entry in content.list(recursive: true, followLinks: false)) {
    if (entry is Link) {
      throw FileSystemException(
        'Content must not contain symlinks.',
        entry.path,
      );
    }
    if (entry is! File) continue;
    final relative = entry.path
        .substring(content.path.length + 1)
        .replaceAll('\\', '/');
    if (relative.contains("'") || relative.contains('\n')) {
      throw FormatException('Unsupported asset name: $relative');
    }
    files.add({'path': relative, 'bytes': await entry.length()});
  }
  files.sort((a, b) => (a['path']! as String).compareTo(b['path']! as String));
  const encoder = JsonEncoder.withIndent('  ');
  final json = '${encoder.convert({'schemaVersion': 1, 'files': files})}\n';
  final indexFile = File('${root.path}/assets/content-index.json');
  final pubspec = File('${root.path}/pubspec.yaml');
  const begin = '    # BEGIN GENERATED CONTENT ASSETS';
  const end = '    # END GENERATED CONTENT ASSETS';
  final previous = await pubspec.readAsString();
  final start = previous.indexOf(begin);
  final stop = previous.indexOf(end);
  if (start < 0 || stop < start) {
    throw StateError('pubspec.yaml is missing generated asset markers.');
  }
  final assetLines = files
      .map((file) => "    - 'content/${file['path']}'")
      .join('\n');
  final generated = '$begin\n$assetLines\n$end';
  final updated = previous.replaceRange(start, stop + end.length, generated);
  final previousIndex = await indexFile.exists()
      ? await indexFile.readAsString()
      : null;
  if (arguments.contains('--check')) {
    if (previousIndex != json || previous != updated) {
      stderr.writeln(
        'Content index is stale. Run dart tool/content_index.dart',
      );
      exitCode = 1;
      return;
    }
  } else {
    // The Windows build runs this every time; keep unchanged inputs untouched
    // so an incremental build does not invalidate Flutter's asset cache.
    if (previousIndex != json) await indexFile.writeAsString(json);
    if (previous != updated) await pubspec.writeAsString(updated);
  }
  stdout.writeln('${files.length} content files indexed.');
}
