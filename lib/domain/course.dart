enum Difficulty {
  easy('Základní'),
  normal('Procvičení'),
  challenge('Výzva');

  const Difficulty(this.label);
  final String label;
}

enum Publication { published, planned }

enum LessonState { notStarted, inProgress, completed }

enum ExerciseState { notStarted, attempted, completed }

final class CodeExample {
  const CodeExample(this.caption, this.code, this.highlightedLines);
  final String caption;
  final String code;
  final List<int> highlightedLines;
}

sealed class Validation {
  const Validation();
}

final class OutputCase {
  const OutputCase({required this.input, required this.expected});
  final String input;
  final String expected;
}

final class OutputValidation extends Validation {
  const OutputValidation({
    required this.mainClass,
    required this.javaRelease,
    required this.timeoutMs,
    required this.cases,
  });
  final String mainClass;
  final int javaRelease;
  final int timeoutMs;
  final List<OutputCase> cases;
}

final class ChoiceValidation extends Validation {
  const ChoiceValidation({
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

final class ManualValidation extends Validation {
  const ManualValidation(this.checklist);
  final List<String> checklist;
}

final class ExerciseStory {
  const ExerciseStory({required this.world, required this.text});
  final String world;
  final String text;
}

final class Exercise {
  const Exercise({
    required this.id,
    required this.title,
    required this.kind,
    required this.difficulty,
    required this.prompt,
    required this.hints,
    required this.solution,
    required this.validation,
    this.starter,
    this.story,
  });
  final String id;
  final String title;
  final String kind;
  final Difficulty difficulty;
  final String prompt;
  final String? starter;
  final ExerciseStory? story;
  final List<String> hints;
  final String solution;
  final Validation validation;
}

final class Chapter {
  const Chapter({
    required this.id,
    required this.title,
    required this.group,
    required this.order,
    required this.topics,
  });
  final String id;
  final String title;
  final String group;
  final int order;
  final List<String> topics;
}

final class Lesson {
  const Lesson({
    required this.id,
    required this.chapter,
    required this.title,
    required this.subtitle,
    required this.order,
    required this.estimatedMinutes,
    required this.difficulty,
    required this.publication,
    required this.prerequisites,
    required this.markdown,
    required this.examples,
    required this.commonMistakes,
    required this.takeaway,
    required this.exercises,
    this.optional = false,
  });
  final String id;
  final String chapter;
  final String title;
  final String subtitle;
  final int order;
  final int estimatedMinutes;
  final Difficulty difficulty;
  final Publication publication;
  final List<String> prerequisites;
  final String markdown;
  final List<CodeExample> examples;
  final List<String> commonMistakes;
  final String takeaway;
  final List<Exercise> exercises;
  final bool optional;
  bool get isPublished => publication == Publication.published;
}

final class CourseProject {
  const CourseProject({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.afterLesson,
    required this.estimatedMinutes,
    required this.prerequisites,
    required this.exercise,
  });
  final String id;
  final String title;
  final String subtitle;
  final String afterLesson;
  final int estimatedMinutes;
  final List<String> prerequisites;
  final Exercise exercise;
}

final class Course {
  Course({
    required this.title,
    required List<Chapter> chapters,
    required List<Lesson> lessons,
    required List<CourseProject> projects,
  }) : chapters = List.unmodifiable(chapters),
       lessons = List.unmodifiable(lessons),
       projects = List.unmodifiable(projects),
       lessonsById = Map.unmodifiable({for (final l in lessons) l.id: l}),
       chaptersById = Map.unmodifiable({for (final c in chapters) c.id: c});
  final String title;
  final List<Chapter> chapters;
  final List<Lesson> lessons;
  final List<CourseProject> projects;
  final Map<String, Lesson> lessonsById;
  final Map<String, Chapter> chaptersById;
  List<Lesson> get published => lessons.where((l) => l.isPublished).toList();
  List<Lesson> get mainPath =>
      lessons.where((l) => l.isPublished && !l.optional).toList();
  List<String> get groups => chapters.map((c) => c.group).toSet().toList();
  Iterable<Exercise> get exercises sync* {
    for (final lesson in lessons) {
      yield* lesson.exercises;
    }
    for (final project in projects) {
      yield project.exercise;
    }
  }

  List<Lesson> inGroup(String group) =>
      lessons.where((l) => chaptersById[l.chapter]?.group == group).toList();
  Lesson? nextPublished(String id) {
    final index = lessons.indexWhere((l) => l.id == id);
    if (index < 0) return null;
    for (final lesson in lessons.skip(index + 1)) {
      if (lesson.isPublished && !lesson.optional) return lesson;
    }
    return null;
  }

  List<Lesson> optionalAfter(String id) {
    final index = lessons.indexWhere((l) => l.id == id);
    if (index < 0) return const [];
    return lessons
        .skip(index + 1)
        .takeWhile((l) => l.optional)
        .where((l) => l.isPublished)
        .toList();
  }

  List<CourseProject> projectsAfter(String id) =>
      projects.where((p) => p.afterLesson == id).toList();
  bool projectIsAvailable(CourseProject project) => [
    project.afterLesson,
    ...project.prerequisites,
  ].every((id) => lessonsById[id]?.isPublished == true);
  List<Lesson> prerequisitesFor(Lesson lesson, Set<String> completed) => lesson
      .prerequisites
      .where((id) => !completed.contains(id))
      .map((id) => lessonsById[id]!)
      .toList();
}

bool validId(String id) =>
    id.length <= 96 && RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(id);

String normalizeOutput(String text) {
  final normalized = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  return normalized.endsWith('\n')
      ? normalized.substring(0, normalized.length - 1)
      : normalized;
}

int? parseJdkMajor(String text) {
  // Ignore numbers in warnings preceding the version line.
  final match = RegExp(
    r'^(?:openjdk|java|javac)(?:\s+version)?\s+"?(\d+)(?:\.(\d+))?',
    multiLine: true,
    caseSensitive: false,
  ).firstMatch(text.trim());
  if (match == null) return null;
  final major = int.tryParse(match.group(1)!);
  return major == 1 ? int.tryParse(match.group(2) ?? '') : major;
}

String searchable(String text) {
  const from = 'áčďéěíňóřšťúůýž';
  const to = 'acdeeinorstuuyz';
  var result = text.toLowerCase();
  for (var i = 0; i < from.length; i++) {
    result = result.replaceAll(from[i], to[i]);
  }
  return result;
}
