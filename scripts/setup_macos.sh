#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
command -v flutter >/dev/null || { echo 'Flutter SDK must be on PATH.' >&2; exit 1; }
command -v dart >/dev/null || { echo 'Dart from the same Flutter SDK must be on PATH.' >&2; exit 1; }
dart tool/bootstrap.dart
flutter pub get
flutter doctor -v
printf '\nStart: flutter run -d macos\n'
