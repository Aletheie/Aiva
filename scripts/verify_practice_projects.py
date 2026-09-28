#!/usr/bin/env python3
"""Verify the expanded Maven, Gradle, Git and handover practice in disposable folders.

Requires JDK 21, Maven 3.9 and Gradle 8.14.3. The first run can download build
dependencies. No student workspace or repository is modified. A reference is
an overlay on the shipped starter, exactly as a learner would apply a solution.
"""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def run(command, folder, env, success=True):
    result = subprocess.run(command, cwd=folder, env=env, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                            timeout=240)
    if success:
        require(result.returncode == 0, f"{' '.join(command)}\n{result.stdout[-8000:]}")
    return result


def copy_starter(identifier, destination, reference=False):
    shutil.copytree(ROOT / 'content/starters' / identifier, destination)
    if reference:
        shutil.copytree(ROOT / 'tests/java-solutions' / identifier,
                        destination, dirs_exist_ok=True)
    return destination


def reports(folder):
    suites = [ET.parse(p).getroot() for p in folder.glob('TEST-*.xml')]
    require(bool(suites), f'No test reports in {folder}')
    return {key: sum(int(s.attrib.get(key, 0)) for s in suites)
            for key in ('tests', 'failures', 'errors', 'skipped')}


def checked_tests(folder, expected):
    counts = reports(folder)
    require(counts == dict(tests=expected, failures=0, errors=0, skipped=0),
            f'Unexpected test counts: {counts}; expected {expected}')
    return counts['tests']


MAVEN_TESTS = {
    'ex-mission-blair-event-config': 6,
    'ex-mission-blair-newsletter-build': 3,
    'ex-mission-blair-publish-after-save': 3,
    'ex-mission-bonnie-roster-recovery': 6,
    'ex-mission-bridget-cancellation-tests': 7,
    'ex-mission-sally-bill-tests': 6,
    'ex-mission-spencer-evidence-json': 6,
    'ex-mission-marge-project-handover': 3,
}


def verify_maven(identifier, expected, temporary, command, env):
    folder = copy_starter(identifier, temporary / 'correct', reference=True)
    run(command, folder, env)
    counts = checked_tests(folder / 'target/surefire-reports', expected)
    result = dict(id=identifier, ok=True, tests=counts, rejected_variants=[])
    variants = sorted((folder / 'variants').glob('*.java.txt'))
    for number, variant in enumerate(variants):
        mutant = copy_starter(identifier, temporary / f'mutant-{number}', reference=True)
        target = next((mutant / 'src/main/java').glob('*.java'))
        target.write_text(variant.read_text())
        failed = run(command, mutant, env, success=False)
        require(failed.returncode != 0, f'Mutant passed: {variant.name}')
        require(reports(mutant / 'target/surefire-reports')['failures'] > 0,
                f'Mutant did not fail an assertion: {variant.name}')
        result['rejected_variants'].append(variant.name)
    if identifier.endswith('marge-project-handover'):
        clean = temporary / 'handover'
        clean.mkdir()
        for name in ('pom.xml', 'src', 'data', 'README.md', 'HANDOVER.md', '.gitignore'):
            source = folder / name
            if source.is_dir():
                shutil.copytree(source, clean / name)
            else:
                shutil.copyfile(source, clean / name)
        require(not (clean / 'target').exists(), 'Handover copied build output')
        before = (clean / 'data/pantry.csv').read_bytes()
        run(command, clean, env)
        checked_tests(clean / 'target/surefire-reports', expected)
        actual = run(['java', '-cp', 'target/classes', 'PantryReport', 'data/pantry.csv'], clean, env)
        require(actual.stdout.strip() == 'Rice: doplnit 3\nCoffee: doplnit 2', actual.stdout)
        require((clean / 'data/pantry.csv').read_bytes() == before, 'Input changed')
        result['clean_handover'] = True
    elif not variants:
        broken = copy_starter(identifier, temporary / 'broken')
        # Written tests are part of the reference for TDD tasks. Production and
        # build remain the shipped broken starter, in a folder without classes.
        reference_tests = ROOT / 'tests/java-solutions' / identifier / 'src/test'
        if reference_tests.exists():
            shutil.copytree(reference_tests, broken / 'src/test', dirs_exist_ok=True)
        failed = run(command, broken, env, success=False)
        require(failed.returncode != 0, f'Broken starter passed: {identifier}')
        result['broken_starter_rejected'] = True
    if identifier.endswith('blair-newsletter-build'):
        test = folder / 'src/test/java/NewsletterTest.java'
        test.write_text(test.read_text().replace('Opening night', 'Wrong expected', 1))
        failed = run(command, folder, env, success=False)
        require(failed.returncode != 0 and reports(folder / 'target/surefire-reports')['failures'] > 0,
                'Newsletter build did not run its deliberately failing test')
        result['failing_assertion_rejected'] = True
    return result


