import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final class AppPaths {
  const AppPaths({required this.profile, required this.workspace});
  final String profile;
  final String workspace;
  String get database => p.join(profile, 'progress.sqlite');
  static Future<AppPaths> load({String? profileOverride}) async {
    final support =
        profileOverride ?? (await getApplicationSupportDirectory()).path;
    final documents = (await getApplicationDocumentsDirectory()).path;
    return fromDirectories(
      support: support,
      documents: documents,
      reuseExistingProfile: profileOverride == null,
    );
  }

  static Future<AppPaths> fromDirectories({
    required String support,
    required String documents,
    bool reuseExistingProfile = true,
  }) async {
    var profile = support;
    // Reuse the old profile in place, including SQLite WAL files.
    if (reuseExistingProfile &&
        !await File(p.join(support, 'progress.sqlite')).exists()) {
      final parent = p.dirname(support);
      final candidates = switch (p.basename(support)) {
        'dev.aiva.desktop' => [p.join(parent, 'dev.javapath.desktop')],
        'dev.aiva.aiva' || 'aiva' => [
          p.join(parent, 'dev.javapath.javapath'),
          p.join(parent, 'javapath'),
        ],
        'Aiva' || 'AIVA' when p.basename(parent) == 'dev.AIVA' => [
          p.join(p.dirname(parent), 'dev.JavaPath', 'JavaPath'),
        ],
        _ => <String>[],
      };
      for (final candidate in candidates) {
        if (await File(p.join(candidate, 'progress.sqlite')).exists()) {
          profile = candidate;
          break;
        }
      }
    }
    var workspace = p.join(documents, 'AIVA', 'exercises');
    final previousWorkspace = p.join(documents, 'JavaPath', 'exercises');
    if (!await Directory(workspace).exists() &&
        await Directory(previousWorkspace).exists()) {
      workspace = previousWorkspace;
    }
    await Directory(profile).create(recursive: true);
    return AppPaths(profile: p.absolute(profile), workspace: workspace);
  }
}
