/** Linear gain. Speech is mastered separately to -16 LUFS / -1.5 dBTP. */
export const AUDIO_MIX = {
  narrationGain: 1,
  musicGain: 0.84,
  musicUnderSpeechGain: 0.42,
  duckAttackFrames: 9,
  duckReleaseFrames: 18,
} as const;
