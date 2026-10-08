#!/usr/bin/env python3
"""Copy approved takes and align measured native cursor samples to video time."""
import json
import shutil
from pathlib import Path

root = Path(__file__).resolve().parents[1]
for name, take in [('overview', 'overview'), ('lesson', 'lesson'), ('studio', 'studio-final')]:
    source = root / 'capture' / f'{take}-raw.mp4'
    metadata = json.loads(source.with_suffix('.mp4.json').read_text())
    trace = json.loads((root / 'capture' / f'{take}-cursor.json').read_text())
    offset = trace['startUnixSeconds'] - metadata['startedAt'] / 1_000_000
    samples = [dict(s, t=round(s['t'] + offset, 6)) for s in trace['samples']]
    destination = root / 'public' / 'footage'
    destination.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(source, destination / f'{name}.mp4')
    (destination / f'{name}-cursor.json').write_text(json.dumps(samples, separators=(',', ':')))
    print(f'{name}: {metadata["frames"]} frames, cursor offset {offset:.4f}s, {len(samples)} measured samples')
