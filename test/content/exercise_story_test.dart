import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:aiva/content/course_loader.dart';
import '../support/fixtures.dart';

void main() {
  test('every shipped exercise and project has its own optional story', () async {
    final course = await realCourse();
    final source = await realContentInMemory();
    final stories = <String>{};
    for (final exercise in course.exercises) {
      final story = exercise.story;
      expect(story, isNotNull, reason: exercise.id);
      expect(story!.world.trim(), isNotEmpty, reason: exercise.id);
      expect(story.text.trim(), isNotEmpty, reason: exercise.id);
      expect(stories.add(story.text), isTrue, reason: exercise.id);
      if (exercise.starter case final starter?) {
        for (final file in ['README.md', 'PROJECT.md']) {
          final document = source.files['$starter/$file'];
          if (file == 'PROJECT.md' && document == null) continue;
          expect(document, isNotNull, reason: '$starter/$file');
          final block = RegExp(
            r'<details>\s*<summary>Příběh v pozadí</summary>([\s\S]*?)</details>',
          ).firstMatch(document!);
          expect(block, isNotNull, reason: '$starter/$file');
          expect(block!.group(1), contains(story.world));
          expect(block.group(1), contains(story.text));
          expect(document, isNot(contains('<details open')));
        }
      }
    }
  });

  test('older exercise metadata can omit the story', () async {
    final source = await realContentInMemory();
    const path = 'lessons/what-is-programming.json';
    final lesson = jsonDecode(source.files[path]!) as Map<String, dynamic>;
    final exercise =
        (lesson['exercises'] as List).first as Map<String, dynamic>;
    exercise.remove('story');
    source.files[path] = jsonEncode(lesson);
    final course = await CourseLoader(source).load();
    expect(course.exercises.first.story, isNull);
    expect(course.exercises.first.prompt, exercise['prompt']);
  });

  for (final invalid in <Object?>[
    null,
    'Příběh',
    <String, Object?>{},
    {'world': 'Wednesday'},
    {'world': 'Wednesday', 'text': ''},
    {'world': ' ', 'text': 'Text'},
    {'world': 'Wednesday', 'text': 12},
    {'world': 'Wednesday', 'text': 'Text', 'open': true},
  ]) {
    test('rejects malformed story metadata: ${jsonEncode(invalid)}', () async {
      final source = await realContentInMemory();
      const path = 'lessons/what-is-programming.json';
      final lesson = jsonDecode(source.files[path]!) as Map<String, dynamic>;
      final exercise =
          (lesson['exercises'] as List).first as Map<String, dynamic>;
      exercise['story'] = invalid;
      source.files[path] = jsonEncode(lesson);
      await expectLater(CourseLoader(source).load(), throwsFormatException);
    });
  }
}
