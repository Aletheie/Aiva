import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart' as fw show RadioGroup;
import '../../app/app_controller.dart';
import '../../app/study_session.dart';
import '../../domain/course.dart';
import '../../domain/profile.dart';
import '../design.dart';
import 'code_block.dart';
import 'dialogs.dart';
import 'exercise_story.dart';
import 'lesson_markdown.dart';
import 'validation_result.dart';

class ExerciseCard extends StatefulWidget {
  const ExerciseCard({
    super.key,
    required this.controller,
    required this.exercise,
    this.showHeading = true,
  });
  final AppController controller;
  final Exercise exercise;
  final bool showHeading;
  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  AppController get app => widget.controller;
  Exercise get exercise => widget.exercise;
  ExerciseDraft get draft => app.draftFor(exercise);

  Future<void> _check() async {
    if (!app.executionConsent) {
      final consent = await confirmAction(
        context,
        title: 'Povolit spuštění Java kódu?',
        message:
            'Aiva přeloží a spustí uložené soubory tohoto cvičení. '
            'Program má stejný přístup k souborům a síti jako ty; neběží v odděleném prostředí (sandbox). '
            'Spouštěj proto jen vlastní kód nebo kód, kterému důvěřuješ.\n\n'
            'Souhlas můžeš kdykoli zrušit v Nastavení.',
        action: 'Povolit a zkontrolovat',
      );
      if (!consent || !mounted) return;
      if (!await app.edit(const SetPreference('executionConsent', 'yes'))) {
        return;
      }
    }
    await app.runExercise(exercise);
  }

