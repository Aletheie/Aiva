import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import '../content/content_source.dart';
import '../content/strict_json.dart';
import '../domain/course.dart';
import '../platform/safe_paths.dart';

final class WorkspaceResult {
  const WorkspaceResult(this.path, {required this.created});
  final String path;
  final bool created;
}

final class WorkspaceService {
  WorkspaceService(this.content);
  final ContentSource content;
  Future<void> _tail = Future<void>.value();

  Future<WorkspaceResult> prepare(String root, Exercise exercise) {
    final task = _tail.then((_) => _prepare(root, exercise));
    _tail = task.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return task;
  }

  Future<WorkspaceResult> _prepare(String root, Exercise exercise) async {
    if (!validId(exercise.id) || exercise.starter == null) {
      throw ArgumentError('Cvičení nemá platný starter.');
    }
    if (!p.isAbsolute(root)) {
      throw ArgumentError('Workspace potřebuje absolutní cestu.');
    }
    await Directory(root).create(recursive: true);
    final canonical = await Directory(root).resolveSymbolicLinks();
    final destination = await resolveInside(canonical, exercise.id);
    // Share the existing lock with installations from before the rename.
    final previousLock = p.join(canonical, '.javapath.lock');
    final lockPath = await resolveInside(
      canonical,
      await File(previousLock).exists() ? '.javapath.lock' : '.aiva.lock',
    );
    final lock = await File(lockPath).open(mode: FileMode.append);
    Directory? staging;
    try {
      await lock.lock(FileLock.blockingExclusive);
      if (await _existing(destination, exercise.id)) {
        return WorkspaceResult(destination, created: false);
      }
      final files = await content.filesUnder(exercise.starter!);
      if (files.isEmpty || files.length > 500) {
        throw const FormatException('Starter musí obsahovat 1 až 500 souborů.');
      }
      staging = await Directory(
        canonical,
      ).createTemp('.aiva-stage-${exercise.id}-');
      var bytes = 0;
      for (final path in files) {
        if (!path.startsWith('${exercise.starter}/')) {
          throw FormatException('Soubor opouští starter: $path');
        }
        final relative = checkedRelative(
          path.substring(exercise.starter!.length + 1),
        );
        final data = await content.readBytes(path);
        bytes += data.length;
        if (bytes > 20 * 1024 * 1024) {
          throw const FormatException('Starter přesahuje 20 MiB.');
        }
        final target = await resolveInside(staging.path, relative);
        await Directory(p.dirname(target)).create(recursive: true);
        await File(target).writeAsBytes(data, flush: true);
      }
      await File(p.join(staging.path, '.aiva-workspace.json')).writeAsString(
        jsonEncode({'schemaVersion': 1, 'exercise': exercise.id}),
        flush: true,
      );
      // The lock coordinates Aiva instances; other programs can still create the directory.
      if (await _existing(destination, exercise.id)) {
        return WorkspaceResult(destination, created: false);
      }
      await staging.rename(destination);
      staging = null;
      return WorkspaceResult(destination, created: true);
    } finally {
      try {
        if (staging != null && await staging.exists()) {
          await staging.delete(recursive: true);
        }
      } finally {
        await lock.close();
      }
    }
  }

  Future<bool> _existing(String destination, String id) async {
    final type = await FileSystemEntity.type(destination, followLinks: false);
    if (type == FileSystemEntityType.notFound) return false;
    if (type != FileSystemEntityType.directory) {
      throw FileSystemException(
        'Cíl workspace není běžná složka.',
        destination,
      );
    }
    var marker = await resolveInside(destination, '.aiva-workspace.json');
    if (!await File(marker).exists()) {
      // Read old markers without changing a student's working files.
      marker = await resolveInside(destination, '.javapath-workspace.json');
    }
    if (!await File(marker).exists()) {
      throw FileSystemException(
        'Složka už existuje bez značky Aiva. Nic se nepřepsalo. '
        'Zvol jiný kořen workspace nebo tuto složku nejprve ručně zazálohuj.',
        destination,
      );
    }
    if (await File(marker).length() > 4096) {
      throw const FormatException('Neplatná značka workspace.');
    }
    final metadata = decodeObject(await File(marker).readAsString(), marker);
    if (metadata['exercise'] != id || metadata['schemaVersion'] != 1) {
      throw FileSystemException(
        'Workspace patří jiné úloze nebo neznámé verzi.',
        destination,
      );
    }
    return true;
  }

  static Future<List<String>> javaSources(String workspace) async {
    final source = await resolveInside(
      workspace,
      'src/main/java',
      mustExist: true,
    );
    final result = <String>[];
    var total = 0;
    var entries = 0;
    await for (final entry in Directory(
      source,
    ).list(recursive: true, followLinks: false)) {
      if (++entries > 1000) {
        throw const FormatException('Příliš mnoho souborů v src/main/java.');
      }
      if (entry is Link) {
        throw const FormatException('Kontrola nesleduje symbolické odkazy.');
      }
      if (entry is File && entry.path.endsWith('.java')) {
        total += await entry.length();
        result.add(p.absolute(entry.path));
        if (result.length > 64 || total > 2 * 1024 * 1024) {
          throw const FormatException(
            'Kontrola přijímá nejvýše 64 Java souborů / 2 MiB.',
          );
        }
      } else if (entry is! File && entry is! Directory) {
        throw const FormatException('Nepovolený typ souboru v Java zdrojích.');
      }
    }
    if (result.isEmpty) {
      throw const FormatException(
        'V src/main/java nejsou žádné .java soubory.',
      );
    }
    return result..sort();
  }
}
