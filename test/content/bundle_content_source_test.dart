import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:aiva/content/bundle_content_source.dart';
import 'package:aiva/content/course_loader.dart';
import 'package:aiva/domain/course.dart';
import 'package:aiva/services/workspace_service.dart';

/// Like an app bundle being replaced by a build while the app keeps running.
class _ReplaceableBundle extends CachingAssetBundle {
  final files = <String, Uint8List>{};

  void replace(Map<String, String> content) {
    files.clear();
    for (final entry in content.entries) {
      files['content/${entry.key}'] = Uint8List.fromList(
        utf8.encode(entry.value),
      );
    }
    files['assets/content-index.json'] = Uint8List.fromList(
      utf8.encode(
        jsonEncode({
          'schemaVersion': 1,
          'files': [
            for (final entry in content.entries)
              {'path': entry.key, 'bytes': utf8.encode(entry.value).length},
          ],
        }),
      ),
    );
  }

  @override
  Future<ByteData> load(String key) async {
    final bytes = files[key];
    if (bytes == null) throw FlutterError('Unable to load asset: "$key".');
    // Include a buffer offset, as an AssetBundle need not return a whole buffer.
    final buffer = Uint8List(bytes.length + 2)
      ..setRange(1, bytes.length + 1, bytes);
    return ByteData.sublistView(buffer, 1, bytes.length + 1);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bundled course and starters match the shipped content index', () async {
    final source = await BundleContentSource.load();
    final course = await CourseLoader(source).load();
    expect(course.published, isNotEmpty);
    expect(await source.filesUnder('starters'), isNotEmpty);
  });

  const oldExercise = Exercise(
    id: 'ex-types-average',
    title: 'Průměr',
    kind: 'Najdi chybu',
    difficulty: Difficulty.easy,
    prompt: 'Oprav dělení.',
    hints: [],
    solution: 'Převeď operand.',
    starter: 'starters/ex-types-average',
    validation: ManualValidation(['Hotovo']),
  );

  test(
    'an open exercise survives replacement of its bundled starter',
    () async {
      final bundle = _ReplaceableBundle()
        ..replace({
          'lessons/types.md': 'Původní zadání',
          'starters/ex-types-average/.gitignore': 'target/\n',
          'starters/ex-types-average/src/main/java/Main.java':
              'class Main {}\n',
        });
      // Model a cached index from the currently open app as well.
      await bundle.loadString('assets/content-index.json');
      final oldSource = await BundleContentSource.load(bundle);

      bundle.replace({
        'lessons/types.md': 'Nové zadání',
        'starters/ex-types-rating/src/main/java/Main.java':
            'class Main { int rating; }\n',
      });
      final root = await Directory.systemTemp.createTemp('aiva bundle update ');
      addTearDown(() => root.delete(recursive: true));
      final result = await WorkspaceService(
        oldSource,
      ).prepare(root.path, oldExercise);
      expect(result.created, isTrue);
      expect(await oldSource.readText('lessons/types.md'), 'Původní zadání');
      expect(
        await File(p.join(result.path, '.gitignore')).readAsString(),
        'target/\n',
      );
      expect(
        await File(
          p.join(result.path, 'src/main/java/Main.java'),
        ).readAsString(),
        'class Main {}\n',
      );

      // A new load must get the new course and index, not cached metadata.
      final newSource = await BundleContentSource.load(bundle);
      expect(await newSource.readText('lessons/types.md'), 'Nové zadání');
      expect(await newSource.filesUnder('starters/ex-types-average'), isEmpty);
      expect(
        await newSource.filesUnder('starters/ex-types-rating'),
        hasLength(1),
      );
    },
  );

  test('missing starter is detected before any lesson can be opened', () async {
    final bundle = _ReplaceableBundle()
      ..replace({'starters/ex-types-average/.gitignore': 'target/\n'});
    bundle.files.remove('content/starters/ex-types-average/.gitignore');
    await expectLater(
      BundleContentSource.load(bundle),
      throwsA(isA<FlutterError>()),
    );
  });

  test('a replaced file must match the indexed byte count', () async {
    final bundle = _ReplaceableBundle()
      ..replace({'lessons/types.md': 'Původní zadání'});
    bundle.files['content/lessons/types.md'] = Uint8List.fromList(
      utf8.encode('Jiná verze'),
    );
    await expectLater(BundleContentSource.load(bundle), throwsFormatException);
  });
}
