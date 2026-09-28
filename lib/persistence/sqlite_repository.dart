import 'dart:io';
import 'dart:isolate';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import '../domain/course.dart';
import '../domain/profile.dart';
import 'schema.dart';

final class SqliteRepository {
  SqliteRepository(String path) : database = sqlite3.open(path) {
    try {
      database.execute('PRAGMA busy_timeout=3000');
      database.execute('PRAGMA foreign_keys=ON');
      if (schemaVersion > schemaMigrations.length) {
        throw StateError('Profil pochází z novější verze Aiva.');
      }
      database.execute('PRAGMA journal_mode=WAL');
      database.execute('PRAGMA synchronous=NORMAL');
      transaction(() {
        final version = schemaVersion;
        if (version > schemaMigrations.length) {
          throw StateError(
            'Databáze pochází z novější verze Aiva. Profil nebyl změněn.',
          );
        }
        for (var index = version; index < schemaMigrations.length; index++) {
          database.execute(schemaMigrations[index]);
        }
      });
    } catch (_) {
      database.close();
      rethrow;
    }
  }
  final Database database;
  int get schemaVersion =>
      database.select('PRAGMA user_version').first.values.first as int;
  void close() => database.close();
  T transaction<T>(T Function() operation) {
    database.execute('BEGIN IMMEDIATE');
    try {
      final value = operation();
      database.execute('COMMIT');
      return value;
    } catch (_) {
      database.execute('ROLLBACK');
      rethrow;
    }
  }

  ProfileSnapshot snapshot() => _readSnapshot(database, schemaVersion);

  static ProfileSnapshot _readSnapshot(Database db, int version) {
    if (version < 1 || version > schemaMigrations.length) {
      throw StateError('Neznámá verze profilu: $version.');
    }
    final lessons = <String, LessonProgress>{};
    final rows = db.select(
      version >= 2
          ? 'SELECT id,state,skipped,favorite FROM lesson_progress'
          : 'SELECT id,state,0 AS skipped,0 AS favorite FROM lesson_progress',
    );
    for (final row in rows) {
      final id = row['id'] as String;
      final state = row['state'] as int;
      if (!validId(id) || state < 0 || state > 2) {
        throw StateError('Profil obsahuje neplatný stav lekce.');
      }
      lessons[id] = LessonProgress(
        state: LessonState.values[state],
        skipped: row['skipped'] == 1,
        favorite: row['favorite'] == 1,
      );
    }
    final exercises = <String, ExerciseState>{};
    for (final row in db.select('SELECT id,state FROM exercise_progress')) {
      final id = row['id'] as String;
      final state = row['state'] as int;
      if (!validId(id) || state < 0 || state > 2) {
        throw StateError('Neplatný stav cvičení.');
      }
      exercises[id] = ExerciseState.values[state];
    }
    return ProfileSnapshot(
      lessons: Map.unmodifiable(lessons),
      exercises: Map.unmodifiable(exercises),
      settings: Map.unmodifiable({
        for (final row in db.select('SELECT key,value FROM settings'))
          row['key'] as String: row['value'] as String,
      }),
      recent: version < 2
          ? const []
          : List.unmodifiable(
              db
                  .select(
                    'SELECT id FROM recent_lessons ORDER BY opened_at DESC LIMIT 100',
                  )
                  .map((row) => row['id'] as String),
            ),
      readerOffsets: version < 3
          ? const {}
          : Map.unmodifiable({
              for (final row in db.select(
                'SELECT id,offset FROM reader_positions',
              ))
                row['id'] as String: (row['offset'] as num).toDouble(),
            }),
    );
  }

  void apply(ProfileEdit edit) => transaction(() {
    switch (edit) {
      case VisitLesson(:final id):
        _id(id);
        database.execute(
          '''INSERT INTO lesson_progress(id,state) VALUES(?,1)
          ON CONFLICT(id) DO UPDATE SET state=CASE WHEN state=0 THEN 1 ELSE state END''',
          [id],
        );
        database.execute(
          '''INSERT INTO recent_lessons(id,opened_at)
          VALUES(?,MAX(?,COALESCE((SELECT MAX(opened_at)+1 FROM recent_lessons),0)))
          ON CONFLICT(id) DO UPDATE SET opened_at=excluded.opened_at''',
          [id, DateTime.now().millisecondsSinceEpoch],
        );
        _preference('lastLesson', id);
      case SetLessonState(:final id, :final state):
        _id(id);
        database.execute(
          '''INSERT INTO lesson_progress(id,state) VALUES(?,?)
          ON CONFLICT(id) DO UPDATE SET state=excluded.state''',
          [id, state.index],
        );
      case SetLessonFlag(:final id, :final skipped, :final favorite):
        _id(id);
        database.execute(
          'INSERT OR IGNORE INTO lesson_progress(id) VALUES(?)',
          [id],
        );
        if (skipped != null) {
          database.execute('UPDATE lesson_progress SET skipped=? WHERE id=?', [
            skipped ? 1 : 0,
            id,
          ]);
        }
        if (favorite != null) {
          database.execute('UPDATE lesson_progress SET favorite=? WHERE id=?', [
            favorite ? 1 : 0,
            id,
          ]);
        }
      case SetExerciseState(:final id, :final state):
        _id(id);
        database.execute(
          '''INSERT INTO exercise_progress(id,state) VALUES(?,?)
          ON CONFLICT(id) DO UPDATE SET state=excluded.state''',
          [id, state.index],
        );
      case SetPreference(:final key, :final value):
        _preference(key, value);
      case SetReaderOffset(:final id, :final offset):
        _id(id);
        if (!offset.isFinite || offset < 0) {
          throw ArgumentError('Neplatná pozice čtečky.');
        }
        database.execute(
          '''INSERT INTO reader_positions(id,offset) VALUES(?,?)
          ON CONFLICT(id) DO UPDATE SET offset=excluded.offset''',
          [id, offset],
        );
    }
  });

