#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
[[ "$(uname -s)" == Linux && "$(uname -m)" == x86_64 ]] || { echo 'This recipe targets Linux x86_64.' >&2; exit 1; }
if [[ "${1:-}" != --skip-build ]]; then
  dart tool/bootstrap.dart
  flutter pub get
  flutter build linux --release
fi
dart tool/export_licenses.dart
root="$PWD"
version="$(sed -nE 's/^version: ([^+[:space:]]+).*/\1/p' pubspec.yaml)"
bundle="$root/build/linux/x64/release/bundle"
[[ -x "$bundle/aiva" ]] || { echo 'Missing Flutter Linux bundle.' >&2; exit 1; }
mkdir -p dist build/package
work="$(mktemp -d "$root/build/package/linux.XXXXXX")"
trap 'rm -rf "$work"' EXIT
stage="$work/deb"
mkdir -p "$stage/opt/aiva" "$stage/usr/bin" "$stage/usr/share/applications" "$stage/usr/share/icons/hicolor/256x256/apps" "$stage/DEBIAN"
cp -a "$bundle/." "$stage/opt/aiva/"
cp LICENSE THIRD_PARTY_NOTICES.md build/legal/DEPENDENCY-LICENSES.txt "$stage/opt/aiva/"
printf '#!/bin/sh\nexec /opt/aiva/aiva "$@"\n' > "$stage/usr/bin/aiva"
chmod 755 "$stage/usr/bin/aiva"
cp packaging/linux/aiva.desktop "$stage/usr/share/applications/"
cp assets/icon.png "$stage/usr/share/icons/hicolor/256x256/apps/aiva.png"
# Derive package dependencies from the built ELF binaries.
mkdir -p "$work/debian"
printf 'Source: aiva\nSection: education\nPriority: optional\nMaintainer: Aiva contributors\n\nPackage: aiva\nArchitecture: amd64\nDescription: Offline Java learning desktop\n' > "$work/debian/control"
args=(-O --ignore-missing-info "-e$stage/opt/aiva/aiva")
while IFS= read -r -d '' so; do args+=("-e$so" "-l$(dirname "$so")"); done < <(find "$stage/opt/aiva" -type f -name '*.so*' -print0)
deps="$(cd "$work" && dpkg-shlibdeps "${args[@]}" | sed -n 's/^shlibs:Depends=//p')"
[[ -n "$deps" ]] || { echo 'Could not determine runtime dependencies.' >&2; exit 1; }
cat > "$stage/DEBIAN/control" <<CONTROL
Package: aiva
Version: $version
Section: education
Priority: optional
Architecture: amd64
Maintainer: Aiva contributors
Depends: $deps
Description: Offline Java course with Fluent desktop UI
 Local progress, external IDE workspaces and local Java exercise checks.
CONTROL
dpkg-deb --root-owner-group --build "$stage" "$root/dist/Aiva-$version-linux-amd64.deb"
# AppImage needs linuxdeploy and its GTK plugin on PATH.
if [[ -n "${LINUXDEPLOY:-}" ]]; then
  appdir="$work/Aiva.AppDir"
  mkdir -p "$appdir/usr/lib/aiva" "$appdir/usr/share/applications" "$appdir/usr/share/icons/hicolor/256x256/apps"
  cp -a "$bundle/." "$appdir/usr/lib/aiva/"
  cp LICENSE THIRD_PARTY_NOTICES.md build/legal/DEPENDENCY-LICENSES.txt "$appdir/usr/lib/aiva/"
  cp packaging/linux/aiva.desktop "$appdir/usr/share/applications/"
  cp assets/icon.png "$appdir/usr/share/icons/hicolor/256x256/apps/aiva.png"
  cat > "$appdir/AppRun" <<'APPRUN'
#!/usr/bin/env bash
HERE="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
export APPDIR="$HERE"
for hook in "$HERE"/apprun-hooks/*.sh; do
  [[ -f "$hook" ]] && source "$hook"
done
export LD_LIBRARY_PATH="$HERE/usr/lib/aiva/lib:$HERE/usr/lib:$HERE/usr/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
exec "$HERE/usr/lib/aiva/aiva" "$@"
APPRUN
  chmod +x "$appdir/AppRun"
  (cd "$work" && APPIMAGE_EXTRACT_AND_RUN=1 DEPLOY_GTK_VERSION=3 "$LINUXDEPLOY" --appdir "$appdir" \
    --executable "$appdir/usr/lib/aiva/aiva" --desktop-file "$appdir/usr/share/applications/aiva.desktop" \
    --icon-file "$appdir/usr/share/icons/hicolor/256x256/apps/aiva.png" --plugin gtk --output appimage)
  image="$(find "$work" -maxdepth 1 -type f -name '*.AppImage' -print -quit)"
  [[ -n "$image" ]] || { echo 'linuxdeploy did not create an AppImage.' >&2; exit 1; }
  cp "$image" "$root/dist/Aiva-$version-linux-x86_64.AppImage"
else
  echo 'DEB created. AppImage omitted: set LINUXDEPLOY and install linuxdeploy-plugin-gtk.sh.'
fi
sha256sum dist/Aiva-"$version"-linux-*
