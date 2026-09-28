import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:aiva/platform/app_paths.dart';

void main() {
  late Directory root;
  late String documents;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('aiva-paths-');
    documents = p.join(root.path, 'Documents');
  });
  tearDown(() async => root.delete(recursive: true));

  Future<void> writeProfile(String path, String contents) async {
    await Directory(path).create(recursive: true);
    await File(p.join(path, 'progress.sqlite')).writeAsString(contents);
  }

  test('new installations use AIVA directories', () async {
    final support = p.join(root.path, 'dev.aiva.desktop');
    final paths = await AppPaths.fromDirectories(
      support: support,
      documents: documents,
    );
    expect(paths.profile, support);
    expect(await Directory(support).exists(), isTrue);
    expect(paths.workspace, p.join(documents, 'AIVA', 'exercises'));
  });

  for (final (current, previous) in [
    ('dev.aiva.desktop', 'dev.javapath.desktop'),
    ('dev.aiva.aiva', 'dev.javapath.javapath'),
    ('dev.aiva.aiva', 'javapath'),
    ('aiva', 'javapath'),
    (p.join('dev.AIVA', 'AIVA'), p.join('dev.JavaPath', 'JavaPath')),
    (p.join('dev.AIVA', 'Aiva'), p.join('dev.JavaPath', 'JavaPath')),
  ]) {
    test('reuses the existing profile for $current / $previous', () async {
      final support = p.join(root.path, current);
      final legacy = p.join(root.path, previous);
      await writeProfile(legacy, 'existing database');
      final wal = File(p.join(legacy, 'progress.sqlite-wal'));
      await wal.writeAsString('pending writes');
      // path_provider may create the new directory before returning it.
      await Directory(support).create(recursive: true);
      final paths = await AppPaths.fromDirectories(
        support: support,
        documents: documents,
      );
      expect(paths.profile, legacy);
      expect(await File(paths.database).readAsString(), 'existing database');
      expect(await wal.readAsString(), 'pending writes');
      expect(await File(p.join(support, 'progress.sqlite')).exists(), isFalse);
    });
  }

  test('prefers an existing AIVA profile over a previous profile', () async {
    final support = p.join(root.path, 'dev.aiva.desktop');
    await writeProfile(support, 'new database');
    await writeProfile(
      p.join(root.path, 'dev.javapath.desktop'),
      'old database',
    );
    final paths = await AppPaths.fromDirectories(
      support: support,
      documents: documents,
    );
    expect(paths.profile, support);
    expect(await File(paths.database).readAsString(), 'new database');
  });

  test('an explicit profile does not select an earlier profile', () async {
    final support = p.join(root.path, 'dev.aiva.desktop');
    await writeProfile(
      p.join(root.path, 'dev.javapath.desktop'),
      'old database',
    );
    final paths = await AppPaths.fromDirectories(
      support: support,
      documents: documents,
      reuseExistingProfile: false,
    );
    expect(paths.profile, support);
    expect(await File(paths.database).exists(), isFalse);
  });

  test('reuses the old workspace until an AIVA workspace exists', () async {
    final support = p.join(root.path, 'dev.aiva.desktop');
    final previous = p.join(documents, 'JavaPath', 'exercises');
    await Directory(previous).create(recursive: true);
    final source = File(p.join(previous, 'Main.java'));
    await source.writeAsString('student work');
    final paths = await AppPaths.fromDirectories(
      support: support,
      documents: documents,
    );
    expect(paths.workspace, previous);
    final current = p.join(documents, 'AIVA', 'exercises');
    await Directory(current).create(recursive: true);
    final updated = await AppPaths.fromDirectories(
      support: support,
      documents: documents,
    );
    expect(updated.workspace, current);
    expect(await source.readAsString(), 'student work');
  });
}
