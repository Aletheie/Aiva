import '../domain/course.dart';
import '../platform/safe_paths.dart';
import 'content_source.dart';
import 'strict_json.dart';

final class CourseLoader {
  const CourseLoader(this.source);
  final ContentSource source;

  Future<Course> load() async {
    final root = JsonFields(
      decodeObject(await source.readText('course.json'), 'course.json'),
      'course.json',
      {'schemaVersion', 'title', 'chapters', 'lessons', 'projects'},
    );
    root.integer('schemaVersion', min: 1, max: 1);
    final chapters = <Chapter>[];
    for (final raw in root.array('chapters')) {
      final f = JsonFields(asObject(raw, 'kapitola'), 'kapitola', {
        'id',
        'title',
        'group',
        'order',
        'topics',
      });
      chapters.add(
        Chapter(
          id: _id(f),
          title: f.text('title'),
          group: f.text('group'),
          order: f.integer('order'),
          topics: f.strings('topics'),
        ),
      );
    }
    if (chapters.isEmpty) root.fail('Kurz nemá kapitoly.');
    chapters.sort((a, b) => a.order.compareTo(b.order));
    _unique(chapters.map((c) => c.order.toString()), 'pořadí kapitol');
    final paths = root.strings('lessons');
    _unique(paths, 'cesty lekcí');
    final lessons = <Lesson>[];
    for (final path in paths) {
      checkedRelative(path);
      final f =
          JsonFields(decodeObject(await source.readText(path), path), path, {
            'id',
            'chapter',
            'title',
            'subtitle',
            'order',
            'estimatedMinutes',
            'difficulty',
            'publication',
            'prerequisites',
            'content',
            'examples',
            'commonMistakes',
            'takeaway',
            'exercises',
            'optional',
          });
      final publication = switch (f.text('publication')) {
        'published' => Publication.published,
        'planned' => Publication.planned,
        _ => f.fail('Neznámý stav publikace.'),
      };
      final planned = publication == Publication.planned;
      final markdown = f.data.containsKey('content')
          ? await source.readText(checkedRelative(f.text('content')))
          : '';
      if (!planned && markdown.trim().isEmpty) f.fail('Lekce má prázdný text.');
      final examples = <CodeExample>[];
      for (final raw in f.array('examples', optional: planned)) {
        final e = JsonFields(asObject(raw, '$path.example'), '$path.example', {
          'caption',
          'code',
          'highlightedLines',
        });
        final code = e.text('code');
        final lines = e.array('highlightedLines');
        final lineCount = code.split('\n').length;
        if (lines.any((n) => n is! int || n < 1 || n > lineCount)) {
          e.fail('Neplatná čísla zvýrazněných řádků.');
        }
        examples.add(
          CodeExample(
            e.text('caption'),
            code,
            List.unmodifiable(lines.cast<int>()),
          ),
        );
      }
      final exercises = <Exercise>[];
      for (final raw in f.array('exercises', optional: planned)) {
        exercises.add(await _exercise(raw, path));
      }
      final commonMistakes = f.strings('commonMistakes', optional: planned);
      final takeaway = f.text(
        'takeaway',
        empty: planned,
        fallback: planned ? '' : null,
      );
      if (!planned && (examples.isEmpty || commonMistakes.isEmpty)) {
        f.fail('Publikovaná lekce musí mít příklad a časté chyby.');
      }
      lessons.add(
        Lesson(
          id: _id(f),
          chapter: f.text('chapter'),
          title: f.text('title'),
          subtitle: f.text('subtitle'),
          order: f.integer('order'),
          estimatedMinutes: f.integer('estimatedMinutes', min: 1, max: 1440),
          difficulty: _difficulty(f),
          publication: publication,
          optional: f.boolean('optional'),
          prerequisites: f.strings('prerequisites'),
          markdown: markdown,
          examples: List.unmodifiable(examples),
          commonMistakes: commonMistakes,
          takeaway: takeaway,
          exercises: List.unmodifiable(exercises),
        ),
      );
    }
    if (!lessons.any((l) => l.isPublished)) {
      root.fail('Kurz nemá žádnou publikovanou lekci.');
    }
    if (!lessons.any((l) => l.isPublished && !l.optional)) {
      root.fail('Kurz nemá žádnou publikovanou lekci na hlavní cestě.');
    }
    final projects = <CourseProject>[];
    for (final raw in root.array('projects')) {
      final f = JsonFields(asObject(raw, 'projekt'), 'projekt', {
        'id',
        'title',
        'subtitle',
        'afterLesson',
        'estimatedMinutes',
        'prerequisites',
        'exercise',
      });
      projects.add(
        CourseProject(
          id: _id(f),
          title: f.text('title'),
          subtitle: f.text('subtitle'),
          afterLesson: f.text('afterLesson'),
          estimatedMinutes: f.integer('estimatedMinutes', min: 1, max: 10000),
          prerequisites: f.strings('prerequisites'),
          exercise: await _exercise(f.object('exercise'), f.text('id')),
        ),
      );
    }
    final chapterOrders = {for (final c in chapters) c.id: c.order};
    for (final lesson in lessons) {
      if (!chapterOrders.containsKey(lesson.chapter)) {
        throw FormatException(
          '${lesson.id}: neznámá kapitola ${lesson.chapter}.',
        );
      }
    }
    lessons.sort((a, b) {
      final comparison = chapterOrders[a.chapter]!.compareTo(
        chapterOrders[b.chapter]!,
      );
      return comparison == 0 ? a.order.compareTo(b.order) : comparison;
    });
    _unique(lessons.map((l) => '${l.chapter}:${l.order}'), 'pořadí lekcí');
    _unique([
      ...chapters.map((c) => c.id),
      ...lessons.map((l) => l.id),
      ...projects.map((p) => p.id),
      for (final l in lessons) ...l.exercises.map((e) => e.id),
      ...projects.map((p) => p.exercise.id),
    ], 'globální ID');
    final byId = {for (final l in lessons) l.id: l};
    for (final l in lessons) {
      _references(l.prerequisites, byId, l.id);
    }
    for (final p in projects) {
      _references(
        [p.afterLesson, ...p.prerequisites],
        byId,
        p.id,
        unique: false,
      );
    }
    final visited = <String>{};
    final visiting = <String>{};
    void visit(String id) {
      if (visited.contains(id)) return;
      if (!visiting.add(id)) throw FormatException('$id: cyklus předpokladů.');
      for (final parent in byId[id]!.prerequisites) {
        visit(parent);
      }
      visiting.remove(id);
      visited.add(id);
    }

    for (final id in byId.keys) {
      visit(id);
    }
    return Course(
      title: root.text('title'),
      chapters: chapters,
      lessons: lessons,
      projects: projects,
    );
  }

