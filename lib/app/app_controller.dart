import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import '../content/content_source.dart';
import '../content/course_search.dart';
import '../domain/course.dart';
import '../domain/profile.dart';
import '../platform/app_paths.dart';
import '../platform/external_links.dart';
import '../platform/process_runner.dart';
import '../services/exercise_runner.dart';
import '../services/tool_discovery.dart';
import '../services/workspace_service.dart';
import 'study_session.dart';

enum AppPage {
  home,
  library,
  lesson,
  projects,
  project,
  progress,
  settings,
  search,
  favorites,
}

enum NoticeKind { info, success, error }

final class AppNotice {
  const AppNotice(this.message, this.kind);
  final String message;
  final NoticeKind kind;
}

final class PageLocation {
  const PageLocation(this.page, {this.lessonId, this.projectId, this.group});
  final AppPage page;
  final String? lessonId;
  final String? projectId;
  final String? group;
}

final class AppController extends ChangeNotifier {
  AppController({
    required this.course,
    required this.source,
    required this.store,
    required this.paths,
    required this.profile,
    this.discovery = const ToolDiscovery(),
    this.runner = const ExerciseRunner(),
  }) : workspaces = WorkspaceService(source);
  final Course course;
  late final CourseSearch courseSearch = CourseSearch(course);
  final ContentSource source;
  final ProfileStore store;
  final AppPaths paths;
  final ToolDiscovery discovery;
  final ExerciseRunner runner;
  final WorkspaceService workspaces;
  ProfileSnapshot profile;
  PageLocation location = const PageLocation(AppPage.home);
  final List<({PageLocation location, int? tab, int? exercise})> _history = [];
  String query = '';
  AppNotice? notice;
  ToolReport tools = const ToolReport();
  bool detecting = false;
  bool disposed = false;
  final Set<String> preparing = {};
  String? runningExercise;
  String runStage = '';
  CancellationToken? _cancellation;
  final Map<String, ValidationReport> reports = {};
  final Map<String, String> workspacePaths = {};
  final Map<String, ExerciseDraft> exerciseDrafts = {};
  final Map<String, LessonSession> lessonSessions = {};

  ExerciseDraft draftFor(Exercise exercise) =>
      exerciseDrafts.putIfAbsent(exercise.id, () {
        final draft = ExerciseDraft();
        if (exercise.validation case final ManualValidation validation) {
          if (profile.exercise(exercise.id) == ExerciseState.completed) {
            draft.checkedSteps.addAll(
              List.generate(validation.checklist.length, (index) => index),
            );
          }
        }
        return draft;
      });

  LessonSession sessionFor(Lesson lesson) =>
      lessonSessions.putIfAbsent(lesson.id, LessonSession.new);

  Future<void> openReference(String id) async {
    final lesson = course.lessonsById[id];
    if (lesson == null) return;
    await openLesson(lesson);
  }

  void _notify() {
    if (!disposed) notifyListeners();
  }

  bool get canGoBack => _history.isNotEmpty;
  bool get isRunning => runningExercise != null;
  String get workspaceRoot => profile.setting('workspace', paths.workspace);
  bool get acrylic => profile.setting('acrylic', 'yes') == 'yes';
  bool get reducedMotion => profile.setting('reducedMotion', 'no') == 'yes';
  double get textScale =>
      ((double.tryParse(profile.setting('uiScale', '100')) ?? 100) / 100)
          .clamp(0.9, 1.6)
          .toDouble();
  bool get executionConsent => profile.setting('executionConsent') == 'yes';
  Lesson? get currentLesson => course.lessonsById[location.lessonId];
  CourseProject? get currentProject {
    for (final project in course.projects) {
      if (project.id == location.projectId) return project;
    }
    return null;
  }

  Lesson get resumeLesson {
    final lesson = course.lessonsById[profile.setting('lastLesson')];
    return lesson != null && lesson.isPublished
        ? lesson
        : course.mainPath.first;
  }

  JdkInstallation? get selectedJdk {
    final preference = profile.setting('jdkHome');
    if (preference.isNotEmpty) {
      for (final jdk in tools.jdks) {
        if (jdk.home == preference) return jdk;
      }
      return null; // Keep a missing explicit selection visible in settings.
    }
    return tools.jdks.isEmpty ? null : tools.jdks.first;
  }

