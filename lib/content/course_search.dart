import '../domain/course.dart';

/// Normalized once, so the command palette also searches explanations and tasks.
final class CourseSearch {
  CourseSearch(Course course)
    : _entries = [
        for (final lesson in course.lessons)
          _Entry(
            lesson,
            searchable(lesson.title),
            searchable(
              [
                lesson.subtitle,
                lesson.markdown,
                ...course.chaptersById[lesson.chapter]?.topics ?? [],
                for (final exercise in lesson.exercises)
                  '${exercise.title} ${exercise.prompt}',
              ].join(' '),
            ),
          ),
      ];
  final List<_Entry> _entries;

  List<Lesson> find(String query) {
    final normalized = searchable(query).trim();
    if (normalized.isEmpty) return const [];
    final words = normalized.split(RegExp(r'\s+'));
    final ranked = <(Lesson, int)>[];
    for (final entry in _entries) {
      if (!words.every(
        (word) => entry.title.contains(word) || entry.body.contains(word),
      )) {
        continue;
      }
      var score = entry.lesson.isPublished ? 5 : 0;
      if (entry.title == normalized) score += 100;
      if (entry.title.startsWith(normalized)) score += 40;
      score += words.where(entry.title.contains).length * 15;
      ranked.add((entry.lesson, score));
    }
    ranked.sort((a, b) {
      final order = b.$2.compareTo(a.$2);
      return order != 0
          ? order
          : _entries
                .indexWhere((e) => e.lesson.id == a.$1.id)
                .compareTo(_entries.indexWhere((e) => e.lesson.id == b.$1.id));
    });
    return [for (final result in ranked) result.$1];
  }
}

final class _Entry {
  const _Entry(this.lesson, this.title, this.body);
  final Lesson lesson;
  final String title;
  final String body;
}