  Future<void> _solution() => showDialog<void>(
    context: context,
    builder: (context) => ContentDialog(
      constraints: const BoxConstraints(maxWidth: 820, maxHeight: 780),
      title: Text('Řešení · ${exercise.title}'),
      content: SingleChildScrollView(
        child: LessonMarkdown(text: exercise.solution),
      ),
      actions: [
        Button(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Zavřít řešení'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final completed =
        app.profile.exercise(exercise.id) == ExerciseState.completed;
    final validation = exercise.validation;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showHeading) ...[
          Text(
            '${exercise.kind} · ${exercise.difficulty.label}',
            style: FluentTheme.of(
              context,
            ).typography.caption?.copyWith(color: Design.muted(context)),
          ),
          const SizedBox(height: 8),
          Semantics(
            header: true,
            child: Text(
              exercise.title,
              style: FluentTheme.of(context).typography.subtitle,
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (exercise.story case final story?) ...[
          ExerciseStoryPanel(
            key: ValueKey('story-${exercise.id}'),
            story: story,
          ),
          const SizedBox(height: 16),
        ],
        LessonMarkdown(text: exercise.prompt),
        if (completed)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: InfoBar(
              title: Text('Cvičení je dokončené.'),
              severity: InfoBarSeverity.success,
            ),
          ),
        if (validation is ChoiceValidation) _choice(validation),
        if (exercise.starter != null) _workspace(validation),
        if (validation is ManualValidation) _manual(validation, completed),
        if (app.reports[exercise.id] case final report?) ...[
          const SizedBox(height: 20),
          ValidationResult(report: report),
        ],
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        for (var i = 0; i < draft.revealedHints; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Expander(
              initiallyExpanded: true,
              header: Text('Nápověda ${i + 1}'),
              content: LessonMarkdown(text: exercise.hints[i]),
            ),
          ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (draft.revealedHints < exercise.hints.length)
              Button(
                onPressed: () => setState(() => draft.revealedHints++),
                child: Text(
                  'Nápověda ${draft.revealedHints + 1} / ${exercise.hints.length}',
                ),
              ),
            HyperlinkButton(
              onPressed: _solution,
              child: const Text('Zobrazit řešení'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _choice(ChoiceValidation validation) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      fw.RadioGroup<int>(
        groupValue: draft.choice,
        onChanged: (value) => setState(() {
          draft.choice = value;
          draft.answerChecked = false;
        }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < validation.options.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RadioButton<int>(
                  value: i,
                  content: Text(validation.options[i]),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Align(
        alignment: Alignment.centerLeft,
        child: FilledButton(
          onPressed: draft.choice == null
              ? null
              : () async {
                  setState(() => draft.answerChecked = true);
                  if (draft.choice == validation.correctIndex) {
                    await app.completeExercise(exercise, true);
                  } else if (app.profile.exercise(exercise.id) !=
                      ExerciseState.completed) {
                    await app.completeExercise(exercise, false);
                  }
                },
          child: const Text('Ověřit odpověď'),
        ),
      ),
      if (draft.choice == null)
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('Nejdřív vyber jednu odpověď.'),
        ),
      if (draft.answerChecked) ...[
        const SizedBox(height: 16),
        Semantics(
          liveRegion: true,
          child: InfoBar(
            title: Text(
              draft.choice == validation.correctIndex
                  ? 'Správně'
                  : 'Zkus to ještě jednou',
            ),
            content: LessonMarkdown(
              text: draft.choice == validation.correctIndex
                  ? validation.explanation
                  : 'Tato odpověď nesedí. Vrať se k příkladu nebo otevři nápovědu.',
            ),
            isLong: true,
            severity: draft.choice == validation.correctIndex
                ? InfoBarSeverity.success
                : InfoBarSeverity.warning,
          ),
        ),
      ],
    ],
  );

  Widget _manual(ManualValidation validation, bool completed) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 16),
      Semantics(
        header: true,
        child: Text(
          'Zkontroluj svůj výsledek',
          style: FluentTheme.of(context).typography.bodyStrong,
        ),
      ),
      const SizedBox(height: 8),
      for (var i = 0; i < validation.checklist.length; i++)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Checkbox(
            key: ValueKey('checklist-${exercise.id}-$i'),
            checked: draft.checkedSteps.contains(i),
            onChanged: completed
                ? null
                : (checked) => setState(() {
                    checked == true
                        ? draft.checkedSteps.add(i)
                        : draft.checkedSteps.remove(i);
                  }),
            content: Flexible(child: Text(validation.checklist[i])),
          ),
        ),
      const SizedBox(height: 12),
      Align(
        alignment: Alignment.centerLeft,
        child: FilledButton(
          onPressed: completed
              ? () async {
                  draft.checkedSteps.clear();
                  await app.completeExercise(exercise, false);
                }
              : draft.checkedSteps.length == validation.checklist.length
              ? () => app.completeExercise(exercise, true)
              : null,
          child: Text(completed ? 'Procvičit znovu' : 'Dokončit cvičení'),
        ),
      ),
      if (!completed)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Potvrzeno ${draft.checkedSteps.length} z ${validation.checklist.length} bodů. '
            'Po ověření všech bodů můžeš cvičení dokončit.',
            style: TextStyle(color: Design.muted(context)),
          ),
        ),
    ],
  );

  Widget _workspace(Validation validation) {
    final running = app.runningExercise == exercise.id;
    final preparing = app.preparing.contains(exercise.id);
    final output = validation is OutputValidation;
    final hasJdk = app.selectedJdk != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (validation is OutputValidation) ...[
          const SizedBox(height: 12),
          Expander(
            initiallyExpanded: true,
            header: const Text('Ukázka vstupu a výstupu'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (validation.cases.first.input.isEmpty)
                  const Text('Program v tomto příkladu nic nečte ze vstupu.')
                else
                  CodeBlock(
                    code: validation.cases.first.input,
                    language: 'text',
                    caption: 'Vstup (Input)',
                  ),
                CodeBlock(
                  code: validation.cases.first.expected,
                  language: 'text',
                  caption: 'Očekávaný výstup (Expected output)',
                ),
                if (validation.cases.length > 1)
                  Text(
                    'Kontrola vyzkouší celkem ${validation.cases.length} vstupů. Napiš obecné řešení pro celé zadání.',
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        Text(
          output
              ? 'Otevři soubory cvičení, uprav kód v editoru a ulož ho. Pak spusť kontrolu.'
              : 'Otevři soubory projektu a pracuj v editoru. Hotový výsledek ověř podle seznamu níže.',
          style: TextStyle(color: Design.muted(context), height: 1.5),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            Button(
              onPressed: preparing || running
                  ? null
                  : () => app.prepareExercise(
                      exercise,
                      launchEditor: app.selectedEditor != null,
                    ),
              child: Text(
                preparing
                    ? 'Připravuji…'
                    : app.selectedEditor == null
                    ? 'Otevřít složku cvičení'
                    : 'Otevřít v ${app.selectedEditor!.name}',
              ),
            ),
            if (output)
              FilledButton(
                onPressed: !hasJdk || app.isRunning || preparing
                    ? null
                    : _check,
                child: Text(running ? 'Kontroluji…' : 'Zkontrolovat řešení'),
              ),
          ],
        ),
        if (output && !hasJdk) ...[
          const SizedBox(height: 12),
          InfoBar(
            title: Text(
              app.detecting
                  ? 'Hledám instalaci Javy…'
                  : 'Pro kontrolu potřebuješ JDK 21 nebo novější.',
            ),
            action: Button(
              onPressed: () => app.go(const PageLocation(AppPage.settings)),
              child: const Text('Nastavit Javu'),
            ),
            isLong: true,
          ),
        ],
        if (app.workspacePaths[exercise.id] case final workspace?) ...[
          const SizedBox(height: 12),
          Expander(
            header: const Text('Soubory cvičení'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SelectableText(
                  workspace,
                  style: TextStyle(fontFamily: Design.mono, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Button(
                    onPressed: () =>
                        app.prepareExercise(exercise, launchEditor: false),
                    child: const Text('Otevřít složku'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
