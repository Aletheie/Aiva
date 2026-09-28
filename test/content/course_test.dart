import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:aiva/content/course_loader.dart';
import 'package:aiva/content/course_search.dart';
import 'package:aiva/content/strict_json.dart';
import 'package:aiva/content/java_tokens.dart';
import 'package:aiva/domain/course.dart';
import 'package:aiva/domain/profile.dart';
import 'package:aiva/platform/safe_paths.dart';
import '../support/fixtures.dart';

void main() {
  test(
    'loads the complete curriculum and preserves existing checked practice',
    () async {
      final course = await realCourse();
      expect(course.chapters, hasLength(33));
      expect(course.lessons, hasLength(78));
      expect(course.published, hasLength(78));
      expect(course.projects, hasLength(6));
      expect(course.mainPath, hasLength(45));
      expect(course.published.where((l) => l.optional), hasLength(33));
      final exercises = course.lessons.expand((l) => l.exercises).toList();
      expect(exercises, hasLength(171));
      expect(
        exercises.where((e) => e.validation is OutputValidation),
        hasLength(97),
      );
      expect(
        exercises
            .map((e) => e.validation)
            .whereType<OutputValidation>()
            .fold<int>(0, (sum, validation) => sum + validation.cases.length),
        418,
      );
      expect(course.lessons.where((l) => !l.isPublished), isEmpty);
    },
  );
  test(
    'planned lessons without content fields stay explicitly planned',
    () async {
      final course = await CourseLoader(
        await contentWithPlannedFilesLesson(),
      ).load();
      expect(course.lessons.where((l) => !l.isPublished), hasLength(1));
      expect(
        course.lessons
            .where((l) => !l.isPublished)
            .every((l) => l.markdown.isEmpty && l.exercises.isEmpty),
        isTrue,
      );
      expect(course.nextPublished(course.published.last.id), isNull);
      expect(
        course.nextPublished(course.published.first.id),
        course.mainPath[1],
      );
    },
  );
  test(
    'expanded practice defines the edit area and supplied context',
    () async {
      final course = await realCourse();
      final source = await realContentInMemory();
      final expanded = course.exercises.where(
        (exercise) => exercise.id.startsWith('ex-mission-'),
      );
      expect(expanded, hasLength(81));
      for (final exercise in expanded) {
        final validation = exercise.validation;
        if (validation is! OutputValidation) continue;
        expect(
          validation.cases.length,
          greaterThanOrEqualTo(4),
          reason: exercise.id,
        );
        expect(exercise.prompt, contains('## Tvůj zásah'), reason: exercise.id);
        expect(
          exercise.prompt,
          contains('## Připravené okolí'),
          reason: exercise.id,
        );
        final java =
            source.files['${exercise.starter}/src/main/java/Main.java']!;
        for (final marker in ['UPRAVUJ ODSUD', 'UPRAVUJ POTUD']) {
          expect(marker.allMatches(java), hasLength(1), reason: exercise.id);
          expect(exercise.solution, contains(marker), reason: exercise.id);
        }
      }
    },
  );
  test(
    'optional lessons can be skipped and never reduce main path progress',
    () async {
      final course = await realCourse();
      expect(course.optionalAfter('what-is-programming').map((l) => l.id), [
        'learning-routine',
      ]);
      expect(course.nextPublished('what-is-programming')?.id, 'how-java-works');
      expect(course.nextPublished('learning-routine')?.id, 'how-java-works');
      expect(course.nextPublished('missing'), isNull);
      expect(course.optionalAfter('missing'), isEmpty);
      expect(
        course.nextPublished('editor-helpers')?.id,
        'encapsulation-overview',
      );
      final optionalOnly = ProfileSnapshot(
        lessons: {
          for (final l in course.published.where((l) => l.optional))
            l.id: const LessonProgress(state: LessonState.completed),
        },
      );
      expect(optionalOnly.completedCount(course), 0);
      expect(optionalOnly.fraction(course), 0);
      final mainOnly = ProfileSnapshot(
        lessons: {
          for (final l in course.mainPath)
            l.id: const LessonProgress(state: LessonState.completed),
        },
      );
      expect(mainOnly.fraction(course), 1);
    },
  );
  test(
    'the route teaches prerequisites before lessons and project stops',
    () async {
      final course = await realCourse();
      final positions = {
        for (var i = 0; i < course.lessons.length; i++) course.lessons[i].id: i,
      };
      for (final lesson in course.lessons) {
        for (final id in lesson.prerequisites) {
          expect(
            positions[id],
            lessThan(positions[lesson.id]!),
            reason: '${lesson.id} needs $id',
          );
          if (!lesson.optional) {
            expect(course.lessonsById[id]!.optional, isFalse);
          }
        }
      }
      for (final project in course.projects) {
        for (final id in project.prerequisites) {
          expect(
            positions[id],
            lessThanOrEqualTo(positions[project.afterLesson]!),
            reason: project.id,
          );
        }
      }
      expect(course.projectsAfter('while-loops').single.id, 'project-guessing');
      expect(course.projectsAfter('files-overview').map((p) => p.id), [
        'project-contacts',
        'project-library',
      ]);
      expect(course.projectIsAvailable(course.projects.first), isTrue);
      expect(course.projects.every(course.projectIsAvailable), isTrue);
    },
  );
  test('practice follows the topic that explains it', () async {
    final course = await realCourse();
    for (final pair in {
      'ex-types-rating': 'number-conversions',
      'ex-logic-backstage': 'logic-and-comparisons',
      'ex-input-trip-budget': 'console-numbers',
      'ex-while-ticket-machine': 'while-loops',
      'ex-methods-shipping': 'parameters-and-return',
      'ex-arrays-step-streak': 'array-traversal',
      'ex-objects-counter': 'constructors',
    }.entries) {
      expect(
        course.lessonsById[pair.value]!.exercises.any((e) => e.id == pair.key),
        isTrue,
      );
    }
    expect(
      course.lessons.where((l) => l.chapter == 'ch-small-shortcuts'),
      hasLength(6),
    );
    expect(
      course.lessons
          .where((l) => l.chapter == 'ch-small-shortcuts')
          .every((l) => l.optional && l.isPublished),
      isTrue,
    );
  });
  test(
    'extensions stay optional while core gaps belong to the main path',
    () async {
      final course = await realCourse();
      for (final id in ['null-and-contracts', 'packages-and-imports']) {
        expect(course.mainPath.map((lesson) => lesson.id), contains(id));
      }
      for (final id in [
        'nested-arrays',
        'recursion',
        'random-and-seeds',
        'immutable-data',
        'searching-and-complexity',
        'dates-and-time',
        'regular-expressions',
        'sorting-and-comparators',
        'optional-values',
        'http-client',
        'sql-and-jdbc',
        'concurrency-basics',
        'shipping-java',
        'json-overview',
        'xml-overview',
        'yaml-overview',
        'lambdas-overview',
        'streams-overview',
        'testing-doubles',
        'gradle-overview',
        'course-review',
      ]) {
        final lesson = course.lessonsById[id]!;
        expect(lesson.isPublished, isTrue, reason: id);
        expect(lesson.optional, isTrue, reason: id);
        expect(lesson.exercises, isNotEmpty, reason: id);
      }
      expect(course.nextPublished('maven-overview')?.id, 'debugging-overview');
      expect(course.nextPublished('structure-overview'), isNull);
    },
  );
  test(
    'older lesson metadata without optional remains on the main path',
    () async {
      final source = await realContentInMemory();
      const path = 'lessons/what-is-programming.json';
      final lesson = decodeObject(source.files[path]!, path)
        ..remove('optional');
      source.files[path] = jsonEncode(lesson);
      expect(
        (await CourseLoader(
          source,
        ).load()).lessonsById['what-is-programming']!.optional,
        isFalse,
      );
    },
  );
  for (final invalid in <Object?>['true', 1, null]) {
    test('rejects a non-boolean optional flag: $invalid', () async {
      final source = await realContentInMemory();
      const path = 'lessons/what-is-programming.json';
      final lesson = decodeObject(source.files[path]!, path)
        ..['optional'] = invalid;
      source.files[path] = jsonEncode(lesson);
      await expectLater(CourseLoader(source).load(), throwsFormatException);
    });
  }
  test(
    'all prerequisites resolve; every full lesson has substantial material',
    () async {
      final course = await realCourse();
      for (final lesson in course.published) {
        expect(
          lesson.markdown.split(RegExp(r'\s+')).length,
          greaterThan(250),
          reason: '${lesson.id} must contain substantive teaching',
        );
        expect(lesson.examples, isNotEmpty);
        expect(lesson.commonMistakes, isNotEmpty);
        expect(lesson.takeaway, isNotEmpty);
        for (final id in lesson.prerequisites) {
          expect(course.lessonsById.containsKey(id), isTrue);
        }
      }
    },
  );
  test('published reading-only lessons keep content and progression', () async {
    final course = await realCourse();
    final readingOnly = course.published.where((l) => l.exercises.isEmpty);
    expect(readingOnly, hasLength(13));
    expect(readingOnly.any((l) => !l.optional), isTrue);
    expect(course.lessonsById['how-java-works']!.markdown, isNotEmpty);
    expect(course.nextPublished('how-java-works')?.id, 'jdk-and-ide');
  });
  test(
    'lesson links resolve across reading, exercises, hints and projects',
    () async {
      final course = await realCourse();
      var links = 0;
      for (final text in [
        ...course.lessons.map((lesson) => lesson.markdown),
        ...course.exercises.expand(
          (exercise) => [exercise.prompt, ...exercise.hints, exercise.solution],
        ),
      ]) {
        for (final match in RegExp(r'\]\(lesson:([^)]+)\)').allMatches(text)) {
          expect(
            course.lessonsById.containsKey(match[1]),
            isTrue,
            reason: match[1],
          );
          links++;
        }
      }
      expect(links, greaterThan(40));
    },
  );
  test(
    'search ranks Czech and English topic names above incidental mentions',
    () async {
      final search = CourseSearch(await realCourse());
      for (final query in ['promenne', 'PROMĚNNÉ', 'variables assignment']) {
        expect(search.find(query).first.id, 'variables');
      }
      expect(search.find('return value').first.id, 'parameters-and-return');
      expect(search.find('pass by value').first.id, 'pass-by-value');
      expect(search.find('xyz-neexistujici-pojem'), isEmpty);
    },
  );
  for (final pair in <(String, String)>[
    ('duplicate keys', '{"x":1,"x":2}'),
    ('escaped duplicate keys', r'{"a":1,"\u0061":2}'),
    ('nested duplicate', '{"x":{"a":1,"a":2}}'),
    ('trailing comma', '{"x":1,}'),
    ('trailing data', '{} {}'),
    ('bad number', '{"x":01}'),
    ('non-object root', '[]'),
    ('truncated', '{"x":'),
  ]) {
    test(
      'rejects ${pair.$1}',
      () => expect(
        () => decodeObject(pair.$2, 'test.json'),
        throwsFormatException,
      ),
    );
  }
  test('rejects deeply nested JSON before decoder', () {
    final text = '{"x":${'[' * 70}0${']' * 70}}';
    expect(() => decodeObject(text, 'deep.json'), throwsFormatException);
  });
  test('keeps unicode, null, bool and different objects with same key', () {
    final json = decodeObject(
      '{"a":{"x":"Příliš žluťoučký"},"b":{"x":null},"c":true}',
      'ok.json',
    );
    expect((json['a']! as Map<String, Object?>)['x'], 'Příliš žluťoučký');
    expect(json['c'], isTrue);
  });
  test(
    'rejects unknown metadata field rather than silently dropping it',
    () async {
      final source = await realContentInMemory();
      final data = decodeObject(source.files['course.json']!, 'course.json')
        ..['typo'] = true;
      source.files['course.json'] = jsonEncode(data);
      await expectLater(CourseLoader(source).load(), throwsFormatException);
    },
  );
  test('rejects duplicate lesson IDs', () async {
    final source = await realContentInMemory();
    final root = decodeObject(source.files['course.json']!, 'course');
    final paths = (root['lessons']! as List<Object?>).cast<String>();
    final first = decodeObject(source.files[paths[0]]!, paths[0]);
    final second = decodeObject(source.files[paths[1]]!, paths[1])
      ..['id'] = first['id'];
    source.files[paths[1]] = jsonEncode(second);
    await expectLater(CourseLoader(source).load(), throwsFormatException);
  });
  test('rejects prerequisite cycles', () async {
    final source = await realContentInMemory();
    final root = decodeObject(source.files['course.json']!, 'course');
    final path = (root['lessons']! as List<Object?>).first! as String;
    final lesson = decodeObject(source.files[path]!, path);
    lesson['prerequisites'] = [lesson['id']];
    source.files[path] = jsonEncode(lesson);
    await expectLater(CourseLoader(source).load(), throwsFormatException);
  });
  test('rejects unsafe content traversal', () async {
    final source = await realContentInMemory();
    final root = decodeObject(source.files['course.json']!, 'course');
    root['lessons'] = ['../outside.json'];
    source.files['course.json'] = jsonEncode(root);
    await expectLater(CourseLoader(source).load(), throwsFormatException);
  });
  for (final unsafe in [
    '../x',
    '/x',
    r'C:\x',
    'a//b',
    'a/./b',
    'a/CON.txt',
    'a/file.',
    'a/file ',
    'a:x',
    'x\x00y',
  ]) {
    test(
      'rejects unsafe path $unsafe',
      () => expect(() => checkedRelative(unsafe), throwsFormatException),
    );
  }
  test('allows normal portable unicode and dotted names', () {
    expect(
      checkedRelative('složka s mezerou/.gitignore'),
      'složka s mezerou/.gitignore',
    );
  });
  test('JDK version parsing ignores a warning number', () {
    expect(parseJdkMajor('WARNING: issue 123\nopenjdk 25.0.1 2025-10-21'), 25);
    expect(parseJdkMajor('javac 21.0.11'), 21);
    expect(parseJdkMajor('java version "1.8.0_402"'), 8);
    expect(parseJdkMajor('error code 21'), isNull);
  });
  test('output normalization preserves meaningful whitespace', () {
    expect(normalizeOutput('x\r\n'), 'x');
    expect(normalizeOutput('x\n\n'), 'x\n');
    expect(normalizeOutput(' x \n'), ' x ');
  });
  test('Czech search is case and accent insensitive', () {
    expect(searchable('PŘÍLIŠ ŽLUŤOUČKÝ'), 'prilis zlutoucky');
    expect(searchable('Předávání hodnotou').contains('predavani'), isTrue);
  });
  test(
    'Java tokenizer preserves exact source including comments and text blocks',
    () {
      const code =
          'class P {\n  // číslo\n  String s = "a\\"b"; /* hi\n bye */\n  int x = 12;\n}\n';
      final tokens = tokenizeJava(code);
      expect(tokens.map((t) => t.text).join(), code);
      expect(tokens.any((t) => t.kind == JavaTokenKind.keyword), isTrue);
      expect(
        tokens.any(
          (t) => t.kind == JavaTokenKind.comment && t.text.contains('bye'),
        ),
        isTrue,
      );
    },
  );
}
