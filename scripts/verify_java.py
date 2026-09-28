#!/usr/bin/env python3
"""Developer-only reference-solution checks; never used by the installed application."""
from __future__ import annotations
import argparse
import concurrent.futures
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import time


def normalized(text: str) -> str:
    text = text.replace('\r\n', '\n').replace('\r', '\n')
    return text[:-1] if text.endswith('\n') else text


def verify(exercise: dict, root: Path, javac: str, java: str) -> dict:
    start = time.monotonic()
    identifier = exercise['id']
    solution = root / 'tests' / 'java-solutions' / identifier / 'src' / 'main' / 'java'
    sources = sorted(solution.rglob('*.java'))
    if not sources:
        return {'id': identifier, 'ok': False, 'error': 'Missing reference solution'}
    env = os.environ.copy()
    for key in ('JAVA_TOOL_OPTIONS', '_JAVA_OPTIONS', 'JDK_JAVA_OPTIONS', 'CLASSPATH'):
        env.pop(key, None)
    try:
        with tempfile.TemporaryDirectory(prefix='aiva fixture ') as directory:
            work = Path(directory)
            classes = work / 'classes'
            classes.mkdir()
            check = exercise['validation']
            compile_result = subprocess.run(
                [javac, '-J-Xmx128m', '-encoding', 'UTF-8', '--release', str(check['javaRelease']),
                 '-proc:none', '-classpath', str(classes), '-d', str(classes), *map(str, sources)],
                capture_output=True, text=True, encoding='utf-8', errors='replace', timeout=20, env=env,
            )
            if compile_result.returncode:
                return {'id': identifier, 'ok': False, 'error': compile_result.stdout + compile_result.stderr}
            for index, case in enumerate(check['cases'], 1):
                result = subprocess.run(
                    [java, '-Xmx128m', '-Dfile.encoding=UTF-8', '-Duser.language=en', '-Duser.country=US',
                     '-cp', str(classes), check['mainClass']], input=case['input'], cwd=work, env=env,
                    capture_output=True, text=True, encoding='utf-8', errors='replace',
                    timeout=max(4, check['timeoutMs'] / 1000),
                )
                if result.returncode or normalized(result.stdout) != normalized(case['expected']):
                    return {'id': identifier, 'ok': False, 'case': index, 'returncode': result.returncode,
                            'expected': case['expected'], 'stdout': result.stdout, 'stderr': result.stderr}
            return {'id': identifier, 'ok': True, 'cases': len(check['cases']),
                    'seconds': round(time.monotonic() - start, 3)}
    except (OSError, subprocess.TimeoutExpired) as error:
        return {'id': identifier, 'ok': False, 'error': str(error)}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument('--report', type=Path)
    parser.add_argument('--jobs', type=int, default=3)
    args = parser.parse_args()
    javac, java = shutil.which('javac'), shutil.which('java')
    if not javac or not java:
        parser.error('JDK 21+ (java and javac) must be on PATH')
    exercises = []
    for file in sorted((args.root / 'content' / 'lessons').glob('*.json')):
        lesson = json.loads(file.read_text(encoding='utf-8'))
        exercises += [e for e in lesson.get('exercises', []) if e['validation']['type'] == 'output']
    if not exercises:
        parser.error('No output-validated exercises found')
    results = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=max(1, min(args.jobs, 4))) as pool:
        futures = [pool.submit(verify, exercise, args.root, javac, java) for exercise in exercises]
        for future in concurrent.futures.as_completed(futures):
            result = future.result()
            results.append(result)
            print(('PASS ' if result['ok'] else 'FAIL ') + result['id'], flush=True)
            if not result['ok']:
                print(json.dumps(result, ensure_ascii=False, indent=2), flush=True)
    report = {'kind': 'Java reference-solution checks (not Dart process-runner tests)',
              'java': subprocess.run([java, '--version'], capture_output=True, text=True, timeout=5).stdout.strip(),
              'passed': sum(r['ok'] for r in results), 'failed': sum(not r['ok'] for r in results),
              'test_cases': sum(r.get('cases', 0) for r in results),
              'results': sorted(results, key=lambda r: r['id'])}
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f"{report['passed']} solutions passed, {report['failed']} failed, {report['test_cases']} cases")
    return 1 if report['failed'] else 0


if __name__ == '__main__':
    raise SystemExit(main())
