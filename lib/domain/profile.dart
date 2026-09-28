import 'course.dart';

final class LessonProgress {
  const LessonProgress({
    this.state = LessonState.notStarted,
    this.skipped = false,
    this.favorite = false,
  });
  final LessonState state;
  final bool skipped;
  final bool favorite;
}

final class ProfileSnapshot {
  const ProfileSnapshot({
    this.lessons = const {},
    this.exercises = const {},
    this.settings = const {},
    this.recent = const [],
    this.readerOffsets = const {},
  });
  final Map<String, LessonProgress> lessons;
  final Map<String, ExerciseState> exercises;
  final Map<String, String> settings;
  final List<String> recent;
  final Map<String, double> readerOffsets;
  LessonProgress lesson(String id) => lessons[id] ?? const LessonProgress();
  ExerciseState exercise(String id) =>
      exercises[id] ?? ExerciseState.notStarted;
  String setting(String key, [String fallback = '']) =>
      settings[key] ?? fallback;
  Set<String> get completed => lessons.entries
      .where((e) => e.value.state == LessonState.completed)
      .map((e) => e.key)
      .toSet();
  int completedCount(Course course) => course.mainPath
      .where((l) => lesson(l.id).state == LessonState.completed)
      .length;
  double fraction(Course course) => course.mainPath.isEmpty
      ? 0
      : completedCount(course) / course.mainPath.length;
}

sealed class ProfileEdit {
  const ProfileEdit();
}

final class VisitLesson extends ProfileEdit {
  const VisitLesson(this.id);
  final String id;
}

final class SetLessonState extends ProfileEdit {
  const SetLessonState(this.id, this.state);
  final String id;
  final LessonState state;
}

final class SetLessonFlag extends ProfileEdit {
  const SetLessonFlag(this.id, {this.skipped, this.favorite});
  final String id;
  final bool? skipped;
  final bool? favorite;
}

final class SetExerciseState extends ProfileEdit {
  const SetExerciseState(this.id, this.state);
  final String id;
  final ExerciseState state;
}

final class SetPreference extends ProfileEdit {
  const SetPreference(this.key, this.value);
  final String key;
  final String value;
}

final class SetReaderOffset extends ProfileEdit {
  const SetReaderOffset(this.id, this.offset);
  final String id;
  final double offset;
}

abstract interface class ProfileStore {
  Future<ProfileSnapshot> load();
  Future<ProfileSnapshot> edit(ProfileEdit edit);
  Future<void> backup(String destination);
  Future<ProfileSnapshot> importFrom(String source);
}
