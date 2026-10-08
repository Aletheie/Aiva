import type {CSSProperties} from 'react';
import {
  AbsoluteFill,
  Easing,
  interpolate,
  OffthreadVideo,
  Sequence,
  staticFile,
  useCurrentFrame,
} from 'remotion';
import {CAMERA, DEMO, SHOTS, type Caption, type Shot} from './edit';
import {RecordedCursor} from './RecordedCursor';
import {Narration} from './Narration';
import {Music} from './Music';

const screenScale = Math.min(
  DEMO.maxScreenWidth / DEMO.sourceWidth,
  DEMO.maxScreenHeight / DEMO.sourceHeight,
);
const screenWidth = DEMO.sourceWidth * screenScale;
const screenHeight = DEMO.sourceHeight * screenScale;
const screenLeft = (DEMO.width - screenWidth) / 2;
const screenTop = DEMO.screenCenterY - screenHeight / 2;
const clamp = {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'} as const;
// Smootherstep has zero velocity and acceleration at both ends, so the camera
// settles into its hold without a bump and returns without a change in pivot.
const smootherstep = (t: number) => t * t * t * (t * (t * 6 - 15) + 10);
const cameraFrames = CAMERA.map((keyframe) => keyframe.frame);
const cameraScales = CAMERA.map((keyframe) => keyframe.scale);

const screenStyle: CSSProperties = {
  position: 'absolute',
  left: screenLeft,
  top: screenTop,
  width: screenWidth,
  height: screenHeight,
  borderRadius: 13,
  overflow: 'hidden',
  background: '#101114',
  boxShadow: '0 20px 56px rgba(0, 0, 0, 0.3), 0 0 0 1px rgba(255,255,255,0.10)',
};

const FeatureCaption = ({caption}: {caption: Caption}) => {
  const frame = useCurrentFrame();
  const opacity = interpolate(
    frame,
    [0, 10, caption.durationInFrames - 9, caption.durationInFrames - 1],
    [0, 1, 1, 0],
    clamp,
  );
  const entrance = interpolate(frame, [0, 16], [0, 1], {
    ...clamp,
    easing: Easing.out(Easing.cubic),
  });

  return (
    <div
      style={{
        position: 'absolute',
        left: screenLeft + 2,
        top: 1008,
        height: 32,
        display: 'flex',
        alignItems: 'center',
        gap: 15,
        opacity,
        transform: `translateY(${8 * (1 - entrance)}px)`,
      }}
    >
      <div style={{width: 3, height: 21, background: '#84b7dc', borderRadius: 2}} />
      <span
        style={{
          color: '#dbe2ea',
          fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif',
          fontSize: 23,
          lineHeight: 1,
          fontWeight: 450,
          letterSpacing: 0.15,
        }}
      >
        {caption.text}
      </span>
    </div>
  );
};

const FootageShot = ({shot}: {shot: Shot}) => {
  const frame = useCurrentFrame();
  const opacity = shot.dissolveIn === 0 ? 1 : interpolate(
    frame,
    [0, shot.dissolveIn - 1],
    [0, 1],
    clamp,
  );

  return (
    <AbsoluteFill style={{opacity}}>
      <OffthreadVideo
        src={staticFile(shot.source)}
        trimBefore={shot.sourceIn}
        playbackRate={shot.playbackRate}
        muted
        pauseWhenBuffering
        style={{display: 'block', width: '100%', height: '100%', objectFit: 'contain'}}
      />
      {shot.cursorSource ? <RecordedCursor shot={{...shot, cursorSource: shot.cursorSource}} /> : null}
    </AbsoluteFill>
  );
};

export const AivaDemo = () => {
  const frame = useCurrentFrame();
  const scale = interpolate(frame, cameraFrames, cameraScales, {
    ...clamp,
    easing: smootherstep,
  });

  return (
    <AbsoluteFill style={{background: DEMO.background}}>
      <Narration />
      <Music />
      <div
        style={{
          ...screenStyle,
          transform: `scale(${scale})`,
          transformOrigin: '50% 50%',
        }}
      >
        {SHOTS.map((shot) => (
          <Sequence
            key={shot.id}
            from={shot.from}
            durationInFrames={shot.durationInFrames}
            premountFor={20}
            name={shot.id}
          >
            <FootageShot shot={shot} />
          </Sequence>
        ))}
      </div>
      {SHOTS.flatMap((shot) => shot.captions.map((caption) => (
        <Sequence
          key={`${shot.id}-${caption.text}`}
          from={shot.from + caption.from}
          durationInFrames={caption.durationInFrames}
          name={caption.text}
        >
          <FeatureCaption caption={caption} />
        </Sequence>
      )))}
    </AbsoluteFill>
  );
};
