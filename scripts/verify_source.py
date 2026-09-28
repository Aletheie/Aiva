#!/usr/bin/env python3
"""Offline source/content checks. This is not a Dart parser or Flutter build."""
from __future__ import annotations
import argparse
import hashlib
import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def unique_object(pairs: list[tuple[str, object]]) -> dict:
    result: dict = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f'Duplicate JSON key: {key}')
        result[key] = value
    return result


def load(path: Path):
    return json.loads(path.read_text(encoding='utf-8'), object_pairs_hook=unique_object)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--original', type=Path, help='Optional original AIVA project root')
    args = parser.parse_args()
    checks: list[str] = []
    files = sorted(p for p in (ROOT / 'content').rglob('*') if p.is_file())
    assert all(not p.is_symlink() for p in files), 'Symlink in content'
    content = {p.relative_to(ROOT / 'content').as_posix(): p for p in files}
    assert len(content) == len(files)
    for name in content:
        assert not name.startswith('/') and '..' not in name.split('/') and '\\' not in name
    checks.append('Content paths are relative and contain no symlinks')

    manifest = load(ROOT / 'assets/content-index.json')
    expected = [{'path': name, 'bytes': p.stat().st_size} for name, p in sorted(content.items())]
    assert manifest == {'schemaVersion': 1, 'files': expected}, 'Asset index mismatch'
    checks.append(f'Asset manifest matches all {len(files)} files and byte counts')
    pubspec = (ROOT / 'pubspec.yaml').read_text()
    listed = re.findall(r"^    - 'content/(.+)'$", pubspec, re.M)
    assert listed == sorted(content), 'pubspec asset entries differ'
    checks.append('Every content file, including nested and hidden starters, is a Flutter asset')
    for p in files:
        if p.suffix == '.json':
            load(p)
    checks.append('All JSON files parse without duplicate keys')

    course = load(ROOT / 'content/course.json')
    lessons = [load(ROOT / 'content' / path) for path in course['lessons']]
    projects = course['projects']
    exercises = [e for lesson in lessons for e in lesson.get('exercises', [])]
    all_exercises = exercises + [p['exercise'] for p in projects]
    ids = [c['id'] for c in course['chapters']] + [l['id'] for l in lessons] + [p['id'] for p in projects] + [e['id'] for e in all_exercises]
    assert len(ids) == len(set(ids)), 'Duplicate global ID'
    chapters = {c['id'] for c in course['chapters']}
    lesson_ids = {l['id'] for l in lessons}
    for lesson in lessons:
        assert lesson['chapter'] in chapters
        assert set(lesson['prerequisites']) <= lesson_ids
        if lesson['publication'] == 'published':
            assert (ROOT / 'content' / lesson['content']).is_file()
            assert lesson['examples'] and lesson['commonMistakes']
            assert isinstance(lesson['exercises'], list)
    for project in projects:
        assert project['afterLesson'] in lesson_ids
        assert set(project['prerequisites']) <= lesson_ids
    visited, active = set(), set()
    by_id = {l['id']: l for l in lessons}
    def visit(id: str) -> None:
        if id in visited:
            return
        assert id not in active, f'Prerequisite cycle: {id}'
        active.add(id)
        for parent in by_id[id]['prerequisites']:
            visit(parent)
        active.remove(id)
        visited.add(id)
    for id in by_id:
        visit(id)
    for exercise in all_exercises:
        if 'starter' in exercise:
            assert any(p.startswith(exercise['starter'] + '/') for p in content)
        if exercise['validation']['type'] == 'output':
            assert exercise['validation']['cases'] and exercise['starter']
    checks.append('Course IDs, prerequisites, ordering references and starter references are coherent')

    dart_files = [p for folder in ['lib', 'test', 'integration_test', 'tool'] for p in (ROOT / folder).rglob('*.dart')]
    for p in dart_files:
        for imported in re.findall(r"(?:import|export|part)\s+['\"]([^'\"]+)['\"]", p.read_text()):
            if ':' not in imported:
                assert (p.parent / imported).is_file(), f'Missing relative import: {p}: {imported}'
            elif imported.startswith('package:aiva/'):
                assert (ROOT / 'lib' / imported.removeprefix('package:aiva/')).is_file(), imported
    checks.append(f'Relative/application imports resolve across {len(dart_files)} Dart source files')
    app_sources = '\n'.join(p.read_text() for p in (ROOT / 'lib').rglob('*.dart'))
    assert 'package:flutter/material.dart' not in app_sources
    assert 'package:flutter/cupertino.dart' not in app_sources
    assert 'webview' not in '\n'.join(re.findall(r"import ['\"]([^'\"]+)", app_sources)).lower()
    assert 'Acrylic(' in app_sources and 'fluent_ui: 4.16.1' in pubspec
    checks.append('Application UI imports only Fluent UI / Flutter core, with an actual Acrylic widget')
    for p in (ROOT / 'platform_overlays').rglob('*.entitlements'):
        tree = ET.parse(p)
        nodes = list(tree.getroot().find('dict'))
        flag = next(nodes[i+1].tag for i, n in enumerate(nodes[:-1]) if n.text == 'com.apple.security.app-sandbox')
        assert flag == 'false', p
    checks.append('Mac entitlements are valid XML and disable App Sandbox for external-JDK workflow')
    for p in (ROOT / 'platform_overlays').rglob('Contents.json'):
        data = load(p)
        for image in data['images']:
            if 'filename' in image:
                assert (p.parent / image['filename']).is_file()
    checks.append('All Mac app icon manifest entries resolve')

    preserved = None
    if args.original:
        original = args.original / 'content'
        old_files = {p.relative_to(original).as_posix(): p for p in original.rglob('*') if p.is_file()}
        assert content.keys() == old_files.keys(), 'Course file set differs from original'
        for name, p in content.items():
            assert p.read_bytes() == old_files[name].read_bytes(), f'Content changed: {name}'
        preserved = len(content)
        checks.append(f'All {preserved} course files match the original C++ project byte-for-byte')

    fingerprint = hashlib.sha256()
    for name, p in sorted(content.items()):
        fingerprint.update(name.encode() + b'\x00' + p.read_bytes() + b'\x00')
    report = {'scope': 'Independent Python source/content checks, not Dart compilation',
              'checks_passed': len(checks), 'checks': checks,
              'chapters': len(course['chapters']), 'lessons': len(lessons),
              'published_lessons': sum(l['publication'] == 'published' for l in lessons),
              'planned_lessons': sum(l['publication'] == 'planned' for l in lessons),
              'lesson_exercises': len(exercises), 'projects': len(projects),
              'output_exercises': sum(e['validation']['type'] == 'output' for e in exercises),
              'output_cases': sum(len(e['validation'].get('cases', [])) for e in exercises),
              'content_files': len(content), 'preserved_content_files': preserved,
              'course_tree_sha256': fingerprint.hexdigest(),
              'flutter_build_executed': False}
    target = ROOT / 'docs/source-check-report.json'
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(json.dumps(report, indent=2, ensure_ascii=False) + '\n')
    for check in checks:
        print('PASS:', check)
    print(json.dumps({k: report[k] for k in ['chapters', 'published_lessons', 'planned_lessons', 'lesson_exercises', 'projects', 'output_cases']}))


if __name__ == '__main__':
    main()
