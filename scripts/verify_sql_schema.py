#!/usr/bin/env python3
"""Execute SQL from the Dart sources with Python's SQLite, NOT the Dart adapter.

These checks supplement, and cannot replace, flutter test test/persistence.
No third-party Python packages are needed.
"""
from __future__ import annotations
import json
import re
import sqlite3
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MIGRATIONS = re.findall(r"r'''(.*?)'''", (ROOT / 'lib/persistence/schema.dart').read_text(), re.S)
QUERIES = re.findall(r"'''(.*?)'''", (ROOT / 'lib/persistence/sqlite_repository.dart').read_text(), re.S)


def query(prefix: str, contains: str = '') -> str:
    matches = [q for q in QUERIES if q.strip().startswith(prefix) and contains in q]
    if len(matches) != 1:
        raise AssertionError(f'Expected one source query: {prefix!r}, {contains!r}: {len(matches)}')
    return matches[0]


def migrate(db: sqlite3.Connection, target: int = 3) -> None:
    version = db.execute('PRAGMA user_version').fetchone()[0]
    for sql in MIGRATIONS[version:target]:
        db.executescript(sql)


class SourceSqlTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory(prefix='aiva-sql-')
        self.path = Path(self.temp.name) / 'profile.sqlite'
        self.db = sqlite3.connect(self.path, isolation_level=None)
        self.db.execute('PRAGMA foreign_keys=ON')
        self.db.execute('PRAGMA journal_mode=WAL')

    def tearDown(self) -> None:
        self.db.close()
        self.temp.cleanup()

    def test_fresh_schema(self) -> None:
        migrate(self.db)
        self.assertEqual(self.db.execute('PRAGMA user_version').fetchone()[0], 3)
        self.assertEqual(len(self.db.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()), 5)

    def test_migrate_version_one_preserves_progress(self) -> None:
        migrate(self.db, 1)
        self.db.execute("INSERT INTO lesson_progress VALUES('lesson-one',2)")
        self.db.execute("INSERT INTO exercise_progress VALUES('exercise-one',1)")
        self.db.execute("INSERT INTO settings VALUES('theme','dark')")
        migrate(self.db)
        self.assertEqual(self.db.execute('SELECT state,skipped,favorite FROM lesson_progress').fetchone(), (2, 0, 0))
        self.assertEqual(self.db.execute('SELECT value FROM settings').fetchone()[0], 'dark')

    def test_migrate_version_two_preserves_flags_and_recents(self) -> None:
        migrate(self.db, 2)
        self.db.execute("INSERT INTO lesson_progress VALUES('lesson-one',2,1,1)")
        self.db.execute("INSERT INTO recent_lessons VALUES('lesson-one',123)")
        migrate(self.db)
        self.assertEqual(self.db.execute('SELECT state,skipped,favorite FROM lesson_progress').fetchone(), (2, 1, 1))
        self.assertEqual(self.db.execute('SELECT opened_at FROM recent_lessons').fetchone()[0], 123)

    def test_invalid_state_and_flags_rejected(self) -> None:
        migrate(self.db)
        for sql in ["INSERT INTO lesson_progress(id,state) VALUES('a',3)",
                    "INSERT INTO lesson_progress(id,favorite) VALUES('b',2)",
                    "INSERT INTO exercise_progress VALUES('c',-1)"]:
            with self.assertRaises(sqlite3.IntegrityError):
                self.db.execute(sql)

    def test_foreign_keys_reject_unknown_recent(self) -> None:
        migrate(self.db)
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute("INSERT INTO recent_lessons VALUES('absent',1)")

    def test_visit_keeps_completed_state(self) -> None:
        migrate(self.db)
        q = query('INSERT INTO lesson_progress(id,state) VALUES(?,1)')
        self.db.execute(q, ['lesson-one'])
        self.assertEqual(self.db.execute('SELECT state FROM lesson_progress').fetchone()[0], 1)
        self.db.execute("UPDATE lesson_progress SET state=2,favorite=1")
        self.db.execute(q, ['lesson-one'])
        self.assertEqual(self.db.execute('SELECT state,favorite FROM lesson_progress').fetchone(), (2, 1))

    def test_recent_order_is_monotonic(self) -> None:
        migrate(self.db)
        q = query('INSERT INTO recent_lessons(id,opened_at)')
        for id in ['first', 'second', 'third']:
            self.db.execute('INSERT INTO lesson_progress(id) VALUES(?)', [id])
            self.db.execute(q, [id, 100])
        self.assertEqual(self.db.execute('SELECT id,opened_at FROM recent_lessons ORDER BY opened_at DESC').fetchall(),
                         [('third', 102), ('second', 101), ('first', 100)])
        self.db.execute(q, ['first', 90])
        self.assertEqual(self.db.execute("SELECT opened_at FROM recent_lessons WHERE id='first'").fetchone()[0], 103)

    def test_lesson_state_update_preserves_flags(self) -> None:
        migrate(self.db)
        self.db.execute("INSERT INTO lesson_progress VALUES('lesson-one',0,1,1)")
        self.db.execute(query('INSERT INTO lesson_progress(id,state) VALUES(?,?)'), ['lesson-one', 2])
        self.assertEqual(self.db.execute('SELECT state,skipped,favorite FROM lesson_progress').fetchone(), (2, 1, 1))

    def test_exercise_update(self) -> None:
        migrate(self.db)
        q = query('INSERT INTO exercise_progress(id,state) VALUES(?,?)', 'state=excluded.state')
        self.db.execute(q, ['exercise-one', 1])
        self.db.execute(q, ['exercise-one', 2])
        self.assertEqual(self.db.execute('SELECT state FROM exercise_progress').fetchall(), [(2,)])

    def test_import_union_keeps_higher_progress(self) -> None:
        migrate(self.db)
        self.db.execute("INSERT INTO lesson_progress VALUES('lesson-one',2,0,1)")
        self.db.execute(query('INSERT INTO lesson_progress(id,state,skipped,favorite)'), ['lesson-one', 1, 1, 0])
        self.assertEqual(self.db.execute('SELECT state,skipped,favorite FROM lesson_progress').fetchone(), (2, 1, 1))
        self.db.execute("INSERT INTO exercise_progress VALUES('exercise-one',2)")
        self.db.execute(query('INSERT INTO exercise_progress(id,state) VALUES(?,?)', 'state=MAX'), ['exercise-one', 1])
        self.assertEqual(self.db.execute('SELECT state FROM exercise_progress').fetchone()[0], 2)

    def test_preference_upsert(self) -> None:
        migrate(self.db)
        q = query('INSERT INTO settings(key,value) VALUES(?,?)')
        self.db.execute(q, ['theme', 'light'])
        self.db.execute(q, ['theme', 'dark'])
        self.assertEqual(self.db.execute('SELECT * FROM settings').fetchall(), [('theme', 'dark')])

    def test_reader_offset(self) -> None:
        migrate(self.db)
        q = query('INSERT INTO reader_positions(id,offset) VALUES(?,?)')
        self.db.execute(q, ['lesson-one', 12.5])
        self.db.execute(q, ['lesson-one', 24.75])
        self.assertEqual(self.db.execute('SELECT offset FROM reader_positions').fetchone()[0], 24.75)
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute(q, ['lesson-two', -1.0])

    def test_transaction_rolls_back(self) -> None:
        migrate(self.db)
        self.db.execute('BEGIN IMMEDIATE')
        self.db.execute("INSERT INTO settings VALUES('theme','dark')")
        self.db.execute('ROLLBACK')
        self.assertEqual(self.db.execute('SELECT COUNT(*) FROM settings').fetchone()[0], 0)

    def test_vacuum_backup_includes_wal_and_refuses_nonempty_target(self) -> None:
        migrate(self.db)
        self.db.execute("INSERT INTO settings VALUES('theme','dark')")
        target = str(Path(self.temp.name) / 'backup.sqlite')
        self.db.execute('VACUUM main INTO ?', [target])
        with sqlite3.connect(target) as backup:
            self.assertEqual(backup.execute('PRAGMA user_version').fetchone()[0], 3)
            self.assertEqual(backup.execute('SELECT value FROM settings').fetchone()[0], 'dark')
        with self.assertRaises(sqlite3.OperationalError):
            self.db.execute('VACUUM main INTO ?', [target])


if __name__ == '__main__':
    suite = unittest.defaultTestLoader.loadTestsFromTestCase(SourceSqlTests)
    result = unittest.TextTestRunner(verbosity=2).run(suite)
    report = {'scope': 'SQL extracted from Dart sources; Python SQLite engine, not Dart adapter',
              'sqlite_version': sqlite3.sqlite_version, 'tests': result.testsRun,
              'failures': len(result.failures), 'errors': len(result.errors),
              'flutter_tests_executed': False}
    report_path = ROOT / 'docs/sql-source-report.json'
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, indent=2) + '\n')
    raise SystemExit(0 if result.wasSuccessful() else 1)
