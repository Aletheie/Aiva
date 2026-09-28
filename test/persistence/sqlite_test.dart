import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:aiva/domain/course.dart';
import 'package:aiva/domain/profile.dart';
import 'package:aiva/persistence/schema.dart';
import 'package:aiva/persistence/sqlite_repository.dart';

void main() {
  late Directory root;
  String path() => p.join(root.path, 'progress.sqlite');
  setUp(() async => root = await Directory.systemTemp.createTemp('aiva db '));
  tearDown(() async => root.delete(recursive: true));
  test(
    'fresh database persists states, preferences, recents and scroll offsets',
    () {
      var db = SqliteRepository(path());
      expect(db.schemaVersion, 3);
      db.apply(const VisitLesson('first-lesson'));
      db.apply(const SetLessonState('first-lesson', LessonState.completed));
      db.apply(
        const SetLessonFlag('first-lesson', skipped: true, favorite: true),
      );
      db.apply(const SetExerciseState('ex-first', ExerciseState.completed));
      db.apply(const SetPreference('workspace', 'C:\\Moje "složka"'));
      db.apply(const SetReaderOffset('first-lesson', 330.5));
      db.close();
      db = SqliteRepository(path());
      final profile = db.snapshot();
      expect(profile.lesson('first-lesson').state, LessonState.completed);
      expect(profile.lesson('first-lesson').favorite, isTrue);
      expect(profile.lesson('first-lesson').skipped, isTrue);
      expect(profile.exercise('ex-first'), ExerciseState.completed);
      expect(profile.setting('workspace'), 'C:\\Moje "složka"');
      expect(profile.recent, ['first-lesson']);
      expect(profile.readerOffsets['first-lesson'], 330.5);
      db.close();
    },
  );
  for (final version in [1, 2]) {
    test('migrates original v$version without losing progress', () {
      final legacy = sqlite3.open(path());
      for (var i = 0; i < version; i++) {
        legacy.execute(schemaMigrations[i]);
      }
      legacy.execute('INSERT INTO lesson_progress(id,state) VALUES(?,?)', [
        'first-lesson',
        2,
      ]);
      legacy.execute('INSERT INTO settings(key,value) VALUES(?,?)', [
        'theme',
        'dark',
      ]);
      legacy.close();
      final db = SqliteRepository(path());
      expect(db.schemaVersion, 3);
      expect(db.snapshot().lesson('first-lesson').state, LessonState.completed);
      expect(db.snapshot().setting('theme'), 'dark');
      db.close();
    });
  }
  test('future schema is rejected', () {
    final future = sqlite3.open(path());
    future.execute('PRAGMA user_version=99');
    future.close();
    expect(() => SqliteRepository(path()), throwsStateError);
    final check = sqlite3.open(path());
    expect(check.select('PRAGMA user_version').first.values.first, 99);
    check.close();
  });
  test('reopening a completed lesson does not downgrade its state', () {
    final db = SqliteRepository(path());
    db.apply(const SetLessonState('done', LessonState.completed));
    db.apply(const VisitLesson('done'));
    db.apply(const VisitLesson('second'));
    db.apply(const VisitLesson('done'));
    expect(db.snapshot().lesson('done').state, LessonState.completed);
    expect(db.snapshot().recent, ['done', 'second']);
    db.close();
  });
  test('invalid mutation rolls back, preserving profile', () {
    final db = SqliteRepository(path());
    db.apply(const SetPreference('theme', 'dark'));
    expect(
      () => db.apply(const SetLessonFlag('../bad', favorite: true)),
      throwsArgumentError,
    );
    expect(
      () => db.apply(const SetReaderOffset('good', -1)),
      throwsArgumentError,
    );
    expect(db.snapshot().setting('theme'), 'dark');
    expect(db.snapshot().lessons, isEmpty);
    db.close();
  });
  test(
    'consistent backup includes WAL and refuses an existing destination',
    () {
      final db = SqliteRepository(path());
      db.apply(const SetLessonState('first', LessonState.completed));
      final target = p.join(root.path, "záloha ' jedna.sqlite");
      db.backup(target);
      expect(() => db.backup(target), throwsA(isA<FileSystemException>()));
      final restored = SqliteRepository(target);
      expect(restored.snapshot().lesson('first').state, LessonState.completed);
      restored.close();
      db.close();
    },
  );
  test(
    'import merges states, preserves settings and does not import execution consent',
    () {
      final incoming = SqliteRepository(p.join(root.path, 'old.sqlite'));
      incoming.apply(const SetLessonState('lesson', LessonState.completed));
      incoming.apply(const SetLessonFlag('lesson', favorite: true));
      incoming.apply(const SetPreference('theme', 'dark'));
      incoming.apply(const SetPreference('executionConsent', 'yes'));
      incoming.apply(const SetExerciseState('ex-one', ExerciseState.completed));
      incoming.close();
      final db = SqliteRepository(path());
      db.apply(const SetPreference('theme', 'light'));
      db.apply(const SetLessonState('lesson', LessonState.inProgress));
      db.importFrom(p.join(root.path, 'old.sqlite'));
      expect(db.snapshot().lesson('lesson').state, LessonState.completed);
      expect(db.snapshot().lesson('lesson').favorite, isTrue);
      expect(db.snapshot().setting('theme'), 'light');
      expect(db.snapshot().setting('executionConsent'), isEmpty);
      expect(db.snapshot().exercise('ex-one'), ExerciseState.completed);
      db.close();
    },
  );
  test(
    'isolated store serializes overlapping writes without sending handles',
    () async {
      final store = SqliteProfileStore(path());
      await Future.wait([
        for (var i = 0; i < 12; i++) store.edit(SetPreference('key-$i', '$i')),
      ]);
      final profile = await store.load();
      expect(profile.settings.length, 12);
      await store.edit(const VisitLesson('first'));
      expect((await store.load()).recent.first, 'first');
    },
  );
}
