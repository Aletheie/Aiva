import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import '../platform/safe_paths.dart';

abstract class ContentSource {
  Future<List<int>> readBytes(String relative);
  Future<List<String>> filesUnder(String relative);
  Future<String> readText(String relative) async {
    final bytes = await readBytes(relative);
    if (bytes.length > 8 * 1024 * 1024) {
      throw FormatException('$relative: soubor přesahuje 8 MiB.');
    }
    try {
      return utf8.decode(bytes, allowMalformed: false);
    } on FormatException {
      throw FormatException('$relative: neplatné UTF-8.');
    }
  }
}

final class DirectoryContentSource extends ContentSource {
  DirectoryContentSource(this.root);
  final String root;
  @override
  Future<List<int>> readBytes(String relative) async {
    final file = File(await resolveInside(root, relative, mustExist: true));
    if (await file.length() > 8 * 1024 * 1024) {
      throw FormatException('$relative: soubor přesahuje 8 MiB.');
    }
    return file.readAsBytes();
  }

  @override
  Future<List<String>> filesUnder(String relative) async {
    final directory = await resolveInside(root, relative, mustExist: true);
    final canonicalRoot = await Directory(root).resolveSymbolicLinks();
    final result = <String>[];
    var count = 0;
    await for (final entry in Directory(
      directory,
    ).list(recursive: true, followLinks: false)) {
      if (++count > 1000) {
        throw FormatException('$relative: příliš mnoho souborů.');
      }
      if (entry is Link) {
        throw FormatException('$relative: starter obsahuje symbolický odkaz.');
      }
      if (entry is File) {
        result.add(
          p
              .relative(entry.path, from: canonicalRoot)
              .split(p.separator)
              .join('/'),
        );
      } else if (entry is! Directory) {
        throw FormatException('$relative: nepovolený typ souboru.');
      }
    }
    return result..sort();
  }
}
