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
app='build/macos/Build/Products/Release/Aiva.app'
[[ -d "$app" ]] || { echo "Missing $app" >&2; exit 1; }
mkdir -p dist build/package
stage="$(mktemp -d "$PWD/build/package/dmg.XXXXXX")"
trap 'rm -rf "$stage"' EXIT
ditto "$app" "$stage/Aiva.app"
cp LICENSE "$stage/Aiva.app/Contents/Resources/Aiva-LICENSE.txt"
cp THIRD_PARTY_NOTICES.md build/legal/DEPENDENCY-LICENSES.txt "$stage/Aiva.app/Contents/Resources/"
# No signing identity => local development DMG, not a notarized public release.
identity="${MACOS_SIGN_IDENTITY:--}"
if [[ "$identity" != - ]]; then
  # Sign nested Mach-O files, frameworks and bundles from inside out.
  while IFS= read -r -d '' file; do
    if /usr/bin/file "$file" | grep -q 'Mach-O'; then
      codesign --force --options runtime --timestamp --sign "$identity" "$file"
    fi
  done < <(find "$stage/Aiva.app/Contents" -type f -print0)
  while IFS= read -r -d '' bundle; do
    codesign --force --options runtime --timestamp --sign "$identity" "$bundle"
  done < <(find "$stage/Aiva.app/Contents" -depth \( -name '*.framework' -o -name '*.bundle' \) -type d -print0)
  codesign --force --options runtime --timestamp --entitlements platform_overlays/macos/Runner/Release.entitlements \
    --sign "$identity" "$stage/Aiva.app"
else
  codesign --force --deep --sign - "$stage/Aiva.app"
fi
codesign --verify --deep --strict "$stage/Aiva.app"
ln -s /Applications "$stage/Applications"
arch="$(lipo -archs "$stage/Aiva.app/Contents/MacOS/Aiva")"
if [[ "$arch" == *arm64* && "$arch" == *x86_64* ]]; then
  arch=universal
fi
dmg="$PWD/dist/Aiva-$version-macos-$arch.dmg"
hdiutil create -volname Aiva -srcfolder "$stage" -ov -format UDZO "$dmg"
if [[ -n "${MACOS_NOTARY_PROFILE:-}" ]]; then
  [[ "$identity" != - ]] || { echo 'Notarization requires a Developer ID identity.' >&2; exit 1; }
  xcrun notarytool submit "$dmg" --keychain-profile "$MACOS_NOTARY_PROFILE" --wait
  xcrun stapler staple "$dmg"
fi
shasum -a 256 "$dmg"
