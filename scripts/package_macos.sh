#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
[[ "$(uname -s)" == Darwin ]] || { echo 'Build this package on macOS.' >&2; exit 1; }
if [[ "${1:-}" != --skip-build ]]; then
  dart tool/bootstrap.dart
  flutter pub get
  flutter build macos --release
fi
dart tool/export_licenses.dart
version="$(sed -nE 's/^version: ([^+[:space:]]+).*/\1/p' pubspec.yaml)"
app='build/macos/Build/Products/Release/AIVA.app'
[[ -d "$app" ]] || { echo "Missing $app" >&2; exit 1; }
mkdir -p dist build/package
stage="$(mktemp -d "$PWD/build/package/dmg.XXXXXX")"
trap 'rm -rf "$stage"' EXIT
ditto "$app" "$stage/AIVA.app"
cp LICENSE "$stage/AIVA.app/Contents/Resources/AIVA-LICENSE.txt"
cp THIRD_PARTY_NOTICES.md build/legal/DEPENDENCY-LICENSES.txt "$stage/AIVA.app/Contents/Resources/"
# No signing identity => local development DMG, not a notarized public release.
identity="${MACOS_SIGN_IDENTITY:--}"
if [[ "$identity" != - ]]; then
  # Sign nested Mach-O files, frameworks and bundles from inside out.
  while IFS= read -r -d '' file; do
    if /usr/bin/file "$file" | grep -q 'Mach-O'; then
      codesign --force --options runtime --timestamp --sign "$identity" "$file"
    fi
  done < <(find "$stage/AIVA.app/Contents" -type f -print0)
  while IFS= read -r -d '' bundle; do
    codesign --force --options runtime --timestamp --sign "$identity" "$bundle"
  done < <(find "$stage/AIVA.app/Contents" -depth \( -name '*.framework' -o -name '*.bundle' \) -type d -print0)
  codesign --force --options runtime --timestamp --entitlements platform_overlays/macos/Runner/Release.entitlements \
    --sign "$identity" "$stage/AIVA.app"
else
  codesign --force --deep --sign - "$stage/AIVA.app"
fi
codesign --verify --deep --strict "$stage/AIVA.app"
ln -s /Applications "$stage/Applications"
arch="$(uname -m)"
dmg="$PWD/dist/AIVA-$version-macos-$arch.dmg"
hdiutil create -volname AIVA -srcfolder "$stage" -ov -format UDZO "$dmg"
if [[ -n "${MACOS_NOTARY_PROFILE:-}" ]]; then
  [[ "$identity" != - ]] || { echo 'Notarization requires a Developer ID identity.' >&2; exit 1; }
  xcrun notarytool submit "$dmg" --keychain-profile "$MACOS_NOTARY_PROFILE" --wait
  xcrun stapler staple "$dmg"
fi
shasum -a 256 "$dmg"
