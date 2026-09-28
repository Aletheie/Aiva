# Third-party components and release notices

This source snapshot does not vendor a Flutter SDK, Dart SDK, downloaded pub packages, system fonts, Microsoft CRT binaries or an installer. Dependencies will be resolved by `flutter pub get` on the developer's machine. Their exact transitive versions have **not** been resolved in the creation environment; no invented `pubspec.lock` is supplied.

## Direct runtime dependencies

| Component | Declared version | Purpose / upstream |
|---|---|---|
| Flutter + flutter_localizations | SDK; selected 3.47.0 | Desktop engine, core widgets and localization: https://flutter.dev |
| fluent_ui | 4.16.1 | The sole application UI kit; BSD-3-Clause, Bruno D'Luka: https://pub.dev/packages/fluent_ui/license |
| sqlite3 | 3.6.0 | Native SQLite binding/assets; MIT, Simon Binder: https://pub.dev/packages/sqlite3/license |
| path | 1.9.1 | Filesystem path operations: https://pub.dev/packages/path |
| path_provider | 2.1.6 | OS application data directories: https://pub.dev/packages/path_provider |
| file_selector | 1.1.0 | System file selection: https://pub.dev/packages/file_selector |
| url_launcher | 6.3.2 | Explicit external links: https://pub.dev/packages/url_launcher |
| markdown | 7.3.1 | Markdown parsing, not a UI kit: https://pub.dev/packages/markdown |

Dart/Flutter packages carry their own copyright and license notices. Do not replace those notices with this summary. `tool/export_licenses.dart`, run after dependency resolution, copies the actual installed-package license texts to `build/legal/DEPENDENCY-LICENSES.txt`; packaging scripts include that file. The app also displays Flutter's actual `LicenseRegistry` in Settings. Font files are not copied from the authoring environment.

## Native/runtime packaging

Flutter engine binaries and resolved native plugin assets carry additional notices. Preserve the full Flutter output bundle and its generated notices, not only the main executable. SQLite native assets are supplied by the sqlite3 hook; inspect the actual resolved distribution. Microsoft CRT files may be copied only from the redistributable directory of an appropriately licensed Visual Studio installation, subject to its terms.

Linux AppImage may bundle GTK, GLib and related native libraries. A release maintainer must retain their copyright/license notices and satisfy their applicable redistribution conditions. The generic Dart license exporter is **not** a complete native dependency license audit. No claim of completed release-license compliance is made before a native bundle has actually been built and inspected.

## Course project dependencies

The preserved StudyDesk Maven starter declares Gson and JUnit. Those dependencies belong to a separately built student project, not to AIVA's Flutter runtime. Their licenses and Maven-resolved versions must be kept with any distribution of that separately built project. The archive includes starter sources, not downloaded JARs.

## Source application

AIVA's own project code and preserved course assets use the included project `LICENSE`. Original course material and application icon were retained from the supplied AIVA source archive. Third-party marks and names are used descriptively, not to claim endorsement.
