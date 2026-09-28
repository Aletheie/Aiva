/// Transient answers survive tabs, search, and visits to prerequisite lessons.
/// Completion is persisted separately in the profile.
final class ExerciseDraft {
  int? choice;
  bool answerChecked = false;
  int revealedHints = 0;
  final Set<int> checkedSteps = {};
}

final class LessonSession {
  int tab = 0;
  int exercise = 0;
}