  EditorInstallation? get selectedEditor {
    final preference = profile.setting('editorPath');
    if (preference.isNotEmpty) {
      for (final editor in tools.editors) {
        if (editor.path == preference) return editor;
      }
      return null;
    }
    return tools.editors.isEmpty ? null : tools.editors.first;
  }

  void showNotice(String message, [NoticeKind kind = NoticeKind.info]) {
    notice = AppNotice(message, kind);
    _notify();
  }

  void dismissNotice() {
    notice = null;
    _notify();
  }

  void _rememberLocation() {
    final session = lessonSessions[location.lessonId];
    _history.add((
      location: location,
      tab: session?.tab,
      exercise: session?.exercise,
    ));
    if (_history.length > 60) _history.removeAt(0);
  }

  void go(PageLocation next, {bool remember = true}) {
    if (remember &&
        (next.page != location.page ||
            next.lessonId != location.lessonId ||
            next.projectId != location.projectId ||
            next.group != location.group)) {
      _rememberLocation();
    }
    location = next;
    _notify();
  }

  void back() {
    if (_history.isEmpty) return;
    final previous = _history.removeLast();
    location = previous.location;
    if (currentLesson case final lesson?) {
      final session = sessionFor(lesson);
      session.tab = previous.tab ?? session.tab;
      session.exercise = previous.exercise ?? session.exercise;
    }
    _notify();
  }

  void openGroup(String? group) =>
      go(PageLocation(AppPage.library, group: group));
  void openProject(CourseProject project) =>
      go(PageLocation(AppPage.project, projectId: project.id));
  Future<void> openLesson(Lesson lesson) async {
    _rememberLocation();
    sessionFor(lesson).tab = 0;
    go(PageLocation(AppPage.lesson, lessonId: lesson.id), remember: false);
    await edit(VisitLesson(lesson.id));
  }

  void search(String value) {
    query = value;
    if (value.trim().isNotEmpty) {
      go(
        const PageLocation(AppPage.search),
        remember: location.page != AppPage.search,
      );
    } else if (location.page == AppPage.search) {
      go(const PageLocation(AppPage.library), remember: false);
    } else {
      _notify();
    }
  }

  List<Lesson> get searchResults => courseSearch.find(query);

  Future<bool> edit(ProfileEdit edit) async {
    try {
      profile = await store.edit(edit);
      _notify();
      return true;
    } on Object catch (error) {
      showNotice('Změnu se nepodařilo uložit: $error', NoticeKind.error);
      return false;
    }
  }

  Future<void> preference(String key, String value) async {
    await edit(SetPreference(key, value));
  }

  Future<void> toggleFavorite(Lesson lesson) async {
    await edit(
      SetLessonFlag(lesson.id, favorite: !profile.lesson(lesson.id).favorite),
    );
  }

  Future<void> toggleSkipped(String id) async {
    await edit(SetLessonFlag(id, skipped: !profile.lesson(id).skipped));
  }

  Future<void> completeLesson(Lesson lesson, bool completed) async {
    if (!lesson.isPublished) return;
    await edit(
      SetLessonState(
        lesson.id,
        completed ? LessonState.completed : LessonState.inProgress,
      ),
    );
  }

  Future<void> completeExercise(Exercise exercise, bool completed) async {
    await edit(
      SetExerciseState(
        exercise.id,
        completed ? ExerciseState.completed : ExerciseState.attempted,
      ),
    );
  }

  Future<void> saveOffset(String id, double offset) async {
    if (profile.readerOffsets[id] == offset) return;
    await edit(SetReaderOffset(id, offset));
  }

  Future<void> detectTools() async {
    if (detecting) return;
    detecting = true;
    _notify();
    try {
      tools = await discovery.discover(
        preferredJdk: profile.setting('jdkHome'),
        preferredEditor: profile.setting('editorPath'),
      );
    } on Object catch (error) {
      showNotice('Hledání nástrojů: $error', NoticeKind.error);
    } finally {
      detecting = false;
      _notify();
    }
  }

