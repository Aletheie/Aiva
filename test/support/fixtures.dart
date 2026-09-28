import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:aiva/content/content_source.dart';
import 'package:aiva/content/course_loader.dart';
import 'package:aiva/domain/course.dart';

Directory projectRoot() {
  var directory = Directory.current.absolute;
  while (!File(p.join(directory.path, 'pubspec.yaml')).existsSync()) {
    final parent = directory.parent;
    if (parent.path == directory.path) {
      throw StateError('Run tests from the project root.');
    }
    directory = parent;
  }
  return directory;
}

Future<Course> realCourse() => CourseLoader(
  DirectoryContentSource(p.join(projectRoot().path, 'content')),
).load();

final class MemoryContent extends ContentSource {
  MemoryContent(this.files);
  final Map<String, String> files;
  @override
  Future<List<int>> readBytes(String relative) async {
    if (!files.containsKey(relative)) {
      throw FormatException('Missing $relative');
    }
    return utf8.encode(files[relative]!);
  }

  @override
  Future<List<String>> filesUnder(String relative) async =>
      files.keys.where((key) => key.startsWith('$relative/')).toList()..sort();
}

Future<MemoryContent> realContentInMemory() async {
  final root = Directory(p.join(projectRoot().path, 'content'));
  return MemoryContent({
    for (final file in root.listSync(recursive: true).whereType<File>())
      p.relative(file.path, from: root.path).split(p.separator).join('/'):
          await file.readAsString(),
  });
}

// Keep planned-content behavior covered even when the shipped syllabus is full.
Future<MemoryContent> contentWithPlannedFilesLesson([
  MemoryContent? original,
]) async {
  final content = original ?? await realContentInMemory();
  final source = MemoryContent(Map.of(content.files));
  const path = 'lessons/files-overview.json';
  final lesson = jsonDecode(source.files[path]!) as Map<String, dynamic>;
  lesson['publication'] = 'planned';
  for (final key in [
    'content',
    'examples',
    'commonMistakes',
    'takeaway',
    'exercises',
  ]) {
    lesson.remove(key);
  }
  source.files[path] = jsonEncode(lesson);
  return source;
}
