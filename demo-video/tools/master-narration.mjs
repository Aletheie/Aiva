#!/usr/bin/env node
// Remaster existing ElevenLabs takes offline; no requests or additional credits.
import {readFile, writeFile, mkdir, mkdtemp, rename} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
import {execFileSync} from 'node:child_process';
import {masterSpeech, masteringSettings} from './speech-mastering.mjs';

const root = fileURLToPath(new URL('../', import.meta.url));
const manifestPath = path.join(root, 'public/narration/manifest.json');
const manifest = JSON.parse(await readFile(manifestPath, 'utf8'));
if (manifest.status !== 'ready') throw new Error('Generate narration before mastering it.');
await mkdir(path.join(root, '.narration-staging'), {recursive: true});
const staging = await mkdtemp(path.join(root, '.narration-staging/master-'));
const outputs = [];
for (const clip of manifest.clips) {
  if (!clip.src.endsWith('.wav')) throw new Error('Expected WAV destinations.');
  const output = path.join(staging, `${clip.id}.wav`);
  const levels = masterSpeech(path.join(root, 'public', clip.source), output);
  const probe = JSON.parse(execFileSync('ffprobe', ['-v', 'error', '-show_entries', 'format=duration', '-of', 'json', output], {encoding: 'utf8'}));
  const duration = Number(probe.format.duration);
  if (Math.abs(duration - clip.durationSeconds) > 0.002) throw new Error(`Duration changed for ${clip.id}.`);
  // Sub-second phrases have less stable integrated measurements; keep all cues
  // within 1 LU of the target while preserving the limiter's peak headroom.
  if (levels.truePeakDbtp > -1.3 || Math.abs(levels.integratedLufs + 16) > 1) throw new Error(`Levels need review: ${clip.id}: ${JSON.stringify(levels)}`);
  clip.measuredLevels = levels;
  outputs.push([output, path.join(root, 'public', clip.src)]);
  console.log(`${clip.id}: ${levels.integratedLufs} LUFS, ${levels.truePeakDbtp} dBTP`);
}
for (const [source, destination] of outputs) await rename(source, destination);
manifest.mastering = masteringSettings;
await writeFile(manifestPath, JSON.stringify(manifest, null, 2) + '\n');
console.log('All six original cues mastered offline; timing and original speech preserved.');
