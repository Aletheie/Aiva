# Aiva

I promised my friends at university an easy way to learn Java, so I built Aiva around a curriculum similar to an introductory university Java course. It works offline, uses the `fluent_ui` library, and has a handmade Acrylic-inspired effect in the navigation pane. The source code and course content are open source under the [MIT License](LICENSE).

## Download for Windows

Download the [Aiva 1.0.1 Windows x64 ZIP](https://github.com/Aletheie/Aiva/releases/download/v1.0.1/Aiva-1.0.1-windows-x64-portable.zip), extract the entire archive, and run **Aiva-x64/Aiva.exe**. Keep the DLL files and the `data` folder next to the executable. Flutter and Visual Studio are not required.

This package requires the [Microsoft Visual C++ Redistributable x64](https://aka.ms/vc14/vc_redist.x64.exe), installed separately if it is not already available. Reading the course works without Java; checking Java exercises requires a local JDK 21 or later.

## Download for macOS

Download the [Aiva 1.1.0 universal DMG](https://github.com/Aletheie/Aiva/releases/download/v1.1.0/Aiva-1.1.0-macos-universal.dmg), open it, and drag **Aiva** into **Applications**. Flutter is not required. Reading the course works without Java; checking Java exercises requires a local JDK 21 or later. For Java IntelliSense in the built-in editor, JDK 21 or 25 is recommended.

The universal macOS package includes Apple Silicon and Intel binaries and targets macOS 12 or later. This release was tested on Apple Silicon.

This release is ad-hoc signed and is not notarized by Apple. If macOS blocks the first launch, follow [Apple's instructions for opening an app from an unidentified developer](https://support.apple.com/en-us/102445) after verifying that you downloaded it from this repository. SHA-256 checksums are included with the release.

## Download source

[Aiva v1.1.0 source ZIP](https://github.com/Aletheie/Aiva/releases/download/v1.1.0/Aiva-1.1.0-source.zip) includes the built-in exercise editor, the signed/unsigned lesson, and the Windows content-index fix. This archive requires Flutter to build; see [Build on Windows](#build-on-windows) below. The compiled Windows package remains at v1.0.1.

## A look inside

https://github.com/user-attachments/assets/b698465d-3406-4858-b0de-c8e521c52fb3

[Download the demo with sound (MP4)](demo-video/aiva-demo.mp4?raw=true) · [Animated preview (GIF)](demo-video/aiva-preview.gif) · [Editable Remotion project](demo-video/README.md)

The 20-second demo follows a real exercise: open its instructions, edit Java in the integrated editor, run the program, check the solution, and view saved progress. Enable sound in the player for English narration and music.

<details>
<summary>Lesson preview</summary>

![Lekce SQL a JDBC ve světlém režimu: relační databáze, výklad a ukázka SQL](docs/images/aiva-lesson-light.png)

</details>

## Features

- Displays lessons, code examples, common mistakes, and exercises in a Czech interface on macOS, Windows, and Linux. The course works offline.
- Includes 79 lessons, 174 exercises, and six projects. It stores completed lessons and exercises, favorites, and reading position in a local SQLite profile.
- Searches lesson titles, content, and topics in Czech and English. Search is case- and accent-insensitive.
- Offers a Fluent exercise workspace with instructions, a native code editor, program input/output, and test results. Choose **Nastavení → Prostředí pro cvičení → Přímo v Aiva** to enable it, or keep IntelliJ IDEA / VS Code as the external editor. Both modes use the same working files and preserve existing solutions.
- Provides semantic Java completion, documentation, and diagnostics through [Eclipse JDT Language Server](https://github.com/eclipse-jdtls/eclipse.jdt.ls). In settings, prepare Java IntelliSense once (about 49 MiB), reuse a detected installation, or select its directory. The server runs locally with JDK 21–25 (21 or 25 recommended); Aiva can use a compatible installed or IntelliJ-bundled runtime independently of the JDK selected for exercise checks; the native [Re-Editor](https://pub.dev/packages/re_editor) surface also works without it. Use Ctrl+Space for completion, F1 for documentation, Ctrl/⌘+S to save, and Esc to move focus out of the editor. Changes are also saved automatically.
- Checks selected solutions against the expected output using a local JDK 21 or later. Other exercises use the checklist provided in the instructions. Projects using Maven, Gradle, or JUnit are run in an external IDE or terminal.
- Supports backing up and restoring the profile, including learning progress.

## Course coverage

The course has 45 lessons on the core path and 34 optional lessons. It covers:

- programming fundamentals, Java syntax, variables, types, signed/unsigned interpretation, numeric byte sizes and range calculations, operators, input and output, conditionals, loops, methods, and arrays;
- classes and objects, constructors, references and `null`, encapsulation, inheritance, polymorphism, interfaces, enums, and generics;
- collections, object equality, exceptions, dates and times, file handling, and numeric precision;
- JUnit testing, TDD, and test doubles; building projects with Maven and Gradle; Git, GitHub and GitLab collaboration, and application structure;
- optional topics including JSON, XML, YAML, lambda expressions, the Stream API, regular expressions, HTTP and APIs, SQL and JDBC, concurrency, debugging, and other advanced subjects.

## Build on Windows

With Flutter and Visual Studio's Desktop development with C++ workload installed, run from the repository root:

```powershell
dart tool/bootstrap.dart
flutter pub get
flutter run -d windows
```

The content index records exact file sizes. `.gitattributes` keeps course assets at LF line endings even with Git's Windows `core.autocrlf` setting. Every Windows build also refreshes the index before bundling assets, including ordinary `flutter run -d windows` and `flutter build windows` commands.

When upgrading an existing checkout after a content-index error, close the running Aiva session (`q` in the Flutter terminal) and rebuild its assets:

```powershell
flutter clean
flutter pub get
flutter run -d windows
```

Restart Aiva from the rebuilt bundle. This does not change your learning profile or exercise workspaces.