def verify_git_merge(temporary, env):
    identifier = 'ex-mission-serena-dan-merge'
    folder = copy_starter(identifier, temporary / 'merge')
    run(['bash', 'prepare.sh'], folder, env)
    lab = folder / 'merge-lab'
    initial = run(['git', 'rev-parse', 'HEAD'], lab, env).stdout
    repeated = run(['bash', 'prepare.sh'], folder, env, success=False)
    require(repeated.returncode != 0, 'Preparation overwrote an existing lab')
    require(run(['git', 'rev-parse', 'HEAD'], lab, env).stdout == initial, 'Lab changed')
    conflict = run(['git', 'merge', 'serena-edit'], lab, env, success=False)
    require(conflict.returncode != 0, 'Expected a real merge conflict')
    require('<<<<<<<' in (lab / 'Newsletter.java').read_text(), 'Missing conflict markers')
    shutil.copyfile(ROOT / 'tests/java-solutions' / identifier / 'Newsletter.java', lab / 'Newsletter.java')
    run(['javac', 'Newsletter.java', 'Check.java'], lab, env)
    require(run(['java', 'Check'], lab, env).stdout.strip() == '3 kontroly prosly', 'Merge behavior failed')
    run(['git', 'add', 'Newsletter.java'], lab, env)
    run(['git', 'commit', '-m', 'Spoj obe upravy newsletteru'], lab, env)
    require(len(run(['git', 'rev-list', '--parents', '-n', '1', 'HEAD'], lab, env).stdout.split()) == 3,
            'Merge commit does not have two parents')
    require(not run(['git', 'status', '--porcelain'], lab, env).stdout.strip(), 'Merge left a dirty tree')
    return dict(id=identifier, ok=True, java_checks=3, two_parents=True, preparation_preserves_existing=True)


def verify_git_staging(temporary, env):
    identifier = 'ex-mission-elizabeth-focused-commits'
    folder = copy_starter(identifier, temporary / 'staging')
    run(['bash', 'prepare.sh'], folder, env)
    lab = folder / 'staging-lab'
    private = (lab / 'notes.private.txt').read_bytes()
    require(run(['bash', 'prepare.sh'], folder, env, success=False).returncode != 0,
            'Preparation overwrote an existing lab')
    staged = run(['git', 'diff', '--cached'], lab, env).stdout
    working = run(['git', 'diff'], lab, env).stdout
    require('Prejudice' in staged and 'Little Women' not in staged, 'Wrong staged exercise state')
    require('Little Women' in working, 'Missing separate working-tree change')
    run(['git', 'commit', '-m', 'Oprav nazev Pride and Prejudice'], lab, env)
    first = run(['git', 'show', 'HEAD:catalog.csv'], lab, env).stdout
    require('Pride and Prejudice' in first and 'Little Women' not in first, 'First commit mixed changes')
    run(['git', 'add', 'catalog.csv', 'README.md'], lab, env)
    run(['git', 'commit', '-m', 'Dopln Little Women a popis katalogu'], lab, env)
    require('Little Women' in run(['git', 'show', 'HEAD:catalog.csv'], lab, env).stdout, 'Second commit missing book')
    require('Sloupce:' in run(['git', 'show', 'HEAD:README.md'], lab, env).stdout, 'Second commit missing docs')
    require(not run(['git', 'ls-files', 'notes.private.txt'], lab, env).stdout.strip(), 'Private notes tracked')
    require((lab / 'notes.private.txt').read_bytes() == private, 'Private notes changed')
    require(run(['git', 'status', '--porcelain'], lab, env).stdout.strip() == '?? notes.private.txt', 'Unexpected final status')
    return dict(id=identifier, ok=True, separate_commits=True, private_notes_preserved=True)


