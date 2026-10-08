#!/usr/bin/env python3
"""Package editable sources and their real footage without local dependencies or profiles."""
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

root = Path(__file__).resolve().parents[1]
files = [root / name for name in [
    '.gitignore', '.env.example', 'README.md', 'package.json', 'package-lock.json',
    'tsconfig.json', 'remotion.config.ts', 'quality-review.json',
]]
for folder in ['src', 'public']:
    files.extend(p for p in (root / folder).rglob('*') if p.is_file() and p.name != '.DS_Store')
files.extend(p for p in (root / 'tools').iterdir() if p.suffix in ['.py', '.swift', '.mjs', '.md'])
files.append(root / 'capture' / 'main.dart')
files.extend((root / 'capture').glob('*-events.json'))
destination = root / 'aiva-remotion-project.zip'
with ZipFile(destination, 'w', ZIP_DEFLATED) as archive:
    for path in sorted(set(files)):
        archive.write(path, Path('demo-video') / path.relative_to(root))
with ZipFile(destination) as archive:
    assert archive.testzip() is None
print(f'{destination.name}: {len(files)} files, {destination.stat().st_size:,} bytes')
