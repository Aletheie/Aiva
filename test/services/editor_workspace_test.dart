import 'dart:convert';
import 'dart:io';

import 'package:aiva/services/editor_workspace.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory root;
  Future<File> write(String relative, String text) async {
    final file = File(p.join(root.path, relative));
    await file.parent.create(recursive: true);
    return file.writeAsString(text);
  }

  setUp(() async {
    root = await Directory.systemTemp.createTemp('Aiva editor žluťoučký ');
  });
  tearDown(() => root.delete(recursive: true));

  test(
    'loads project text while excluding metadata and generated files',
    () async {
      for (final path in [
        'src/main/java/Main.java',
        'pom.xml',
        'build.gradle.kts',
        'gradle.properties',
        'README.md',
        'data/test.csv',
        '.gitignore',
        'sample.txt',
        'data.json',
        'sample.yaml',
      ]) {
        await write(path, 'Text žluťoučký\r\n');
      }
      await write('.aiva-workspace.json', '{}');
      await write('target/generated.java', 'ignored');
      await write('.git/config.txt', 'ignored');
      await write('image.png', 'ignored');
      final workspace = await EditorWorkspace.open(root.path);
      addTearDown(workspace.dispose);
      expect(workspace.files, hasLength(10));
      expect(workspace.files.first.relativePath, 'src/main/java/Main.java');
      expect(workspace.files.first.text, 'Text žluťoučký\r\n');
      expect(workspace.hasUnsavedChanges, isFalse);
      expect(() => workspace.files.clear(), throwsUnsupportedError);
      expect(() => workspace.file('../outside.java'), throwsFormatException);
      expect(() => workspace.file('.aiva-workspace.json'), throwsArgumentError);
    },
  );

  test('saves UTF-8 and preserves BOM and untouched CRLF files', () async {
    final source = await write('Main.java', '');
    await source.writeAsBytes([
      0xef,
      0xbb,
      0xbf,
      ...utf8.encode('original\r\n'),
    ]);
    final readme = await write('README.md', 'same\r\n');
    final originalReadme = await readme.readAsBytes();
    final workspace = await EditorWorkspace.open(root.path);
    addTearDown(workspace.dispose);
    workspace.edit('Main.java', 'upravený\r\n');
    expect(workspace.file('Main.java').savedText, 'original\r\n');
    expect(workspace.hasUnsavedChanges, isTrue);
    await workspace.saveAll();
    expect(await source.readAsBytes(), [
      0xef,
      0xbb,
      0xbf,
      ...utf8.encode('upravený\r\n'),
    ]);
    expect(await readme.readAsBytes(), originalReadme);
    expect(workspace.hasUnsavedChanges, isFalse);
    expect(
      await root
          .list()
          .where((entry) => p.basename(entry.path).startsWith('.aiva-save-'))
          .isEmpty,
      isTrue,
    );
  });

  test(
    'preflights conflicts without overwriting either version or other files',
    () async {
      final first = await write('A.java', 'original A');
      final second = await write('B.java', 'original B');
      final workspace = await EditorWorkspace.open(root.path);
      addTearDown(workspace.dispose);
      workspace.edit('A.java', 'mine A');
      workspace.edit('B.java', 'mine B');
      await second.writeAsString('external B');
      await expectLater(
        workspace.saveAll(),
        throwsA(
          isA<EditorConflictException>().having(
            (error) => error.paths,
            'paths',
            ['B.java'],
          ),
        ),
      );
      expect(await first.readAsString(), 'original A');
      expect(await second.readAsString(), 'external B');
      expect(workspace.file('A.java').text, 'mine A');
      expect(workspace.file('B.java').text, 'mine B');
      expect(workspace.hasUnsavedChanges, isTrue);
      await expectLater(workspace.reload('B.java'), throwsStateError);
      await workspace.reload('B.java', discardChanges: true);
      expect(workspace.file('B.java').text, 'external B');
      await workspace.saveAll();
      expect(await first.readAsString(), 'mine A');
      expect(await second.readAsString(), 'external B');
      expect(workspace.hasUnsavedChanges, isFalse);
    },
  );

  test('does not recreate files removed by another editor', () async {
    final source = await write('Main.java', 'original');
    final workspace = await EditorWorkspace.open(root.path);
    addTearDown(workspace.dispose);
    workspace.edit('Main.java', 'mine');
    await source.delete();
    await expectLater(
      workspace.saveAll(),
      throwsA(isA<EditorConflictException>()),
    );
    expect(await source.exists(), isFalse);
    expect(workspace.file('Main.java').text, 'mine');
  });

  test('refreshes clean files and discovers added and removed files', () async {
    final source = await write('Main.java', 'original');
    final removed = await write('README.md', 'old instructions');
    final workspace = await EditorWorkspace.open(root.path);
    addTearDown(workspace.dispose);
    final originalBuffer = workspace.file('Main.java');
    await source.writeAsString('external edit');
    await removed.delete();
    await write('src/Added.java', 'new class');
    await write('target/Generated.java', 'ignored');

    await workspace.refresh();

    expect(workspace.files.map((file) => file.relativePath), [
      'Main.java',
      'src/Added.java',
    ]);
    expect(workspace.file('Main.java'), same(originalBuffer));
    expect(originalBuffer.text, 'external edit');
    expect(originalBuffer.savedText, 'external edit');
    expect(workspace.file('src/Added.java').text, 'new class');
    expect(() => workspace.file('README.md'), throwsArgumentError);
    expect(workspace.hasUnsavedChanges, isFalse);
    expect(() => workspace.files.clear(), throwsUnsupportedError);
    workspace.edit('Main.java', 'my subsequent edit');
    await workspace.saveAll();
    expect(await source.readAsString(), 'my subsequent edit');
  });

  test(
    'refresh preserves dirty changed and deleted files and conflicts',
    () async {
      final changed = await write('Changed.java', 'original changed');
      final deleted = await write('Deleted.java', 'original deleted');
      final workspace = await EditorWorkspace.open(root.path);
      addTearDown(workspace.dispose);
      workspace.edit('Changed.java', 'mine changed');
      workspace.edit('Deleted.java', 'mine deleted');
      final changedBuffer = workspace.file('Changed.java');
      final deletedBuffer = workspace.file('Deleted.java');
      await changed.writeAsString('external changed');
      await deleted.delete();
      await write('Added.java', 'added');

      await workspace.refresh();

      expect(workspace.file('Changed.java'), same(changedBuffer));
      expect(workspace.file('Deleted.java'), same(deletedBuffer));
      expect(changedBuffer.text, 'mine changed');
      expect(changedBuffer.savedText, 'original changed');
      expect(deletedBuffer.text, 'mine deleted');
      expect(deletedBuffer.savedText, 'original deleted');
      expect(workspace.file('Added.java').text, 'added');
      await expectLater(
        workspace.saveAll(),
        throwsA(
          isA<EditorConflictException>().having(
            (error) => error.paths,
            'paths',
            ['Changed.java', 'Deleted.java'],
          ),
        ),
      );
      expect(await changed.readAsString(), 'external changed');
      expect(await deleted.exists(), isFalse);
    },
  );

  test('serializes refresh with saves and retains new edits', () async {
    final source = await write('Main.java', 'original');
    final workspace = await EditorWorkspace.open(root.path);
    addTearDown(workspace.dispose);
    workspace.edit('Main.java', 'first edit');
    var typed = false;
    workspace.addListener(() {
      if (!typed && workspace.file('Main.java').savedText == 'first edit') {
        typed = true;
        workspace.edit('Main.java', 'second edit');
      }
    });

    await Future.wait([workspace.saveAll(), workspace.refresh()]);

    expect(await source.readAsString(), 'first edit');
    expect(workspace.file('Main.java').text, 'second edit');
    expect(workspace.file('Main.java').savedText, 'first edit');
    expect(workspace.hasUnsavedChanges, isTrue);
    await workspace.saveAll();
    expect(await source.readAsString(), 'second edit');
  });

  test(
    'failed refresh leaves every buffer and the file list unchanged',
    () async {
      final source = await write('Main.java', 'original');
      final workspace = await EditorWorkspace.open(root.path);
      addTearDown(workspace.dispose);
      await source.writeAsString('external');
      await write('Added.java', 'new');
      final oversized = await write(
        'TooLarge.java',
        'a' * (EditorWorkspace.maxFileBytes + 1),
      );

      await expectLater(workspace.refresh(), throwsFormatException);

      expect(workspace.files, hasLength(1));
      expect(workspace.file('Main.java').text, 'original');
      expect(workspace.file('Main.java').savedText, 'original');
      await oversized.delete();
      await workspace.refresh();
      expect(workspace.files, hasLength(2));
      expect(workspace.file('Main.java').text, 'external');
    },
  );

  test('refresh rejects symlinks and retains unsaved buffers', () async {
    if (Platform.isWindows) return;
    final source = await write('Main.java', 'original');
    final workspace = await EditorWorkspace.open(root.path);
    addTearDown(workspace.dispose);
    workspace.edit('Main.java', 'mine');
    final outside = await Directory.systemTemp.createTemp('Aiva outside ');
    addTearDown(() => outside.delete(recursive: true));
    final target = await File(
      p.join(outside.path, 'Main.java'),
    ).writeAsString('outside');
    await source.delete();
    await Link(source.path).create(target.path);

    await expectLater(workspace.refresh(), throwsA(isA<FileSystemException>()));

    expect(workspace.file('Main.java').text, 'mine');
    expect(workspace.file('Main.java').savedText, 'original');
    expect(await target.readAsString(), 'outside');
  });

  test(
    'retains edits typed during saving and serializes queued saves',
    () async {
      await write('A.java', 'original A');
      final second = await write('B.java', 'original B');
      final workspace = await EditorWorkspace.open(root.path);
      addTearDown(workspace.dispose);
      workspace.edit('A.java', 'first A');
      workspace.edit('B.java', 'first B');
      var typed = false;
      workspace.addListener(() {
        if (!typed && workspace.file('A.java').savedText == 'first A') {
          typed = true;
          workspace.edit('B.java', 'second B');
        }
      });
      await workspace.saveAll();
      expect(await second.readAsString(), 'first B');
      expect(workspace.file('B.java').savedText, 'first B');
      expect(workspace.file('B.java').text, 'second B');
      expect(workspace.file('B.java').isDirty, isTrue);
      await Future.wait([workspace.saveAll(), workspace.saveAll()]);
      expect(await second.readAsString(), 'second B');
      expect(workspace.hasUnsavedChanges, isFalse);
    },
  );

  test(
    'rejects large and binary text without loading unbounded contents',
    () async {
      final source = await write(
        'Main.java',
        'a' * (EditorWorkspace.maxFileBytes + 1),
      );
      await expectLater(EditorWorkspace.open(root.path), throwsFormatException);
      await source.writeAsBytes([0, 1, 2]);
      await expectLater(EditorWorkspace.open(root.path), throwsFormatException);
      await source.writeAsBytes([0xff]);
      await expectLater(EditorWorkspace.open(root.path), throwsFormatException);
    },
  );

  test(
    'rejects oversized edits before writing and retains their buffers',
    () async {
      final source = await write('Main.java', 'original');
      final workspace = await EditorWorkspace.open(root.path);
      addTearDown(workspace.dispose);
      workspace.edit('Main.java', 'ž' * EditorWorkspace.maxFileBytes);
      await expectLater(workspace.saveAll(), throwsFormatException);
      expect(await source.readAsString(), 'original');
      expect(workspace.hasUnsavedChanges, isTrue);
    },
  );

  test(
    'rejects symlinks when opening and when an open file is replaced',
    () async {
      if (Platform.isWindows) return;
      final outside = await Directory.systemTemp.createTemp('Aiva outside ');
      addTearDown(() => outside.delete(recursive: true));
      final outsideFile = await File(
        p.join(outside.path, 'Main.java'),
      ).writeAsString('external');
      final link = await Link(
        p.join(root.path, 'Main.java'),
      ).create(outsideFile.path);
      await expectLater(
        EditorWorkspace.open(root.path),
        throwsA(isA<FileSystemException>()),
      );
      await link.delete();
      final source = await write('src/Main.java', 'original');
      final workspace = await EditorWorkspace.open(root.path);
      addTearDown(workspace.dispose);
      workspace.edit('src/Main.java', 'mine');
      await source.parent.rename(p.join(root.path, 'original-src'));
      await Link(source.parent.path).create(outside.path);
      await expectLater(
        workspace.saveAll(),
        throwsA(isA<FileSystemException>()),
      );
      expect(await outsideFile.readAsString(), 'external');
      expect(workspace.file('src/Main.java').text, 'mine');
    },
  );
}
