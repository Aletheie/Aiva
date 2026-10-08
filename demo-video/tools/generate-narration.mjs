#!/usr/bin/env node
// Official API: https://elevenlabs.io/docs/api-reference/text-to-speech/convert
// Voice selection: https://elevenlabs.io/docs/api-reference/voices/search
import {readFile, writeFile, mkdir, mkdtemp, rename} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
import {randomUUID} from 'node:crypto';
import {execFileSync} from 'node:child_process';
import {masterSpeech, masteringSettings} from './speech-mastering.mjs';

const root = fileURLToPath(new URL('../', import.meta.url));
const narration = path.join(root, 'public/narration');
const args = new Set(process.argv.slice(2));
const allowed = new Set(['--dry-run', '--list-voices', '--master', '--help']);
let apiKey = '';
let staging;

function ensure(condition, message) {
  if (!condition) throw new Error(message);
}

function redact(value) {
  return apiKey ? String(value).split(apiKey).join('[REDACTED]') : String(value);
}

// This is a data parser, never a shell evaluation. Only expected keys are read.
async function credentials() {
  const local = {};
  for (const filename of ['.env', '.env.local']) {
   try {
    const text = await readFile(path.join(root, filename), 'utf8');
    for (const line of text.split(/\r?\n/)) {
      const match = line.match(/^\s*(?:export\s+)?(ELEVENLABS_API_KEY|ELEVEN_API_KEY|ELEVENLABS_VOICE_ID)\s*=\s*(.*?)\s*$/);
      if (!match) continue;
      let value = match[2];
      if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
        value = value.slice(1, -1);
      } else {
        value = value.replace(/\s+#.*$/, '').trim();
      }
      local[match[1]] = value;
    }
   } catch (error) {
    if (error.code !== 'ENOENT') throw new Error(`Could not read demo-video/${filename}.`);
   }
  }
  apiKey = process.env.ELEVENLABS_API_KEY || process.env.ELEVEN_API_KEY || local.ELEVENLABS_API_KEY || local.ELEVEN_API_KEY || '';
  const voiceId = process.env.ELEVENLABS_VOICE_ID || local.ELEVENLABS_VOICE_ID || '';
  ensure(apiKey, 'Set ELEVENLABS_API_KEY in the environment or demo-video/.env / .env.local. No API request was made.');
  return {voiceId};
}

function validate(config) {
  ensure(config.version === 1 && config.fps === 30 && config.durationInFrames === 600, 'Narration must use version 1, 30 fps, and 600 frames.');
  ensure(config.modelId === 'eleven_multilingual_v2', 'Expected modelId eleven_multilingual_v2.');
  ensure(config.outputFormat === 'mp3_44100_128', 'Expected outputFormat mp3_44100_128.');
  ensure(Array.isArray(config.cues) && config.cues.length > 0, 'At least one narration cue is required.');
  const settings = config.voiceSettings;
  ensure(settings && typeof settings === 'object', 'voiceSettings are required.');
  for (const key of ['stability', 'similarity_boost', 'style']) {
    ensure(Number.isFinite(settings[key]) && settings[key] >= 0 && settings[key] <= 1, `Invalid voice setting: ${key}`);
  }
  ensure(typeof settings.use_speaker_boost === 'boolean', 'use_speaker_boost must be boolean.');
  ensure(Number.isFinite(settings.speed) && settings.speed >= 0.7 && settings.speed <= 1.2, 'Voice speed must be between 0.7 and 1.2.');
  const ids = new Set();
  let end = 0;
  for (const cue of config.cues) {
    ensure(typeof cue.id === 'string' && /^[a-z][a-z0-9-]*$/.test(cue.id) && !ids.has(cue.id), 'Cue IDs must be unique lowercase filename-safe identifiers.');
    ids.add(cue.id);
    ensure(Number.isInteger(cue.from) && cue.from >= end, `Cue ${cue.id} overlaps a previous slot or has an invalid start.`);
    ensure(Number.isInteger(cue.maxFrames) && cue.maxFrames > 0, `Invalid duration slot for ${cue.id}.`);
    end = cue.from + cue.maxFrames;
    ensure(end <= config.durationInFrames, `Cue ${cue.id} exceeds the 20-second composition.`);
    ensure(typeof cue.text === 'string' && cue.text.trim().length > 0, `Cue ${cue.id} has no text.`);
  }
}

async function api(url, options = {}) {
  const response = await fetch(url, {
    ...options,
    headers: {'xi-api-key': apiKey, ...options.headers},
    signal: AbortSignal.timeout(120_000),
    redirect: 'error',
  });
  if (!response.ok) {
    // Do not print response bodies or request headers: neither is needed to debug credentials.
    throw new Error(`ElevenLabs returned HTTP ${response.status}. Check key permissions, selected voice availability, and account quota. No manifest was changed.`);
  }
  return response;
}

async function listVoices() {
  const voices = [];
  const seen = new Set();
  let token;
  do {
    const url = new URL('https://api.elevenlabs.io/v2/voices');
    url.searchParams.set('page_size', '100');
    if (token) url.searchParams.set('next_page_token', token);
    const data = await (await api(url)).json();
    ensure(Array.isArray(data.voices), 'Unexpected voice-list response.');
    voices.push(...data.voices.map(({voice_id, name, category, labels, description, preview_url}) => ({
      voice_id, name, category, labels, description, preview_url,
    })));
    if (!data.has_more) break;
    ensure(data.next_page_token && !seen.has(data.next_page_token), 'Invalid voice-list pagination.');
    token = data.next_page_token;
    seen.add(token);
  } while (token);
  console.log(JSON.stringify({voices}, null, 2));
}

