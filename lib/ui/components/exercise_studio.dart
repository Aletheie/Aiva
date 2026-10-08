import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart' as p;
import 'package:re_editor/re_editor.dart';
import '../../app/app_controller.dart';
import '../../domain/course.dart';
import '../../domain/profile.dart';
import '../../services/editor_workspace.dart';
import '../../services/java_language_service.dart';
import '../design.dart';
import 'code_block.dart';
import 'dialogs.dart';
import 'exercise_card.dart';
import 'java_code_editor.dart';
import 'validation_result.dart';

/// A focused exercise desk: instructions, source code and local feedback.
class ExerciseStudio extends StatefulWidget {
  const ExerciseStudio({
    super.key,
    required this.controller,
    required this.exercise,
    required this.courseTitle,
    this.exerciseIndex = 0,
    this.exercises = const [],
    this.onSelectExercise,
    this.onReading,
  });
  final AppController controller;
  final Exercise exercise;
  final String courseTitle;
  final int exerciseIndex;
  final List<Exercise> exercises;
  final ValueChanged<int>? onSelectExercise;
  final VoidCallback? onReading;
  @override
  State<ExerciseStudio> createState() => _ExerciseStudioState();
}

class _ExerciseStudioState extends State<ExerciseStudio> {
  final _language = JavaLanguageService();
  final _code = <String, CodeLineEditingController>{};
  final _input = TextEditingController();
  EditorWorkspace? _workspace;
  String? _path;
  String? _error;
  String? _saveError;
  Timer? _autosave;
  bool _saving = false;
  bool _reloading = false;
  int _compactTab = 0;
  int _outputTab = 0;
  double _instructionsWidth = 370;
  double _outputHeight = 225;
  AppController get app => widget.controller;
  Exercise get exercise => widget.exercise;
  bool get _running => app.runningExercise == exercise.id;
  bool get _dirty => _workspace?.hasUnsavedChanges ?? false;
  CodeLineEditingController? get _active => _code[_path];

  @override
  void initState() {
    super.initState();
    if (exercise.validation case final OutputValidation validation) {
      _input.text = validation.cases.first.input;
    }
    _language.addListener(_languageChanged);
    unawaited(_load());
  }

  void _languageChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _load() async {
    try {
      final workspace = await app.editorWorkspace(exercise);
      await workspace.refresh();
      if (!mounted) return;
      for (final file in workspace.files) {
        final editing = CodeLineEditingController.fromText(file.text);
        _code[file.relativePath] = editing;
        editing.addListener(() {
          if (file.text == editing.text) return;
          workspace.edit(file.relativePath, editing.text);
          if (file.relativePath.endsWith('.java')) {
            _language.changeDocument(
              p.join(workspace.path, file.relativePath),
              editing.text,
            );
          }
          _autosave?.cancel();
          _autosave = Timer(
            const Duration(milliseconds: 700),
            () => unawaited(_save()),
          );
          if (mounted) setState(() {});
        });
      }
      String? first;
      if (exercise.validation case final OutputValidation validation) {
        final main =
            'src/main/java/${validation.mainClass.replaceAll('.', '/')}.java';
        if (_code.containsKey(main)) first = main;
      }
      first ??= workspace.files
          .where((file) => file.relativePath.endsWith('.java'))
          .firstOrNull
          ?.relativePath;
      first ??= workspace.files.firstOrNull?.relativePath;
      setState(() {
        _workspace = workspace;
        _path = first;
        _error = null;
      });
      await _startLanguage();
    } on Object catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  @override
  void didUpdateWidget(ExerciseStudio oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_workspace != null &&
        app.selectedJdk != null &&
        _language.state == JavaLanguageState.stopped) {
      unawaited(Future<void>.microtask(_startLanguage));
    }
  }

  Future<void> _startLanguage() async {
    final workspace = _workspace;
    if (workspace == null) return;
    final jdk = app.selectedJdk;
    if (jdk != null &&
        workspace.files.any((file) => file.relativePath.endsWith('.java'))) {
      await _language.start(
        jdk: jdk,
        availableRuntimes: app.tools.jdks,
        javaRelease: exercise.validation is OutputValidation
            ? (exercise.validation as OutputValidation).javaRelease
            : 21,
        workspacePath: workspace.path,
        serverPath: app.profile.javaLanguageServerPath,
        managedRoot: p.join(app.paths.profile, 'java-language-server'),
      );
      if (!mounted) return;
      for (final file in workspace.files.where(
        (file) => file.relativePath.endsWith('.java'),
      )) {
        _language.openDocument(
          p.join(workspace.path, file.relativePath),
          file.text,
        );
      }
    }
  }

