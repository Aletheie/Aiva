import {Composition} from 'remotion';
import {AivaDemo} from './AivaDemo';
import {DEMO} from './edit';

export const RemotionRoot = () => (
  <Composition
    id="AivaDemo"
    component={AivaDemo}
    width={DEMO.width}
    height={DEMO.height}
    fps={DEMO.fps}
    durationInFrames={DEMO.durationInFrames}
  />
);
