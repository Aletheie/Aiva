/// Versions 1 and 2 deliberately match the C++ edition, including integer enums.
/// Never change a released migration; add a new entry.
const schemaMigrations = <String>[
  r'''
CREATE TABLE settings(key TEXT PRIMARY KEY NOT NULL, value TEXT NOT NULL);
CREATE TABLE lesson_progress(id TEXT PRIMARY KEY NOT NULL,
  state INTEGER NOT NULL DEFAULT 0 CHECK(state BETWEEN 0 AND 2));
CREATE TABLE exercise_progress(id TEXT PRIMARY KEY NOT NULL,
  state INTEGER NOT NULL CHECK(state BETWEEN 0 AND 2));
PRAGMA user_version=1;
''',
  r'''
ALTER TABLE lesson_progress ADD COLUMN skipped INTEGER NOT NULL DEFAULT 0 CHECK(skipped IN(0,1));
ALTER TABLE lesson_progress ADD COLUMN favorite INTEGER NOT NULL DEFAULT 0 CHECK(favorite IN(0,1));
CREATE TABLE recent_lessons(id TEXT PRIMARY KEY NOT NULL REFERENCES lesson_progress(id), opened_at INTEGER NOT NULL);
PRAGMA user_version=2;
''',
  r'''
CREATE TABLE reader_positions(id TEXT PRIMARY KEY NOT NULL, offset REAL NOT NULL DEFAULT 0 CHECK(offset>=0));
PRAGMA user_version=3;
''',
];
