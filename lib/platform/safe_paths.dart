import 'dart:io';
import 'package:path/path.dart' as p;

/// Content paths use POSIX separators on all platforms; reject Windows syntax too.
String checkedRelative(String value) {
  if (value.isEmpty ||
      value.length > 1024 ||
      value.startsWith('/') ||
      value.contains('\\') ||
      value.contains(':') ||
      RegExp(r'[\x00-\x1f]').hasMatch(value)) {
    throw FormatException('Neplatná relativní cesta: $value');
  }
  for (final component in value.split('/')) {
    if (component.isEmpty ||
        component == '.' ||
        component == '..' ||
        component.endsWith('.') ||
        component.endsWith(' ') ||
        RegExp(r'[<>"|?*]').hasMatch(component) ||
        RegExp(
          r'^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(?:\.|$)',
          caseSensitive: false,
        ).hasMatch(component)) {
      throw FormatException('Nepřenositelná komponenta cesty: $value');
    }
  }
  return value;
}

/// The selected root can be a symlink (e.g. macOS /var); descendants cannot.
/// This prevents accidental link traversal, not hostile concurrent filesystem races.
Future<String> resolveInside(
  String root,
  String relative, {
  bool mustExist = false,
}) async {
  checkedRelative(relative);
  final canonicalRoot = await Directory(root).resolveSymbolicLinks();
  var current = canonicalRoot;
  for (final segment in relative.split('/')) {
    current = p.join(current, segment);
    final type = await FileSystemEntity.type(current, followLinks: false);
    if (type == FileSystemEntityType.link) {
      throw FileSystemException(
        'Symbolické odkazy uvnitř pracovního stromu nejsou povolené.',
        current,
      );
    }
    if (type != FileSystemEntityType.notFound &&
        type != FileSystemEntityType.directory &&
        type != FileSystemEntityType.file) {
      throw FileSystemException('Speciální soubory nejsou povolené.', current);
    }
  }
  if (!p.isWithin(canonicalRoot, current)) {
    throw FileSystemException('Cesta opouští kořenový adresář.', current);
  }
  if (mustExist &&
      await FileSystemEntity.type(current, followLinks: false) ==
          FileSystemEntityType.notFound) {
    throw FileSystemException('Soubor neexistuje.', current);
  }
  return current;
}

Future<void> rejectLink(String path) async {
  if (await FileSystemEntity.type(path, followLinks: false) ==
      FileSystemEntityType.link) {
    throw FileSystemException('Symbolický odkaz není povolený.', path);
  }
}