  void _preference(String key, String value) {
    if (key.length > 128 || value.length > 8192) {
      throw ArgumentError('Preference je příliš dlouhá.');
    }
    database.execute(
      '''INSERT INTO settings(key,value) VALUES(?,?)
      ON CONFLICT(key) DO UPDATE SET value=excluded.value''',
      [key, value],
    );
  }

  static void _id(String id) {
    if (!validId(id)) throw ArgumentError('Neplatné ID: $id');
  }

  void backup(String destination) {
    if (!p.isAbsolute(destination)) {
      throw ArgumentError('Záloha potřebuje absolutní cestu.');
    }
    if (FileSystemEntity.typeSync(destination, followLinks: false) !=
        FileSystemEntityType.notFound) {
      throw FileSystemException(
        'Záloha nikdy nepřepisuje existující soubor.',
        destination,
      );
    }
    // VACUUM INTO includes changes from the WAL in the backup.
    database.execute('VACUUM main INTO ?', [destination]);
  }

  void importFrom(String source) {
    final incoming = sqlite3.open(source, mode: OpenMode.readOnly);
    late final ProfileSnapshot snapshot;
    try {
      incoming.execute('BEGIN');
      final version =
          incoming.select('PRAGMA user_version').first.values.first as int;
      snapshot = _readSnapshot(incoming, version);
      incoming.execute('COMMIT');
    } finally {
      incoming.close();
    }
    transaction(() {
      for (final e in snapshot.lessons.entries) {
        database.execute(
          '''INSERT INTO lesson_progress(id,state,skipped,favorite) VALUES(?,?,?,?)
          ON CONFLICT(id) DO UPDATE SET state=MAX(state,excluded.state),
          skipped=MAX(skipped,excluded.skipped), favorite=MAX(favorite,excluded.favorite)''',
          [
            e.key,
            e.value.state.index,
            e.value.skipped ? 1 : 0,
            e.value.favorite ? 1 : 0,
          ],
        );
      }
      for (final e in snapshot.exercises.entries) {
        database.execute(
          '''INSERT INTO exercise_progress(id,state) VALUES(?,?)
          ON CONFLICT(id) DO UPDATE SET state=MAX(state,excluded.state)''',
          [e.key, e.value.index],
        );
      }
      // Keep existing local preferences. Never import consent to execute code.
      for (final e in snapshot.settings.entries) {
        if (e.key == 'executionConsent' || e.key == 'windowGeometry') continue;
        database.execute(
          'INSERT OR IGNORE INTO settings(key,value) VALUES(?,?)',
          [e.key, e.value],
        );
      }
      var stamp =
          DateTime.now().millisecondsSinceEpoch - snapshot.recent.length;
      for (final id in snapshot.recent.reversed) {
        if (snapshot.lessons.containsKey(id)) {
          database.execute(
            'INSERT OR IGNORE INTO recent_lessons(id,opened_at) VALUES(?,?)',
            [id, stamp++],
          );
        }
      }
      for (final e in snapshot.readerOffsets.entries) {
        if (e.value.isFinite && e.value >= 0) {
          database.execute(
            'INSERT OR IGNORE INTO reader_positions(id,offset) VALUES(?,?)',
            [e.key, e.value],
          );
        }
      }
    });
  }
}

/// Serializes database operations and runs them in a worker isolate.
final class SqliteProfileStore implements ProfileStore {
  SqliteProfileStore(this.path);
  final String path;
  Future<void> _tail = Future<void>.value();
  Future<T> _queued<T>(Future<T> Function() action) {
    final task = _tail.then((_) => action());
    _tail = task.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return task;
  }

  @override
  Future<ProfileSnapshot> load() => _queued(() => _databaseTask(path));
  @override
  Future<ProfileSnapshot> edit(ProfileEdit edit) =>
      _queued(() => _databaseTask(path, edit: edit));
  @override
  Future<void> backup(String destination) => _queued(() async {
    await _databaseTask(path, backup: destination);
  });
  @override
  Future<ProfileSnapshot> importFrom(String source) =>
      _queued(() => _databaseTask(path, incoming: source));
}

// The isolate closure captures only values, never the store or its Future queue.
Future<ProfileSnapshot> _databaseTask(
  String file, {
  ProfileEdit? edit,
  String? backup,
  String? incoming,
}) => Isolate.run(() {
  Directory(p.dirname(file)).createSync(recursive: true);
  final repository = SqliteRepository(file);
  try {
    if (edit != null) repository.apply(edit);
    if (backup != null) repository.backup(backup);
    if (incoming != null) repository.importFrom(incoming);
    return repository.snapshot();
  } finally {
    repository.close();
  }
});
