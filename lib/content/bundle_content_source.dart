import 'package:flutter/services.dart';
import '../platform/safe_paths.dart';
import 'content_source.dart';
import 'strict_json.dart';

final class BundleContentSource extends ContentSource {
  BundleContentSource._(this._contents);
  final Map<String, List<int>> _contents;

  static Future<BundleContentSource> load([AssetBundle? bundle]) async {
    final b = bundle ?? rootBundle;
    final index = decodeObject(
      await b.loadString('assets/content-index.json', cache: false),
      'assets/content-index.json',
    );
    if (index['schemaVersion'] != 1) {
      throw const FormatException('Neznámá verze indexu obsahu.');
    }
    final entries = index['files'];
    if (entries is! List<Object?>) {
      throw const FormatException('Chybí index obsahu.');
    }
    final paths = <String, int>{};
    for (final entry in entries) {
      final data = asObject(entry, 'content-index');
      final path = data['path'];
      if (path is! String || paths.containsKey(checkedRelative(path))) {
        throw const FormatException(
          'Neplatný nebo duplicitní soubor v indexu.',
        );
      }
      final bytes = data['bytes'];
      if (bytes is! int || bytes < 0 || bytes > 8 * 1024 * 1024) {
        throw FormatException('$path: neplatná velikost souboru v indexu.');
      }
      paths[path] = bytes;
    }
    // Keep the course and its starters from the same application load. A
    // rebuild/update can replace bundle files while an older lesson is open.
    // Reading starters lazily would then mix that lesson with a newer bundle.
    final contents = <String, List<int>>{};
    for (final entry in paths.entries) {
      final data = await b.load('content/${entry.key}');
      if (data.lengthInBytes != entry.value) {
        throw FormatException(
          '${entry.key}: soubor neodpovídá indexu obsahu. '
          'Znovu spusť aplikaci po dokončení aktualizace.',
        );
      }
      contents[entry.key] = List<int>.unmodifiable(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    }
    return BundleContentSource._(Map.unmodifiable(contents));
  }

  @override
  Future<List<int>> readBytes(String relative) async {
    checkedRelative(relative);
    final data = _contents[relative];
    if (data == null) {
      throw FormatException('Soubor chybí v indexu: $relative');
    }
    return data;
  }

  @override
  Future<List<String>> filesUnder(String relative) async {
    checkedRelative(relative);
    return _contents.keys.where((f) => f.startsWith('$relative/')).toList()
      ..sort();
  }
}
