#!/usr/bin/env node
// Remove AAC encoder padding from the container while retaining all 600 video frames.
import {execFileSync} from 'node:child_process';
import {renameSync} from 'node:fs';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
import {randomUUID} from 'node:crypto';

const root = fileURLToPath(new URL('../', import.meta.url));
const output = path.join(root, 'aiva-demo.mp4');
const inspect = file => JSON.parse(execFileSync('ffprobe', ['-v', 'error', '-show_entries',
  'stream=codec_type,width,height,r_frame_rate,nb_frames,duration:format=duration', '-of', 'json', file], {encoding: 'utf8'}));
const original = inspect(output);
const video = original.streams.find(stream => stream.codec_type === 'video');
if (video?.width !== 1920 || video.height !== 1080 || video.r_frame_rate !== '30/1' || video.nb_frames !== '600') {
  throw new Error('Expected a complete 600-frame AIVA composition.');
}
if (Number(original.format.duration) !== 20) {
  const temporary = path.join(root, `.aiva-final-${randomUUID()}.mp4`);
  execFileSync('ffmpeg', ['-hide_banner', '-loglevel', 'error', '-nostdin', '-n', '-i', output,
    '-map', '0:v:0', '-map', '0:a:0', '-c:v', 'copy',
    '-af', 'atrim=duration=20,asetpts=N/SR/TB', '-c:a', 'aac', '-b:a', '320k',
    '-t', '20', '-movflags', '+faststart', temporary], {stdio: 'inherit'});
  const final = inspect(temporary);
  if (Number(final.format.duration) !== 20 || final.streams.some(stream => Number(stream.duration) !== 20)) {
    throw new Error('Final audio/video duration did not resolve to exactly 20 seconds.');
  }
  renameSync(temporary, output);
}
console.log('Final MP4: exactly 20.000 seconds, 600 video frames; audio padding removed.');