  Future<void> chooseJdk(String path) => guard(() async {
    final jdk = await discovery.inspectJdk(path);
    tools = ToolReport(
      jdks: [jdk, ...tools.jdks.where((j) => j.home != jdk.home)],
      editors: tools.editors,
    );
    await preference('jdkHome', jdk.home);
  });
  Future<void> chooseEditor(String path) => guard(() async {
    final editor = await discovery.inspectEditor(path);
    tools = ToolReport(
      jdks: tools.jdks,
      editors: [editor, ...tools.editors.where((e) => e.path != editor.path)],
    );
    await preference('editorPath', editor.path);
  });

  Future<void> prepareExercise(
    Exercise exercise, {
    bool launchEditor = true,
  }) async {
    if (preparing.contains(exercise.id)) return;
    preparing.add(exercise.id);
    _notify();
    try {
      final result = await workspaces.prepare(workspaceRoot, exercise);
      workspacePaths[exercise.id] = result.path;
      if (profile.exercise(exercise.id) == ExerciseState.notStarted) {
        await edit(SetExerciseState(exercise.id, ExerciseState.attempted));
      }
      if (launchEditor) {
        final editor = selectedEditor;
        if (editor == null) {
          go(const PageLocation(AppPage.settings));
          showNotice(
            'Workspace je připravený. Vyber editor nebo nainstaluj IntelliJ IDEA / VS Code.',
          );
          return;
        }
        await openEditor(editor, result.path);
        showNotice(
          'Požadavek na otevření byl předán editoru ${editor.name}.',
          NoticeKind.success,
        );
      } else {
        await revealFolder(result.path);
      }
    } on Object catch (error) {
      showNotice('Workspace: $error', NoticeKind.error);
    } finally {
      preparing.remove(exercise.id);
      _notify();
    }
  }

  Future<void> runExercise(Exercise exercise) async {
    final validation = exercise.validation;
    if (validation is! OutputValidation || isRunning) return;
    if (!executionConsent) {
      showNotice('Před spuštěním Java kódu je potřeba tvůj souhlas.');
      return;
    }
    final jdk = selectedJdk;
    if (jdk == null) {
      go(const PageLocation(AppPage.settings));
      showNotice(
        'Pro kontrolu vyber funkční JDK 21 nebo novější. Samotné čtení kurzu Javu nepotřebuje.',
      );
      return;
    }
    final cancellation = CancellationToken();
    _cancellation = cancellation;
    runningExercise = exercise.id;
    runStage = 'Připravuji kontrolu…';
    reports.remove(exercise.id);
    _notify();
    try {
      if (!await edit(SetExerciseState(exercise.id, ExerciseState.attempted))) {
        return;
      }
      final workspace = await workspaces.prepare(workspaceRoot, exercise);
      workspacePaths[exercise.id] = workspace.path;
      final report = await runner.check(
        workspace: workspace.path,
        jdk: jdk,
        validation: validation,
        cancellation: cancellation,
        onStage: (message) {
          runStage = message;
          _notify();
        },
      );
      reports[exercise.id] = report;
      if (report.passed) {
        await edit(SetExerciseState(exercise.id, ExerciseState.completed));
      }
    } on Object catch (error) {
      reports[exercise.id] = ValidationReport(
        status: CheckStatus.unavailable,
        message: 'Kontrola se nespustila.',
        diagnostics: error.toString(),
      );
    } finally {
      runningExercise = null;
      _cancellation = null;
      runStage = '';
      _notify();
    }
  }

  void cancelCheck() => _cancellation?.cancel();

  Future<void> backup(String target) => guard(() async {
    await store.backup(target);
    showNotice('Konzistentní záloha byla uložena: $target', NoticeKind.success);
  });
  Future<void> importProfile(String source) => guard(() async {
    final backup = p.join(
      paths.profile,
      'before-import-${DateTime.now().microsecondsSinceEpoch}.sqlite',
    );
    await store.backup(backup);
    profile = await store.importFrom(source);
    showNotice(
      'Progres byl sloučen. Původní profil má zálohu: $backup',
      NoticeKind.success,
    );
    await detectTools();
  });
  Future<void> guard(Future<void> Function() action) async {
    try {
      await action();
    } on Object catch (error) {
      showNotice(error.toString(), NoticeKind.error);
    }
  }

  @override
  void dispose() {
    disposed = true;
    _cancellation?.cancel();
    super.dispose();
  }
}