function tool(command, parameters) {
  try {
    return execFileSync(command, parameters, {encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'], timeout: 120_000, maxBuffer: 4 * 1024 * 1024});
  } catch (error) {
    if (error.code === 'ENOENT') throw new Error(`${command} is required and was not found on PATH.`);
    throw new Error(`${command} failed: ${redact(error.stderr || error.message).slice(-1800)}`);
  }
}

function duration(file) {
  const result = JSON.parse(tool('ffprobe', ['-v', 'error', '-show_entries', 'format=duration', '-of', 'json', file]));
  const seconds = Number(result.format?.duration);
  ensure(Number.isFinite(seconds) && seconds > 0, 'Generated audio has no valid duration.');
  return seconds;
}

function fits(cue, seconds, fps) {
  const frames = Math.ceil(seconds * fps);
  ensure(frames <= cue.maxFrames,
    `${cue.id} is ${seconds.toFixed(3)}s (${frames} frames), exceeding its ${cue.maxFrames / fps}s slot. Shorten its text or revise the slot and regenerate; audio was not truncated.`);
  return frames;
}

async function main() {
  for (const arg of args) ensure(allowed.has(arg), `Unknown option: ${arg}`);
  if (args.has('--help')) {
    console.log('Usage: node demo-video/tools/generate-narration.mjs [--dry-run | --list-voices] [--master]\nCredentials: ELEVENLABS_API_KEY and explicit ELEVENLABS_VOICE_ID, from environment or demo-video/.env / .env.local.\n--master conditions and masters speech toward -16 LUFS / -1.5 dBTP, retaining original MP3s.');
    return;
  }
  ensure(!(args.has('--dry-run') && args.has('--list-voices')), 'Choose --dry-run or --list-voices.');
  const config = JSON.parse(await readFile(path.join(narration, 'script.json'), 'utf8'));
  validate(config);
  if (args.has('--dry-run')) {
    console.log(JSON.stringify({valid: true, networkRequests: 0, durationSeconds: 20,
      cues: config.cues.map(c => ({id: c.id, at: c.from / config.fps, maxSeconds: c.maxFrames / config.fps, text: c.text}))}, null, 2));
    return;
  }
  const {voiceId} = await credentials();
  if (args.has('--list-voices')) { await listVoices(); return; }
  ensure(voiceId && /^[A-Za-z0-9_-]+$/.test(voiceId), 'Set an available ELEVENLABS_VOICE_ID explicitly. Use --list-voices to inspect your account; no voice was selected automatically.');
  tool('ffprobe', ['-version']);
  if (args.has('--master')) tool('ffmpeg', ['-version']);
  await mkdir(path.join(root, '.narration-staging'), {recursive: true});
  staging = await mkdtemp(path.join(root, '.narration-staging/take-'));
  await mkdir(path.join(staging, 'sources'));
  const generation = `${new Date().toISOString().replace(/[:.]/g, '-')}-${randomUUID().slice(0, 8)}`;
  const publicPrefix = `narration/generated/${generation}`;
  const clips = [];
  for (let i = 0; i < config.cues.length; i++) {
    const cue = config.cues[i];
    console.log(`Generating ${cue.id} (${cue.maxFrames / config.fps}s available)…`);
    const body = {text: cue.text, model_id: config.modelId, voice_settings: config.voiceSettings,
      ...(i > 0 ? {previous_text: config.cues[i - 1].text} : {}),
      ...(i + 1 < config.cues.length ? {next_text: config.cues[i + 1].text} : {})};
    const url = `https://api.elevenlabs.io/v1/text-to-speech/${encodeURIComponent(voiceId)}?output_format=${config.outputFormat}`;
    const response = await api(url, {method: 'POST', headers: {'Content-Type': 'application/json', 'Accept': 'audio/mpeg'}, body: JSON.stringify(body)});
    const source = path.join(staging, 'sources', `${cue.id}.mp3`);
    await writeFile(source, Buffer.from(await response.arrayBuffer()));
    const sourceSeconds = duration(source);
    fits(cue, sourceSeconds, config.fps);
    let output = source;
    let filename = `sources/${cue.id}.mp3`;
    if (args.has('--master')) {
      filename = `${cue.id}.wav`;
      output = path.join(staging, filename);
      masterSpeech(source, output);
    }
    const seconds = duration(output);
    const frames = fits(cue, seconds, config.fps);
    clips.push({id: cue.id, src: `${publicPrefix}/${filename}`, from: cue.from, durationInFrames: frames,
      durationSeconds: seconds, text: cue.text, source: `${publicPrefix}/sources/${cue.id}.mp3`});
    console.log(`Validated ${cue.id}: ${seconds.toFixed(3)}s / ${frames} frames.`);
  }
  const manifest = {status: 'ready', version: 1, fps: config.fps, durationInFrames: config.durationInFrames,
    provider: 'ElevenLabs', modelId: config.modelId, voiceId, voiceName: config.voiceName, generatedAt: new Date().toISOString(),
    mastering: args.has('--master') ? masteringSettings : null, clips};
  await writeFile(path.join(staging, 'generation.json'), JSON.stringify(manifest, null, 2) + '\n');
  await mkdir(path.join(narration, 'generated'), {recursive: true});
  await rename(staging, path.join(narration, 'generated', generation));
  staging = undefined;
  const pendingManifest = path.join(narration, `.manifest-${randomUUID()}.json`);
  await writeFile(pendingManifest, JSON.stringify(manifest, null, 2) + '\n');
  await rename(pendingManifest, path.join(narration, 'manifest.json'));
  console.log(`Narration ready: all ${clips.length} clips fit. Published public/narration/manifest.json.`);
}

main().catch(error => {
  console.error(redact(error.message));
  if (staging) console.error(`Generated source audio retained for review in ${path.relative(root, staging)}; the active manifest was not changed.`);
  process.exitCode = 1;
});
