#!/usr/bin/env python3
"""Prepare an isolated, fresh AIVA recording profile while AIVA is stopped.

Both destinations must be inside this demo-video directory. The profile must
already have been initialized by the real application. No learning history or
completion records are manufactured. The exercise starts with its first three
syntax errors corrected; the final println is entered in the recorded app.
"""

import argparse
import json
import os
from pathlib import Path
import re
import shutil
import sqlite3
import subprocess


DEMO_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = DEMO_ROOT.parent
EXERCISE_ID = "ex-hello-escape-room"


def capture_path(value: str, name: str) -> Path:
    path = Path(value).expanduser().resolve()
    if not path.is_relative_to(DEMO_ROOT) or path == DEMO_ROOT:
        raise ValueError(f"{name} must be a dedicated path within {DEMO_ROOT}")
    return path


def find_jdk() -> Path | None:
    """Prefer JDK 25, then 21; verify java and javac without installing tools."""
    candidates = []
    for key in ("JAVA_HOME", "JDK_HOME"):
        if os.environ.get(key):
            candidates.append(Path(os.environ[key]))
    for root in (
        Path("/Library/Java/JavaVirtualMachines"),
        Path.home() / "Library/Java/JavaVirtualMachines",
    ):
        candidates.extend(root.glob("*/Contents/Home"))
    for root in (Path("/Applications"), Path.home() / "Applications"):
        for app in ("IntelliJ IDEA", "IntelliJ IDEA CE", "Android Studio", "PyCharm"):
            candidates.append(root / f"{app}.app/Contents/jbr/Contents/Home")
    for root in (Path("/opt/homebrew/opt"), Path("/usr/local/opt")):
        for name in ("openjdk@25", "openjdk@21", "openjdk"):
            candidates.append(root / name / "libexec/openjdk.jdk/Contents/Home")
    found = []
    for candidate in dict.fromkeys(path.resolve() for path in candidates):
        try:
            release = (candidate / "release").read_text()
            match = re.search(r'^JAVA_VERSION="(\d+)', release, re.MULTILINE)
            if match is None or int(match.group(1)) not in (21, 25):
                continue
            for binary in ("java", "javac"):
                subprocess.run(
                    [str(candidate / "bin" / binary), "--version"],
                    check=True,
                    capture_output=True,
                    timeout=10,
                )
            found.append((int(match.group(1)), candidate))
        except (OSError, subprocess.SubprocessError):
            continue
    return max(found, key=lambda item: item[0])[1] if found else None


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--profile", required=True, help="Existing isolated AIVA profile directory")
    parser.add_argument("--workspace", required=True, help="New, nonexistent capture workspace root")
    args = parser.parse_args()
    profile = capture_path(args.profile, "Profile")
    workspace = capture_path(args.workspace, "Workspace")
    if workspace.exists() or workspace.is_symlink():
        parser.error(f"Refusing to overwrite existing workspace: {workspace}")
    if workspace.is_relative_to(profile) or profile.is_relative_to(workspace):
        parser.error("Profile and workspace must be separate directories")
    database = capture_path(str(profile / "progress.sqlite"), "Profile database")
    if not database.is_file():
        parser.error("Launch and stop AIVA with this AIVA_PROFILE first; progress.sqlite must exist")

    starter = REPO_ROOT / "content/starters" / EXERCISE_ID
    source_file = starter / "src/main/java/Main.java"
    source = source_file.read_text(encoding="utf-8")
    fixes = (
        ('System.out.println("UNIKOVA HRA")\n', 'System.out.println("UNIKOVA HRA");\n'),
        ('System.out.Println("Dvere jsou zamcene.");', 'System.out.println("Dvere jsou zamcene.");'),
        ('System.out.println("Na zdi je napis: "Najdi klic."");',
         'System.out.println("Na zdi je napis: \\"Najdi klic.\\"");'),
        ('// Doplň závěrečnou výzvu hráči.', ''),
    )
    for before, after in fixes:
        if source.count(before) != 1:
            parser.error(f"Starter changed; expected exactly one occurrence of {before!r}")
        source = source.replace(before, after, 1)

    settings = {
        "workspace": str(workspace),
        "exerciseEditorMode": "embedded",
        "theme": "light",
        "executionConsent": "yes",
    }
    jdk = find_jdk()
    if jdk is not None:
        settings["jdkHome"] = str(jdk)
    server = Path("/private/tmp/aiva-jdtls-live")
    if server.is_dir():
        settings["javaLanguageServerPath"] = str(server)

    # mode=rw prevents accidentally creating a new, incompatible database.
    connection = sqlite3.connect(database.as_uri() + "?mode=rw", uri=True, timeout=2)
    try:
        connection.execute("BEGIN IMMEDIATE")
        tables = {
            row[0] for row in connection.execute(
                "SELECT name FROM sqlite_master WHERE type='table'"
            )
        }
        if not {"settings", "lesson_progress", "exercise_progress", "recent_lessons"} <= tables:
            raise ValueError("Profile does not have the expected initialized AIVA schema")
        for table in ("lesson_progress", "exercise_progress", "recent_lessons"):
            if connection.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]:
                raise ValueError("Refusing to prepare a profile with existing learning history")
        # mkdir has exist_ok=False intentionally: an existing workspace is never changed.
        workspace.mkdir(parents=True, exist_ok=False)
        destination = workspace / EXERCISE_ID
        shutil.copytree(starter, destination)
        (destination / "src/main/java/Main.java").write_text(source, encoding="utf-8")
        (destination / ".aiva-workspace.json").write_text(
            json.dumps({"schemaVersion": 1, "exercise": EXERCISE_ID}) + "\n",
            encoding="utf-8",
        )
        connection.executemany(
            "INSERT INTO settings(key,value) VALUES(?,?) "
            "ON CONFLICT(key) DO UPDATE SET value=excluded.value",
            settings.items(),
        )
        connection.commit()
    except Exception:
        connection.rollback()
        # Preserve any partially created fixture for inspection; never delete files.
        raise
    finally:
        connection.close()

    print(json.dumps({
        "profile": str(profile),
        "exercise": str(destination),
        "jdkHome": str(jdk) if jdk else "Use AIVA automatic discovery",
        "settings": settings,
        "captureAction": 'Type System.out.println("Tvuj tah!"); on the indented blank line 6',
        "learningHistory": "Unmodified; no lesson, exercise or lastLesson records seeded",
    }, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
