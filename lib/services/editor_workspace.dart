import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../platform/safe_paths.dart';

/// A buffer belongs to the workspace, so rebuilding the editor keeps its edits.
final class EditorFile {
  EditorFile._(this.relativePath, this._text, this._savedBytes)
    : _savedText = _text;

  final String relativePath;
  String _text;
  String _savedText;
  List<int> _savedBytes;

  String get text => _text;
  String get savedText => _savedText;
  bool get isDirty => _text != _savedText;
  bool get dirty => isDirty;
  String get name => p.posix.basename(relativePath);
}

/// The disk version is preserved, as are the unsaved editor buffers.
final class EditorConflictException implements Exception {
  EditorConflictException(Iterable<String> paths)
    : paths = List.unmodifiable(paths);

  final List<String> paths;

  @override
  String toString() =>
      'Soubor se mezitím změnil mimo editor: ${paths.join(', ')}. '
      'Tvoje rozepsané změny zůstaly v editoru a soubor na disku se nepřepsal.';
}

final class EditorWorkspace extends ChangeNotifier {
  EditorWorkspace._(this.path, List<EditorFile> files)
    : _files = List.of(files),
      _byPath = {for (final file in files) file.relativePath: file};

  static const maxFileBytes = 512 * 1024;
  static const maxTotalBytes = 4 * 1024 * 1024;
  static const maxFiles = 256;
  static const _ignoredDirectories = {
    '.git',
    '.gradle',
    '.idea',
    '.dart_tool',
    '.settings',
    'target',
    'build',
    'out',
    'node_modules',
  };
  static const _extensions = {
    '.java',
    '.xml',
    '.gradle',
    '.kts',
    '.properties',
    '.txt',
    '.md',
    '.json',
    '.yaml',
    '.yml',
    '.csv',
    '.html',
    '.css',
    '.sql',
  };

  final String path;
  final List<EditorFile> _files;
  final Map<String, EditorFile> _byPath;
  Future<void> _tail = Future<void>.value();
  bool _disposed = false;

  List<EditorFile> get files => List.unmodifiable(_files);
  bool get hasUnsavedChanges => files.any((file) => file.isDirty);

  static Future<EditorWorkspace> open(String path) async {
    if (!p.isAbsolute(path)) {
      throw ArgumentError('Editor potřebuje absolutní cestu workspace.');
    }
    await rejectLink(path);
    final canonical = await Directory(path).resolveSymbolicLinks();
    final files = <EditorFile>[];
    var total = 0;
    var entries = 0;
    Future<void> visit(Directory directory) async {
      await for (final entry in directory.list(followLinks: false)) {
        if (++entries > 2000) {
          throw const FormatException(
            'Workspace obsahuje příliš mnoho souborů.',
          );
        }
        if (entry is Link) {
          throw FileSystemException(
            'Editor neotevírá symbolické odkazy.',
            entry.path,
          );
        }
        if (entry is Directory) {
          if (!_ignoredDirectories.contains(p.basename(entry.path))) {
            await visit(entry);
          }
          continue;
        }
        if (entry is! File) {
          throw FileSystemException('Nepovolený typ souboru.', entry.path);
        }
        final name = p.basename(entry.path);
        if (name == '.aiva-workspace.json' ||
            name == '.javapath-workspace.json' ||
            (name != '.gitignore' &&
                !_extensions.contains(p.extension(name).toLowerCase()))) {
          continue;
        }
        final relative = checkedRelative(
          p.relative(entry.path, from: canonical).split(p.separator).join('/'),
        );
        final safePath = await resolveInside(
          canonical,
          relative,
          mustExist: true,
        );
        final bytes = await _readBounded(safePath);
        total += bytes.length;
        if (files.length >= maxFiles || total > maxTotalBytes) {
          throw const FormatException(
            'Editor otevře nejvýše 256 textových souborů / 4 MiB.',
          );
        }
        final text = _decode(bytes, relative);
        files.add(EditorFile._(relative, text, bytes));
      }
    }

    await visit(Directory(canonical));
    files.sort(_compareFiles);
    return EditorWorkspace._(canonical, files);
  }

  static int _compareFiles(EditorFile a, EditorFile b) {
    final aJava = a.relativePath.endsWith('.java');
    final bJava = b.relativePath.endsWith('.java');
    if (aJava != bJava) return aJava ? -1 : 1;
    return a.relativePath.compareTo(b.relativePath);
  }

  EditorFile file(String relativePath) {
    checkedRelative(relativePath);
    final result = _byPath[relativePath];
    if (result == null) throw ArgumentError('Soubor není otevřený v editoru.');
    return result;
  }

  void edit(String relativePath, String text) {
    final target = file(relativePath);
    if (target._text == text) return;
    target._text = text;
    _notify();
  }

