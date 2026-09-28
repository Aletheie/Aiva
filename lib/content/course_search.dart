import '../domain/course.dart';

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
    final ranked = <({Lesson lesson, int score, int order})>[];
    for (var index = 0; index < _entries.length; index++) {
      final entry = _entries[index];
      if (!words.every(
        (word) => entry.title.contains(word) || entry.body.contains(word),
      )) {
        continue;
      }
      var score = entry.lesson.isPublished ? 5 : 0;
      if (entry.title == normalized) score += 100;
      if (entry.title.startsWith(normalized)) score += 40;
      score += words.where(entry.title.contains).length * 15;
      ranked.add((lesson: entry.lesson, score: score, order: index));
    }
    ranked.sort((a, b) {
      final score = b.score.compareTo(a.score);
      return score != 0 ? score : a.order.compareTo(b.order);
    });
    return [for (final result in ranked) result.lesson];
  }
}

final class _Entry {
  const _Entry(this.lesson, this.title, this.body);
  final Lesson lesson;
  final String title;
  final String body;
}
