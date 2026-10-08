import {Audio, interpolate, staticFile} from 'remotion';
import narration from '../public/narration/manifest.json';
import {AUDIO_MIX} from './audioMix';

const smoothstep = (t: number) => t * t * (3 - 2 * t);

/** Anticipate each spoken cue, then restore the bed without abrupt pumping. */
const musicVolume = (frame: number) => {
  let gain: number = AUDIO_MIX.musicGain;
  if (narration.status !== 'ready') return gain;
  for (const cue of narration.clips) {
    const end = cue.from + cue.durationInFrames;
    gain = Math.min(gain, interpolate(
      frame,
      [cue.from - AUDIO_MIX.duckAttackFrames, cue.from, end, end + AUDIO_MIX.duckReleaseFrames],
      [AUDIO_MIX.musicGain, AUDIO_MIX.musicUnderSpeechGain, AUDIO_MIX.musicUnderSpeechGain, AUDIO_MIX.musicGain],
      {extrapolateLeft: 'clamp', extrapolateRight: 'clamp', easing: smoothstep},
    ));
  }
  return gain;
};

export const Music = () => (
  <Audio src={staticFile('audio/aiva-bed.wav')} volume={musicVolume} />
);
