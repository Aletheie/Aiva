#!/usr/bin/env python3
"""Exercise the Windows content-index build dependency with real CMake and Dart."""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def run(command: list[str], *, succeeds: bool = True) -> subprocess.CompletedProcess:
    result = subprocess.run(command, capture_output=True, text=True)
    if (result.returncode == 0) != succeeds:
        raise AssertionError(f'{command}\n{result.stdout}\n{result.stderr}')
    return result


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--cmake', default=shutil.which('cmake'))
    parser.add_argument('--flutter-root', default=os.environ.get('FLUTTER_ROOT'))
    args = parser.parse_args()
    if not args.cmake:
        parser.error('CMake is required; pass --cmake or add it to PATH.')
    if args.flutter_root:
        flutter_root = Path(args.flutter_root).resolve()
    else:
        flutter = shutil.which('flutter')
        if not flutter:
            parser.error('Flutter is required; pass --flutter-root.')
        flutter_root = Path(flutter).resolve().parent.parent
    dart = flutter_root / 'bin/cache/dart-sdk/bin' / (
        'dart.exe' if os.name == 'nt' else 'dart'
    )
    assert dart.is_file(), dart

    with tempfile.TemporaryDirectory(prefix='aiva content build ') as temporary:
        root = Path(temporary)
        for folder in ['tool', 'assets', 'content/starters/example', 'windows/flutter']:
            (root / folder).mkdir(parents=True, exist_ok=True)
        for name in ['content_index.dart', 'windows_content_index.cmake']:
            shutil.copy2(ROOT / 'tool' / name, root / 'tool' / name)
        pubspec = root / 'pubspec.yaml'
        pubspec.write_text(
            'name: fixture\nflutter:\n  assets:\n'
            '    # BEGIN GENERATED CONTENT ASSETS\n'
            '    # END GENERATED CONTENT ASSETS\n',
            encoding='utf-8', newline='\n',
        )
        course = root / 'content/course.json'
        course.write_bytes('{\n  "title": "Český kurz"\n}\n'.encode())
        starter = root / 'content/starters/example/.gitignore'
        starter.write_bytes(b'target/\n')
        generator = root / 'tool/content_index.dart'
        run([str(dart), str(generator)])

        # A pull can leave CRLF content beside an index generated from LF files.
        course.write_bytes(course.read_bytes().replace(b'\n', b'\r\n'))
        windows = root / 'windows'
        cmake_project = (
            'cmake_minimum_required(VERSION 3.14)\n'
            'project(ContentIndexRegression LANGUAGES NONE)\n'
            'set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")\n'
            'add_subdirectory(${FLUTTER_MANAGED_DIR})\n'
        )
        (windows / 'CMakeLists.txt').write_text(cmake_project, encoding='utf-8')
        # The consumer fails if the refresh target runs too late or not at all.
        (windows / 'flutter/CMakeLists.txt').write_text(
            f'set(FLUTTER_ROOT [=[{flutter_root.as_posix()}]=])\n'
            'add_custom_target(flutter_assemble\n'
            f'  COMMAND [=[{dart.as_posix()}]=] [=[{generator.as_posix()}]=] --check\n'
            '  VERBATIM)\n', encoding='utf-8',
        )
        build_dir = root / 'build'
        configure = [args.cmake, '-S', str(windows), '-B', str(build_dir)]
        build = [args.cmake, '--build', str(build_dir), '--target', 'flutter_assemble']
        run(configure)
        failure = run(build, succeeds=False)
        assert 'Content index is stale' in failure.stdout + failure.stderr

        with (windows / 'CMakeLists.txt').open('a', encoding='utf-8') as target:
            target.write(
                'include("${CMAKE_CURRENT_SOURCE_DIR}/../tool/windows_content_index.cmake")\n'
            )
        run(configure)
        run(build)
        print('PASS: build refreshes a stale LF index for existing CRLF assets')

        # Reuse the same configured build after edits, additions and removals.
        course.write_bytes('{"title": "Aktualizovaný kurz"}\r\n'.encode())
        starter.unlink()
        (starter.parent / 'Nový soubor.txt').write_bytes('Další zadání\r\n'.encode())
        run(build)
        index = root / 'assets/content-index.json'
        manifest = json.loads(index.read_text(encoding='utf-8'))
        assert manifest['files'] == [
            {'path': file.relative_to(root / 'content').as_posix(), 'bytes': file.stat().st_size}
            for file in sorted((root / 'content').rglob('*')) if file.is_file()
        ]
        print('PASS: incremental build includes changed, added and removed assets')

        timestamps = [file.stat().st_mtime_ns for file in [index, pubspec]]
        run(build)
        assert timestamps == [file.stat().st_mtime_ns for file in [index, pubspec]]
        print('PASS: unchanged builds preserve metadata timestamps')


if __name__ == '__main__':
    main()
