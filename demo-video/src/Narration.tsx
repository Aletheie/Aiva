import {Audio, Sequence, staticFile} from 'remotion';
import manifestJson from '../public/narration/manifest.json';
import {AUDIO_MIX} from './audioMix';

type NarrationManifest = {
  status: string;
  clips: Array<{
    id: string;
    src: string;
    from: number;
    durationInFrames: number;
  }>;
};

const narration: NarrationManifest = manifestJson;

/** Only real, successfully generated speech is included in the composition. */
export const Narration = () => narration.status !== 'ready' ? null : (
  <>
    {narration.clips.map((clip) => (
      <Sequence
        key={clip.id}
        from={clip.from}
        durationInFrames={clip.durationInFrames}
        name={`Narration: ${clip.id}`}
        layout="none"
      >
        <Audio src={staticFile(clip.src)} volume={AUDIO_MIX.narrationGain} />
      </Sequence>
    ))}
  </>
);