  Future<bool> _save() async {
    final workspace = _workspace;
    if (workspace == null) return false;
    _autosave?.cancel();
    if (mounted) setState(() => _saving = true);
    try {
      await workspace.saveAll();
      for (final file in workspace.files.where(
        (file) => file.relativePath.endsWith('.java'),
      )) {
        _language.saveDocument(p.join(workspace.path, file.relativePath));
      }
      if (mounted) setState(() => _saveError = null);
      return true;
    } on Object catch (error) {
      if (mounted) setState(() => _saveError = error.toString());
      return false;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _reloadFile() async {
    final workspace = _workspace;
    final path = _path;
    if (workspace == null || path == null) return;
    if (workspace.file(path).isDirty) {
      final confirmed = await confirmAction(
        context,
        title: 'Načíst soubor z disku?',
        message:
            'Neuložené změny v $path se nahradí verzí uloženou na disku. Před pokračováním si můžeš svůj kód zkopírovat.',
        action: 'Načíst z disku',
      );
      if (!confirmed || !mounted) return;
    }
    _autosave?.cancel();
    setState(() => _reloading = true);
    try {
      await workspace.reload(path, discardChanges: true);
      if (!mounted) return;
      _code[path]!.text = workspace.file(path).text;
      _code[path]!.clearHistory();
      if (path.endsWith('.java')) {
        _language.changeDocument(
          p.join(workspace.path, path),
          workspace.file(path).text,
        );
      }
      setState(() => _saveError = null);
    } on Object catch (error) {
      if (mounted) setState(() => _saveError = error.toString());
    } finally {
      if (mounted) setState(() => _reloading = false);
    }
  }

  void _showDiagnostic(String path, JavaDiagnostic diagnostic) {
    final relative = p
        .relative(path, from: _workspace!.path)
        .split(p.separator)
        .join('/');
    final editing = _code[relative];
    if (editing == null) return;
    setState(() => _path = relative);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final line = diagnostic.start.line.clamp(0, editing.lineCount - 1);
      editing.selection = CodeLineSelection.collapsed(
        index: line,
        offset: diagnostic.start.character.clamp(
          0,
          editing.codeLines[line].text.length,
        ),
      );
      editing.makeCursorCenterIfInvisible();
    });
  }

  Future<void> _run({required bool check}) async {
    if (!await _save() || !mounted) return;
    if (!app.executionConsent) {
      final accepted = await confirmAction(
        context,
        title: 'Povolit spuštění Java kódu?',
        message:
            'Aiva přeloží a spustí tvoje soubory na tomto počítači. '
            'Program má stejný přístup k souborům a síti jako ty. Spouštěj pouze kód, kterému důvěřuješ. '
            'Souhlas můžeš zrušit v Nastavení.',
        action: 'Povolit a spustit',
      );
      if (!accepted || !mounted) return;
      if (!await app.edit(const SetPreference('executionConsent', 'yes')) ||
          !mounted) {
        return;
      }
    }
    setState(() => _outputTab = check ? 1 : 0);
    if (check) {
      await app.runExercise(exercise);
    } else {
      await app.runProgram(exercise, _input.text);
    }
  }