def verify_gradle(temporary, gradle, env):
    identifier = 'ex-mission-jill-reproducible-build'
    folder = copy_starter(identifier, temporary / 'gradle-correct', reference=True)
    command = [gradle, '--no-daemon', '--console=plain']
    run([*command, 'test'], folder, env)
    checked_tests(folder / 'build/test-results/test', 2)
    run([*command, 'wrapper', '--gradle-version', '8.14.3'], folder, env)
    for name in ('gradlew', 'gradlew.bat', 'gradle/wrapper/gradle-wrapper.jar', 'gradle/wrapper/gradle-wrapper.properties'):
        require((folder / name).is_file(), f'Wrapper missing {name}')
    run(['bash', 'gradlew', '--no-daemon', '--console=plain', 'clean', 'test'], folder, env)
    checked_tests(folder / 'build/test-results/test', 2)
    test = folder / 'src/test/java/SupplyKitTest.java'
    test.write_text(test.read_text().replace('assertEquals(2,', 'assertEquals(99,', 1))
    failed = run(['bash', 'gradlew', '--no-daemon', '--console=plain', 'test'], folder, env, success=False)
    require(failed.returncode != 0 and reports(folder / 'build/test-results/test')['failures'] > 0,
            'Wrapper ignored deliberately failing test')
    broken = copy_starter(identifier, temporary / 'gradle-broken')
    require(run([*command, 'test'], broken, env, success=False).returncode != 0, 'Broken release passed')
    build = broken / 'build.gradle.kts'
    build.write_text(build.read_text().replace('options.release.set(8)', 'options.release.set(21)'))
    # The second defect really does yield a successful build with no test report.
    skipped = run([*command, 'test'], broken, env)
    require('test SKIPPED' in skipped.stdout, 'Fixture did not demonstrate skipped tests')
    require(not list((broken / 'build/test-results/test').glob('TEST-*.xml')), 'Skipped test created a report')
    return dict(id=identifier, ok=True, tests=2, wrapper_verified=True,
                failing_assertion_rejected=True, both_build_defects_verified=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--java-home', required=True, type=Path)
    parser.add_argument('--maven', default='mvn')
    parser.add_argument('--maven-repo', type=Path)
    parser.add_argument('--gradle', default='gradle')
    parser.add_argument('--gradle-home', type=Path)
    parser.add_argument('--only', choices=['maven', 'git', 'gradle'])
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    env = os.environ.copy()
    env.update(JAVA_HOME=str(args.java_home), PATH=str(args.java_home / 'bin') + os.pathsep + env['PATH'],
               GIT_CONFIG_NOSYSTEM='1', GIT_CONFIG_GLOBAL=os.devnull)
    if args.gradle_home:
        env['GRADLE_USER_HOME'] = str(args.gradle_home)
    maven = [args.maven, '-B', '-q']
    if args.maven_repo:
        maven.append('-Dmaven.repo.local=' + str(args.maven_repo))
    maven.append('test')
    results = []

    def check(label, callback):
        try:
            with tempfile.TemporaryDirectory(prefix='aiva-practice-') as folder:
                result = callback(Path(folder))
        except (AssertionError, OSError, subprocess.TimeoutExpired) as error:
            result = dict(id=label, ok=False, error=str(error))
        results.append(result)
        print(json.dumps(result, ensure_ascii=False), flush=True)

    if args.only in (None, 'maven'):
        for identifier, expected in MAVEN_TESTS.items():
            check(identifier, lambda folder, i=identifier, n=expected: verify_maven(i, n, folder, maven, env))
    if args.only in (None, 'git'):
        check('ex-mission-serena-dan-merge', lambda folder: verify_git_merge(folder, env))
        check('ex-mission-elizabeth-focused-commits', lambda folder: verify_git_staging(folder, env))
    if args.only in (None, 'gradle'):
        check('ex-mission-jill-reproducible-build', lambda folder: verify_gradle(folder, args.gradle, env))
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(results, ensure_ascii=False, indent=2) + '\n')
    return 0 if all(r['ok'] for r in results) else 1


if __name__ == '__main__':
    raise SystemExit(main())