  Future<Exercise> _exercise(Object? raw, String sourceName) async {
    final f = JsonFields(asObject(raw, sourceName), sourceName, {
      'id',
      'title',
      'kind',
      'difficulty',
      'prompt',
      'story',
      'starter',
      'hints',
      'solution',
      'validation',
    });
    final id = _id(f);
    final data = f.object('validation');
    final String type;
    if (data['type'] case final String value) {
      type = value;
    } else {
      f.fail('Kontrola nemá typ.');
    }
    final Validation validation;
    switch (type) {
      case 'choice':
        final c = JsonFields(data, '$id.validation', {
          'type',
          'options',
          'correctIndex',
          'explanation',
        });
        final options = c.strings('options');
        if (options.length < 2) c.fail('Volba potřebuje alespoň dvě odpovědi.');
        validation = ChoiceValidation(
          options: options,
          correctIndex: c.integer('correctIndex', max: options.length - 1),
          explanation: c.text('explanation'),
        );
      case 'manual':
        final c = JsonFields(data, '$id.validation', {'type', 'checklist'});
        final checklist = c.strings('checklist');
        if (checklist.isEmpty) c.fail('Manuální kontrola vyžaduje kritéria.');
        validation = ManualValidation(checklist);
      case 'output':
        final c = JsonFields(data, '$id.validation', {
          'type',
          'mainClass',
          'javaRelease',
          'timeoutMs',
          'cases',
        });
        final mainClass = c.text('mainClass');
        if (!RegExp(
          r'^[A-Za-z_$][A-Za-z0-9_$]*(?:\.[A-Za-z_$][A-Za-z0-9_$]*)*$',
        ).hasMatch(mainClass)) {
          c.fail('Neplatné jméno hlavní Java třídy.');
        }
        final cases = <OutputCase>[];
        for (final rawCase in c.array('cases')) {
          final o = JsonFields(asObject(rawCase, '$id.case'), '$id.case', {
            'input',
            'expected',
          });
          final input = o.text('input', empty: true);
          final expected = o.text('expected', empty: true);
          if (input.length > 65536 || expected.length > 65536) {
            c.fail('Příliš dlouhý testovací případ.');
          }
          cases.add(OutputCase(input: input, expected: expected));
        }
        if (cases.isEmpty || cases.length > 100) {
          c.fail('Kontrola potřebuje 1 až 100 případů.');
        }
        validation = OutputValidation(
          mainClass: mainClass,
          javaRelease: c.integer('javaRelease', min: 21, max: 25),
          timeoutMs: c.integer('timeoutMs', min: 100, max: 30000),
          cases: List.unmodifiable(cases),
        );
      default:
        f.fail('Neznámý typ kontroly: $type');
    }
    String? starter;
    if (f.data.containsKey('starter')) {
      starter = checkedRelative(f.text('starter'));
      final files = await source.filesUnder(starter);
      if (files.isEmpty || files.length > 500) {
        f.fail('$starter: starter musí mít 1 až 500 souborů.');
      }
      for (final path in files) {
        checkedRelative(path);
      }
      if (validation is OutputValidation &&
          !files.any(
            (path) =>
                path.startsWith('$starter/src/main/java/') &&
                path.endsWith('.java'),
          )) {
        f.fail('$starter: chybí Java zdroj v src/main/java.');
      }
    } else if (validation is OutputValidation) {
      f.fail('Výstupní kontrola potřebuje starter.');
    }
    ExerciseStory? story;
    if (f.data.containsKey('story')) {
      final s = JsonFields(f.object('story'), '$id.story', {'world', 'text'});
      story = ExerciseStory(world: s.text('world'), text: s.text('text'));
    }
    return Exercise(
      id: id,
      title: f.text('title'),
      kind: f.text('kind'),
      difficulty: _difficulty(f),
      prompt: f.text('prompt'),
      story: story,
      starter: starter,
      hints: f.strings('hints'),
      solution: f.text('solution'),
      validation: validation,
    );
  }

  static String _id(JsonFields f) {
    final id = f.text('id');
    if (!validId(id)) f.fail('Neplatné ID: $id');
    return id;
  }

  static Difficulty _difficulty(JsonFields f) => switch (f.text('difficulty')) {
    'easy' => Difficulty.easy,
    'normal' => Difficulty.normal,
    'challenge' => Difficulty.challenge,
    _ => f.fail('Neznámá obtížnost.'),
  };
  static void _unique(Iterable<String> values, String what) {
    final seen = <String>{};
    for (final value in values) {
      if (!seen.add(value)) throw FormatException('Duplicitní $what: $value');
    }
  }

  static void _references(
    List<String> refs,
    Map<String, Lesson> lessons,
    String owner, {
    bool unique = true,
  }) {
    if (unique) _unique(refs, '$owner předpoklady');
    for (final ref in refs) {
      if (!lessons.containsKey(ref)) {
        throw FormatException('$owner: neznámá lekce $ref.');
      }
    }
  }
}
