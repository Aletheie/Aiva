# Third-party components and release notices

Runtime dependencies are declared in `pubspec.yaml` and locked in `pubspec.lock`. Run `flutter pub get` to download them. The Flutter SDK version is recorded in `.flutter-version`.

## Direct runtime dependencies

| Component | Declared version | Purpose / upstream |
|---|---|---|
| Flutter + flutter_localizations | SDK; selected 3.47.0 | Desktop engine, core widgets and localization: https://flutter.dev |
| fluent_ui | 4.16.1 | UI components; BSD-3-Clause, Bruno D'Luka: https://pub.dev/packages/fluent_ui/license |
| sqlite3 | 3.6.0 | Native SQLite binding/assets; MIT, Simon Binder: https://pub.dev/packages/sqlite3/license |
| path | 1.9.1 | Filesystem path operations: https://pub.dev/packages/path |
| path_provider | 2.1.6 | OS application data directories: https://pub.dev/packages/path_provider |
| file_selector | 1.1.0 | System file selection: https://pub.dev/packages/file_selector |
| url_launcher | 6.3.2 | Explicit external links: https://pub.dev/packages/url_launcher |
| markdown | 7.3.1 | Markdown parsing: https://pub.dev/packages/markdown |
| re_editor | 0.10.0 | Native code editor; MIT: https://pub.dev/packages/re_editor/license |
| re_highlight | ^0.0.3 | Syntax highlighting; MIT: https://pub.dev/packages/re_highlight/license |
| crypto | 3.0.7 | SHA-256 verification of the optional language server download; BSD-3-Clause: https://pub.dev/packages/crypto/license |

Dart/Flutter packages carry their own copyright and license notices. `tool/export_licenses.dart`, run after dependency resolution, copies the installed-package license texts to `build/legal/DEPENDENCY-LICENSES.txt`; packaging scripts include that file. The app also displays Flutter's `LicenseRegistry` in Settings. This summary does not replace those license texts.

## Native/runtime packaging

Flutter engine binaries and resolved native plugin assets carry additional notices. Preserve the full Flutter output bundle and its generated notices, not only the main executable. SQLite native assets are supplied by the sqlite3 hook; inspect the actual resolved distribution. Microsoft CRT files may be copied only from the redistributable directory of an appropriately licensed Visual Studio installation, subject to its terms.

Linux AppImage may bundle GTK, GLib and related native libraries. Retain their copyright/license notices and follow their redistribution terms. The Dart license exporter covers Dart packages; native libraries need a separate review for each release.

## Optional Java language server

Java IntelliSense optionally downloads Eclipse JDT Language Server from the Eclipse Foundation, or uses an existing local installation. It is not bundled in the Aiva installer. The downloaded distribution retains its own Eclipse and third-party license notices; see https://github.com/eclipse-jdtls/eclipse.jdt.ls and the installed server's license files.

## Course project dependencies

The StudyDesk Maven starter declares Gson and JUnit. These are dependencies of the student project. Include their licenses and Maven-resolved versions when distributing that project. This repository contains the starter sources; Maven downloads the JARs when the student builds them.

## Source application

AIVA's code and course assets use the included project `LICENSE`. Third-party marks and names are used descriptively, not to claim endorsement.
