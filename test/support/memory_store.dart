import 'package:aiva/domain/course.dart';
import 'package:aiva/domain/profile.dart';

final class MemoryStore implements ProfileStore {
  ProfileSnapshot profile = const ProfileSnapshot(
    settings: {'reducedMotion': 'yes'},
  );
  @override
  Future<ProfileSnapshot> load() async => profile;
  @override
  Future<ProfileSnapshot> edit(ProfileEdit edit) async {
    final lessons = {...profile.lessons};
    final exercises = {...profile.exercises};
    final settings = {...profile.settings};
    final recent = [...profile.recent];
    final offsets = {...profile.readerOffsets};
    switch (edit) {
      case VisitLesson(:final id):
        final old = profile.lesson(id);
        lessons[id] = LessonProgress(
          state: old.state == LessonState.notStarted
              ? LessonState.inProgress
              : old.state,
          favorite: old.favorite,
          skipped: old.skipped,
        );
        recent.remove(id);
        recent.insert(0, id);
        settings['lastLesson'] = id;
      case SetLessonState(:final id, :final state):
        final old = profile.lesson(id);
        lessons[id] = LessonProgress(
          state: state,
          favorite: old.favorite,
          skipped: old.skipped,
        );
      case SetLessonFlag(:final id, :final favorite, :final skipped):
        final old = profile.lesson(id);
        lessons[id] = LessonProgress(
          state: old.state,
          favorite: favorite ?? old.favorite,
          skipped: skipped ?? old.skipped,
        );
      case SetExerciseState(:final id, :final state):
        exercises[id] = state;
      case SetPreference(:final key, :final value):
        settings[key] = value;
      case SetReaderOffset(:final id, :final offset):
        offsets[id] = offset;
    }
    return profile = ProfileSnapshot(
      lessons: lessons,
      exercises: exercises,
      settings: settings,
      recent: recent,
      readerOffsets: offsets,
    );
  }

  @override
  Future<void> backup(String destination) async =>
      throw UnsupportedError('Use SQLite tests for backup.');
  @override
  Future<ProfileSnapshot> importFrom(String source) async =>
      throw UnsupportedError('Use SQLite tests for import.');
}