  @override
  void dispose() {
    _autosave?.cancel();
    final workspace = _workspace;
    if (workspace != null && workspace.hasUnsavedChanges) {
      unawaited(
        workspace.saveAll().catchError((Object error) {
          app.showNotice(
            'Rozpracovaný kód zůstává v paměti. Uložení: $error',
            NoticeKind.error,
          );
        }),
      );
    }
    _language.removeListener(_languageChanged);
    _language.dispose();
    _input.dispose();
    for (final controller in _code.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _settings() => app.go(const PageLocation(AppPage.settings));

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
      final compact = constraints.maxWidth < 900 * scale;
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(context, compact),
            const SizedBox(height: 14),
            if (compact) ...[
              Row(
                children: [
                  ToggleButton(
                    checked: _compactTab == 0,
                    onChanged: (_) => setState(() => _compactTab = 0),
                    child: const Text('Zadání'),
                  ),
                  const SizedBox(width: 8),
                  ToggleButton(
                    checked: _compactTab == 1,
                    onChanged: (_) => setState(() => _compactTab = 1),
                    child: const Text('Editor a výstup'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            Expanded(
              child: compact
                  ? IndexedStack(
                      index: _compactTab,
                      children: [
                        _instructions(context),
                        _editorAndOutput(context),
                      ],
                    )
                  : LayoutBuilder(
                      builder: (context, area) {
                        final width = _instructionsWidth.clamp(
                          280.0,
                          area.maxWidth * .46,
                        );
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: width,
                              child: _instructions(context),
                            ),
                            _divider(
                              vertical: true,
                              onDrag: (delta) => setState(
                                () => _instructionsWidth = (width + delta)
                                    .clamp(280.0, area.maxWidth * .46),
                              ),
                            ),
                            Expanded(child: _editorAndOutput(context)),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    },
  );

  Widget _header(BuildContext context, bool compact) {
    final done = app.profile.exercise(exercise.id) == ExerciseState.completed;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (widget.onReading != null) ...[
              Tooltip(
                message: 'Zpět k výkladu',
                child: IconButton(
                  icon: const Icon(FluentIcons.back, size: 16),
                  onPressed: widget.onReading,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                widget.courseTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Design.muted(context)),
              ),
            ),
            if (done) ...[
              Icon(
                FluentIcons.completed_solid,
                size: 16,
                color: Design.accentFor(context),
              ),
              const SizedBox(width: 6),
              const Text('Hotovo'),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  exercise.title,
                  maxLines: compact ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: FluentTheme.of(context).typography.subtitle,
                ),
              ),
            ),
            if (!compact && widget.exercises.length > 1) ...[
              const SizedBox(width: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: _selector(),
              ),
            ],
            if (widget.exercises.length > 1) ...[
              const SizedBox(width: 8),
              Tooltip(
                message: 'Předchozí cvičení',
                child: IconButton(
                  icon: const Icon(FluentIcons.chevron_left, size: 14),
                  onPressed: widget.exerciseIndex > 0
                      ? () => widget.onSelectExercise?.call(
                          widget.exerciseIndex - 1,
                        )
                      : null,
                ),
              ),
              Tooltip(
                message: 'Další cvičení',
                child: IconButton(
                  icon: const Icon(FluentIcons.chevron_right, size: 14),
                  onPressed: widget.exerciseIndex + 1 < widget.exercises.length
                      ? () => widget.onSelectExercise?.call(
                          widget.exerciseIndex + 1,
                        )
                      : null,
                ),
              ),
            ],
          ],
        ),
        if (compact && widget.exercises.length > 1) ...[
          const SizedBox(height: 8),
          _selector(),
        ],
      ],
    );
  }

  Widget _selector() => ComboBox<int>(
    key: const ValueKey('exercise-selector'),
    isExpanded: true,
    value: widget.exerciseIndex,
    items: [
      for (var i = 0; i < widget.exercises.length; i++)
        ComboBoxItem(
          value: i,
          child: Text(
            '${i + 1} / ${widget.exercises.length} · ${widget.exercises[i].title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
    ],
    onChanged: (value) {
      if (value != null) widget.onSelectExercise?.call(value);
    },
  );

  Widget _panel({required Widget child}) => Container(
    decoration: BoxDecoration(
      color: Design.surface(context),
      border: Border.all(color: Design.border(context)),
      borderRadius: BorderRadius.circular(Design.radius),
    ),
    clipBehavior: Clip.antiAlias,
    child: child,
  );

  Widget _bar({required Widget child}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: Design.ink(context).withValues(alpha: .035),
      border: Border(bottom: BorderSide(color: Design.border(context))),
    ),
    child: child,
  );

  Widget _instructions(BuildContext context) => _panel(
    child: Column(
      children: [
        _bar(
          child: Row(
            children: [
              const Icon(FluentIcons.reading_mode, size: 16),
              const SizedBox(width: 9),
              Text(
                'Zadání',
                style: FluentTheme.of(context).typography.bodyStrong,
              ),
              const Spacer(),
              Text(
                exercise.difficulty.label,
                style: TextStyle(fontSize: 12, color: Design.muted(context)),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ExerciseCard(
                  key: ValueKey('instructions-${exercise.id}'),
                  controller: app,
                  exercise: exercise,
                  showHeading: false,
                  embedded: true,
                ),
                if (exercise.validation
                    case final OutputValidation validation) ...[
                  const SizedBox(height: 24),
                  Expander(
                    header: const Text('Ukázka vstupu a výstupu'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (validation.cases.first.input.isNotEmpty)
                          CodeBlock(
                            code: validation.cases.first.input,
                            language: 'text',
                            caption: 'Vstup',
                          ),
                        CodeBlock(
                          code: validation.cases.first.expected,
                          language: 'text',
                          caption: 'Očekávaný výstup',
                        ),
                        Text(
                          'Kontrola ověří ${validation.cases.length} ${validation.cases.length == 1 ? 'příklad' : 'příkladů'} ze zadání.',
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _editorAndOutput(BuildContext context) => LayoutBuilder(
    builder: (context, area) {
      final minimum = 510 * (MediaQuery.textScalerOf(context).scale(14) / 14);
      if (area.maxHeight < minimum) {
        return SingleChildScrollView(
          child: SizedBox(
            height: minimum,
            child: _editorAndOutputSized(context, minimum),
          ),
        );
      }
      return _editorAndOutputSized(context, area.maxHeight);
    },
  );

  Widget _editorAndOutputSized(BuildContext context, double height) {
    final outputHeight = _outputHeight.clamp(
      110.0,
      (height * .48).clamp(110.0, 500.0),
    );
    return Column(
      children: [
        Expanded(child: _panel(child: _editor(context))),
        _divider(
          vertical: false,
          onDrag: (delta) => setState(
            () => _outputHeight = (outputHeight - delta).clamp(
              110.0,
              (height * .48).clamp(110.0, 500.0),
            ),
          ),
        ),
        SizedBox(
          height: outputHeight,
          child: _panel(child: _output(context)),
        ),
      ],
    );
  }

  Widget _editor(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Soubory se nepodařilo otevřít.'),
              const SizedBox(height: 12),
              SelectableText(_error!),
              const SizedBox(height: 16),
              Button(
                onPressed: () {
                  setState(() => _error = null);
                  unawaited(_load());
                },
                child: const Text('Zkusit znovu'),
              ),
            ],
          ),
        ),
      );
    }
    if (_workspace == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 160, child: ProgressBar()),
            SizedBox(height: 12),
            Text('Připravuji soubory cvičení…'),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _bar(
          child: Row(
            children: [
              Icon(
                FluentIcons.code,
                size: 16,
                color: Design.accentFor(context),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ComboBox<String>(
                  value: _path,
                  isExpanded: true,
                  items: [
                    for (final file in _workspace!.files)
                      ComboBoxItem(
                        value: file.relativePath,
                        child: Text(
                          '${file.relativePath}${file.isDirty ? ' •' : ''}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: Design.mono,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                  onChanged: (value) => setState(() => _path = value),
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: 'Načíst aktuální soubor z disku',
                child: IconButton(
                  icon: const Icon(FluentIcons.refresh, size: 16),
                  onPressed: _running || _saving || _reloading
                      ? null
                      : _reloadFile,
                ),
              ),
              Tooltip(
                message: 'Uložit soubory (Ctrl / ⌘ S)',
                child: IconButton(
                  icon: const Icon(FluentIcons.save, size: 16),
                  onPressed: _saving ? null : _save,
                ),
              ),
            ],
          ),
        ),
        if (_saveError != null)
          InfoBar(
            title: const Text('Změny zatím nejsou uložené.'),
            content: Text(_saveError!),
            severity: InfoBarSeverity.error,
            isLong: true,
            action: Button(
              onPressed: _save,
              child: const Text('Zkusit uložit'),
            ),
          ),
        Expanded(
          child: _active == null
              ? const Center(
                  child: Text('Tento projekt neobsahuje soubory k úpravě.'),
                )
              : JavaCodeEditor(
                  controller: _active!,
                  path: p.join(_workspace!.path, _path!),
                  languageService: _language,
                  onSave: () => unawaited(_save()),
                  readOnly: _running || _reloading,
                ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Design.border(context))),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _dirty ? FluentIcons.edit : FluentIcons.check_mark,
                    size: 12,
                    color: Design.muted(context),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _saving
                        ? 'Ukládám…'
                        : _dirty
                        ? 'Neuložené změny'
                        : 'Uloženo',
                    style: TextStyle(
                      fontSize: 11,
                      color: Design.muted(context),
                    ),
                  ),
                ],
              ),
              Tooltip(
                message:
                    '${_language.statusMessage}\nCtrl + mezerník: doplnění · F1: dokumentace · Esc: opustit editor',
                child: HyperlinkButton(
                  onPressed: _settings,
                  child: Text(
                    app.selectedJdk == null
                        ? 'Nastavit Javu a IntelliSense'
                        : switch (_language.state) {
                            JavaLanguageState.ready => 'Java IntelliSense',
                            JavaLanguageState.starting =>
                              'Připravuji IntelliSense…',
                            _ => 'Nastavit Java IntelliSense',
                          },
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_running)
                Button(
                  onPressed: app.cancelCheck,
                  child: const Text('Zastavit'),
                ),
              if (exercise.validation is OutputValidation) ...[
                Button(
                  key: const ValueKey('run-embedded-code'),
                  onPressed: app.isRunning || app.selectedJdk == null
                      ? null
                      : () => _run(check: false),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FluentIcons.play, size: 12),
                      SizedBox(width: 7),
                      Text('Spustit kód'),
                    ],
                  ),
                ),
                FilledButton(
                  key: const ValueKey('check-embedded-code'),
                  onPressed: app.isRunning || app.selectedJdk == null
                      ? null
                      : () => _run(check: true),
                  child: const Text('Zkontrolovat řešení'),
                ),
              ] else
                Text(
                  'Výsledek ověř podle zadání vlevo.',
                  style: TextStyle(color: Design.muted(context)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _output(BuildContext context) {
    final diagnostics = _language.diagnostics.entries
        .expand(
          (entry) => entry.value.map(
            (diagnostic) => (path: entry.key, diagnostic: diagnostic),
          ),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _bar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final (index, title) in [
                  (0, 'Výstup'),
                  (1, 'Testy'),
                  (2, 'Vstup'),
                  (
                    3,
                    'Problémy${diagnostics.isEmpty ? '' : ' (${diagnostics.length})'}',
                  ),
                ]) ...[
                  ToggleButton(
                    checked: _outputTab == index,
                    onChanged: (_) => setState(() => _outputTab = index),
                    child: Text(title),
                  ),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ),
        Expanded(
          child: _running && (_outputTab == 0 || _outputTab == 1)
              ? Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProgressBar(),
                      const SizedBox(height: 12),
                      Text(app.runStage),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: switch (_outputTab) {
                    1 =>
                      app.reports[exercise.id] == null
                          ? _quiet(
                              'Připraveno ke kontrole',
                              'Zkontrolovat řešení porovná tvůj program se všemi testy zadání.',
                            )
                          : ValidationResult(report: app.reports[exercise.id]!),
                    2 => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Vstup pro tvůj program'),
                        const SizedBox(height: 8),
                        TextBox(
                          controller: _input,
                          minLines: 2,
                          maxLines: 5,
                          placeholder:
                              'Hodnoty pro Scanner, každá na samostatný řádek…',
                          style: TextStyle(
                            fontFamily: Design.mono,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    3 =>
                      diagnostics.isEmpty
                          ? _quiet('Diagnostika Javy', _language.statusMessage)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (final diagnostic in diagnostics)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: HyperlinkButton(
                                      onPressed: () => _showDiagnostic(
                                        diagnostic.path,
                                        diagnostic.diagnostic,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${p.basename(diagnostic.path)}:${diagnostic.diagnostic.start.line + 1} · ${diagnostic.diagnostic.message}',
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                    _ => _programOutput(context),
                  },
                ),
        ),
      ],
    );
  }

  Widget _programOutput(BuildContext context) {
    final report = app.programRuns[exercise.id];
    if (report == null) {
      return _quiet(
        'Tady uvidíš výstup programu',
        'Uprav kód a spusť ho. Vlastní hodnoty můžeš zadat na záložce Vstup.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          report.message,
          style: TextStyle(color: Design.muted(context), fontSize: 12),
        ),
        const SizedBox(height: 10),
        SelectableText(
          [
                report.stdout,
                report.stderr,
                report.diagnostics,
              ].where((part) => part.isNotEmpty).join('\n').trim().isEmpty
              ? 'Program skončil bez výstupu.'
              : [
                  report.stdout,
                  report.stderr,
                  report.diagnostics,
                ].where((part) => part.isNotEmpty).join('\n'),
          style: TextStyle(fontFamily: Design.mono, fontSize: 13, height: 1.6),
        ),
      ],
    );
  }

  Widget _quiet(String title, String message) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: FluentTheme.of(context).typography.bodyStrong),
      const SizedBox(height: 6),
      Text(
        message,
        style: TextStyle(
          color: Design.muted(context),
          fontSize: 12,
          height: 1.5,
        ),
      ),
    ],
  );

  Widget _divider({
    required bool vertical,
    required ValueChanged<double> onDrag,
  }) => MouseRegion(
    cursor: vertical
        ? SystemMouseCursors.resizeLeftRight
        : SystemMouseCursors.resizeUpDown,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: vertical
          ? (details) => onDrag(details.delta.dx)
          : null,
      onVerticalDragUpdate: vertical
          ? null
          : (details) => onDrag(details.delta.dy),
      child: SizedBox(
        width: vertical ? 12 : double.infinity,
        height: vertical ? double.infinity : 12,
        child: Center(
          child: Container(
            width: vertical ? 2 : 28,
            height: vertical ? 28 : 2,
            decoration: BoxDecoration(
              color: Design.border(context),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ),
    ),
  );
}
