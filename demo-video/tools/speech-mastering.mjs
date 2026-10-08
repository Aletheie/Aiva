import {spawnSync} from 'node:child_process';

const conditioning = 'highpass=f=65,acompressor=threshold=0.0631:ratio=2.5:attack=5:release=100:knee=2.8:makeup=1:detection=peak';
export const masteringSettings = {
  targetIntegratedLufs: -16,
  truePeakCeilingDbtp: -1.5,
  method: '65 Hz high-pass, gentle compression, measured gain, oversampled lookahead limiter',
  conditioning,
};

function ffmpeg(args) {
  const result = spawnSync('ffmpeg', ['-hide_banner', '-nostdin', '-nostats', ...args],
    {encoding: 'utf8', timeout: 120000, maxBuffer: 4 * 1024 * 1024});
  if (result.status !== 0) throw new Error(`Speech mastering failed: ${result.stderr || result.error?.message}`);
  return result.stderr;
}

export function measureSpeech(file, prefilter = '') {
  const filter = `${prefilter ? `${prefilter},` : ''}loudnorm=I=-16:TP=-1.5:LRA=7:print_format=json`;
  const log = ffmpeg(['-i', file, '-af', filter, '-f', 'null', '-']);
  const match = log.match(/\{\s*"input_i"[\s\S]*?\}/);
  if (!match) throw new Error('Missing loudness measurements.');
  const result = JSON.parse(match[0]);
  const integratedLufs = Number(result.input_i);
  const truePeakDbtp = Number(result.input_tp);
  if (!Number.isFinite(integratedLufs) || !Number.isFinite(truePeakDbtp)) throw new Error('Invalid speech measurements.');
  return {integratedLufs, truePeakDbtp};
}

export function masterSpeech(source, output) {
  const measured = measureSpeech(source, conditioning);
  const gain = masteringSettings.targetIntegratedLufs - measured.integratedLufs;
  // Fourfold oversampling and a small ceiling margin preserve true-peak headroom.
  // Latency compensation keeps the original cue placement and duration intact.
  const filter = `${conditioning},volume=${gain}dB,aresample=176400,` +
    'alimiter=limit=0.831764:attack=5:release=70:level=false:latency=true,aresample=44100';
  ffmpeg(['-n', '-i', source, '-af', filter, '-c:a', 'pcm_s24le', output]);
  return measureSpeech(output);
}