  /// Synchronizes external changes without discarding unsaved editor buffers.
  /// Dirty files retain their original disk snapshot, including when deleted,
  /// so saving still detects the conflict. Reads and saves run in one queue.
  Future<void> refresh() => _enqueue(() async {
    await _checkRoot();
    final disk = await EditorWorkspace.open(path);
    try {
      if (disk.path != path) {
        throw FileSystemException('Cesta workspace se změnila.', path);
      }
      final next = <String, EditorFile>{
        for (final file in disk._files) file.relativePath: file,
        // Check dirtiness after reading: typing during refresh must survive.
        for (final file in _files)
          if (file.isDirty) file.relativePath: file,
      };
      final total = next.values.fold<int>(
        0,
        (total, file) => total + file._savedBytes.length,
      );
      if (next.length > maxFiles || total > maxTotalBytes) {
        throw const FormatException(
          'Editor otevře nejvýše 256 textových souborů / 4 MiB.',
        );
      }
      // Apply only after the entire disk snapshot has passed all checks.
      final refreshed = <EditorFile>[];
      for (final entry in next.entries) {
        final current = _byPath[entry.key];
        final replacement = entry.value;
        if (current != null && !current.isDirty) {
          current._text = replacement._text;
          current._savedText = replacement._savedText;
          current._savedBytes = replacement._savedBytes;
          refreshed.add(current);
        } else {
          refreshed.add(replacement);
        }
      }
      refreshed.sort(_compareFiles);
      _files
        ..clear()
        ..addAll(refreshed);
      _byPath
        ..clear()
        ..addEntries(
          refreshed.map((file) => MapEntry(file.relativePath, file)),
        );
      _notify();
    } finally {
      disk.dispose();
    }
  });

  /// Saves snapshots in order; typing during a save stays marked as unsaved.
  /// All conflicts are checked before the first file is changed. Like the
  /// workspace service, this prevents accidental races, not hostile ones.
  Future<void> saveAll() => _enqueue(() async {
    final pending = <EditorFile, String>{
      for (final file in files)
        if (file.isDirty) file: file.text,
    };
    if (pending.isEmpty) return;
    await _checkRoot();
    final encoded = <EditorFile, List<int>>{};
    var total = 0;
    for (final file in files) {
      final text = pending[file];
      final bytes = text == null ? file._savedBytes : _encode(file, text);
      if (bytes.length > maxFileBytes) {
        throw FormatException('Soubor přesahuje 512 KiB: ${file.relativePath}');
      }
      total += bytes.length;
      if (text != null) encoded[file] = bytes;
    }
    if (total > maxTotalBytes) {
      throw const FormatException('Textové soubory přesahují 4 MiB.');
    }
    final conflicts = <String>[];
    for (final file in pending.keys) {
      if (!await _unchanged(file)) conflicts.add(file.relativePath);
    }
    if (conflicts.isNotEmpty) throw EditorConflictException(conflicts);
    for (final entry in pending.entries) {
      final file = entry.key;
      final destination = await resolveInside(
        path,
        file.relativePath,
        mustExist: true,
      );
      final stage = await Directory(
        p.dirname(destination),
      ).createTemp('.aiva-save-');
      try {
        final replacement = await File(
          p.join(stage.path, 'content'),
        ).writeAsBytes(encoded[file]!, flush: true);
        // Recheck after staging so edits in another app are not silently lost.
        if (!await _unchanged(file)) {
          throw EditorConflictException([file.relativePath]);
        }
        await replacement.rename(destination);
        file._savedText = entry.value;
        file._savedBytes = encoded[file]!;
        _notify();
      } finally {
        if (await stage.exists()) await stage.delete(recursive: true);
      }
    }
  });

  /// Explicit conflict resolution. Callers must ask before discarding edits.
  Future<void> reload(String relativePath, {bool discardChanges = false}) =>
      _enqueue(() async {
        final target = file(relativePath);
        if (target.isDirty && !discardChanges) {
          throw StateError('Soubor má neuložené změny.');
        }
        final previous = target.text;
        await _checkRoot();
        final resolved = await resolveInside(
          path,
          relativePath,
          mustExist: true,
        );
        final bytes = await _readBounded(resolved);
        final text = _decode(bytes, relativePath);
        // Never discard keystrokes entered while the asynchronous read ran.
        if (target.text != previous) {
          throw StateError('Soubor se během načítání změnil v editoru.');
        }
        target._text = text;
        target._savedText = text;
        target._savedBytes = bytes;
        _notify();
      });

  Future<void> _checkRoot() async {
    await rejectLink(path);
    if (await Directory(path).resolveSymbolicLinks() != path) {
      throw FileSystemException('Cesta workspace se změnila.', path);
    }
  }

  Future<bool> _unchanged(EditorFile file) async {
    await _checkRoot();
    final resolved = await resolveInside(path, file.relativePath);
    if (await FileSystemEntity.type(resolved, followLinks: false) !=
        FileSystemEntityType.file) {
      return false;
    }
    return listEquals(await _readBounded(resolved), file._savedBytes);
  }

  Future<void> _enqueue(Future<void> Function() action) {
    final task = _tail.then((_) => action());
    _tail = task.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return task;
  }

  static Future<List<int>> _readBounded(String path) async {
    final source = File(path);
    if (await source.length() > maxFileBytes) {
      throw FormatException('Soubor přesahuje 512 KiB: ${p.basename(path)}');
    }
    final bytes = await source
        .openRead(0, maxFileBytes + 1)
        .fold<List<int>>(<int>[], (buffer, chunk) => buffer..addAll(chunk));
    if (bytes.length > maxFileBytes) {
      throw FormatException('Soubor přesahuje 512 KiB: ${p.basename(path)}');
    }
    return bytes;
  }

  static String _decode(List<int> bytes, String relative) {
    if (bytes.contains(0)) {
      throw FormatException('Soubor není text v UTF-8: $relative');
    }
    return utf8.decode(bytes);
  }

  static List<int> _encode(EditorFile file, String text) {
    if (text.contains('\x00')) {
      throw FormatException('Text obsahuje NUL: ${file.relativePath}');
    }
    final previous = file._savedBytes;
    final hasBom =
        previous.length >= 3 &&
        previous[0] == 0xef &&
        previous[1] == 0xbb &&
        previous[2] == 0xbf;
    return [
      if (hasBom) ...[0xef, 0xbb, 0xbf],
      ...utf8.encode(text),
    ];
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
