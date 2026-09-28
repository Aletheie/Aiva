import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:aiva/domain/course.dart';
import 'package:aiva/services/workspace_service.dart';
import '../support/fixtures.dart';

void main() {
  late Directory root;
  late MemoryContent source;
  const exercise = Exercise(
    id: 'ex-one',
    title: 'Test',
    kind: 'write',
    difficulty: Difficulty.easy,
    prompt: 'Test',
    hints: [],
    solution: 'done',
    starter: 'starters/ex-one',
    validation: ManualValidation(['test']),
  );
  setUp(() async {
    root = await Directory.systemTemp.createTemp('AIVA žluťoučký ');
    source = MemoryContent({
      'starters/ex-one/src/main/java/Main.java': 'class Main {}',
      'starters/ex-one/.gitignore': 'target/\n',
      'starters/ex-one/README.md': 'Read me',
    });
  });
  tearDown(() async => root.delete(recursive: true));
  test('creates full starter with marker and unicode/space paths', () async {
    final result = await WorkspaceService(source).prepare(root.path, exercise);
    expect(result.created, isTrue);
    expect(
      await File(p.join(result.path, '.gitignore')).readAsString(),
      'target/\n',
    );
    expect(
      jsonDecode(
        await File(p.join(result.path, '.aiva-workspace.json')).readAsString(),
      ),
      {'schemaVersion': 1, 'exercise': 'ex-one'},
    );
    expect(await WorkspaceService.javaSources(result.path), hasLength(1));
  });
  test(
    'never changes modified files or restores deliberately deleted files',
    () async {
      final service = WorkspaceService(source);
      final first = await service.prepare(root.path, exercise);
      final code = File(p.join(first.path, 'src/main/java/Main.java'));
      await code.writeAsString('MY OWN PROGRAM');
      await File(p.join(first.path, 'README.md')).delete();
      source.files['starters/ex-one/new.txt'] = 'new starter version';
      final second = await service.prepare(root.path, exercise);
      expect(second.created, isFalse);
      expect(await code.readAsString(), 'MY OWN PROGRAM');
      expect(await File(p.join(first.path, 'README.md')).exists(), isFalse);
      expect(await File(p.join(first.path, 'new.txt')).exists(), isFalse);
    },
  );
  test('refuses an unrelated existing directory without a marker', () async {
    await Directory(p.join(root.path, exercise.id)).create();
    await expectLater(
      WorkspaceService(source).prepare(root.path, exercise),
      throwsA(isA<FileSystemException>()),
    );
    expect(
      await Directory(p.join(root.path, exercise.id)).list().isEmpty,
      isTrue,
    );
  });
  test(
    'reuses previous workspace markers and locks without changing files',
    () async {
      final service = WorkspaceService(source);
      final first = await service.prepare(root.path, exercise);
      final oldMarker = p.join(first.path, '.javapath-workspace.json');
      await File(p.join(first.path, '.aiva-workspace.json')).rename(oldMarker);
      await File(
        p.join(root.path, '.aiva.lock'),
      ).rename(p.join(root.path, '.javapath.lock'));
      final code = File(p.join(first.path, 'src/main/java/Main.java'));
      await code.writeAsString('MY OWN PROGRAM');
      await File(p.join(first.path, 'README.md')).delete();
      final result = await service.prepare(root.path, exercise);
      expect(result.created, isFalse);
      expect(result.path, first.path);
      expect(await code.readAsString(), 'MY OWN PROGRAM');
      expect(await File(p.join(first.path, 'README.md')).exists(), isFalse);
      expect(await File(oldMarker).exists(), isTrue);
      expect(
        await File(p.join(first.path, '.aiva-workspace.json')).exists(),
        isFalse,
      );
      expect(await File(p.join(root.path, '.aiva.lock')).exists(), isFalse);
    },
  );
  test('validates previous workspace markers before reusing them', () async {
    final target = await Directory(p.join(root.path, exercise.id)).create();
    await File(
      p.join(target.path, '.javapath-workspace.json'),
    ).writeAsString('{"schemaVersion":1,"exercise":"other"}');
    await expectLater(
      WorkspaceService(source).prepare(root.path, exercise),
      throwsA(isA<FileSystemException>()),
    );
  });
  test('rejects a marker for another exercise', () async {
    final target = await Directory(p.join(root.path, exercise.id)).create();
    await File(
      p.join(target.path, '.aiva-workspace.json'),
    ).writeAsString('{"schemaVersion":1,"exercise":"other"}');
    await expectLater(
      WorkspaceService(source).prepare(root.path, exercise),
      throwsA(isA<FileSystemException>()),
    );
  });
  test('serializes simultaneous preparation of the same exercise', () async {
    final service = WorkspaceService(source);
    final results = await Future.wait([
      service.prepare(root.path, exercise),
      service.prepare(root.path, exercise),
    ]);
    expect(results.where((r) => r.created), hasLength(1));
  });
  test(
    'rejects traversal in a starter before writing outside staging',
    () async {
      source.files['starters/ex-one/../escape.txt'] = 'bad';
      await expectLater(
        WorkspaceService(source).prepare(root.path, exercise),
        throwsFormatException,
      );
      expect(await File(p.join(root.path, 'escape.txt')).exists(), isFalse);
      expect(await Directory(p.join(root.path, exercise.id)).exists(), isFalse);
    },
  );
  test('rejects linked workspace and Java sources', () async {
    if (Platform.isWindows) {
      return; // Creating Windows symlinks can require developer mode.
    }
    final outside = await Directory(p.join(root.path, 'outside')).create();
    await Link(p.join(root.path, exercise.id)).create(outside.path);
    await expectLater(
      WorkspaceService(source).prepare(root.path, exercise),
      throwsA(isA<FileSystemException>()),
    );
    await Link(p.join(root.path, exercise.id)).delete();
    final workspace = await WorkspaceService(
      source,
    ).prepare(root.path, exercise);
    await Link(
      p.join(workspace.path, 'src/main/java/linked'),
    ).create(outside.path);
    await expectLater(
      WorkspaceService.javaSources(workspace.path),
      throwsFormatException,
    );
  });
}
