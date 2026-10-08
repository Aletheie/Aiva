import {useEffect, useState} from 'react';
import {cancelRender, continueRender, delayRender, staticFile, useCurrentFrame} from 'remotion';
import {DEMO, type Shot} from './edit';

/** Recorded native pointer samples. t is seconds from the source take's start. */
type CursorSample = {t: number; x: number; y: number; down: boolean};
type CursorRecording = {samples: CursorSample[]; clicks: CursorSample[]};

const parseRecording = (data: unknown): CursorRecording => {
  if (!Array.isArray(data)) throw new Error('Cursor telemetry must be an array of recorded samples.');
  const samples = data as CursorSample[];
  for (let index = 0; index < samples.length; index++) {
    const sample = samples[index];
    if (
      !sample ||
      !Number.isFinite(sample.t) ||
      !Number.isFinite(sample.x) ||
      !Number.isFinite(sample.y) ||
      typeof sample.down !== 'boolean' ||
      (index > 0 && sample.t < samples[index - 1].t)
    ) {
      throw new Error(`Invalid or out-of-order cursor telemetry at sample ${index}.`);
    }
  }
  return {
    samples,
    // A held button creates one accent, never a continuous sequence of clicks.
    clicks: samples.filter((sample, index) => index > 0 && sample.down && !samples[index - 1].down),
  };
};

const sampleCursor = (samples: CursorSample[], seconds: number) => {
  if (samples.length === 0 || seconds < samples[0].t) return null;
  let low = 0;
  let high = samples.length - 1;
  while (low < high) {
    const middle = Math.ceil((low + high) / 2);
    if (samples[middle].t <= seconds) low = middle;
    else high = middle - 1;
  }
  const before = samples[low];
  const after = samples[low + 1];
  if (!after || after.t === before.t) return before;
  const amount = Math.min(1, (seconds - before.t) / (after.t - before.t));
  return {
    x: before.x + (after.x - before.x) * amount,
    y: before.y + (after.y - before.y) * amount,
  };
};

/**
 * Replays measured native pointer positions over app-rendered footage. No
 * autonomous animation or generated pointer path is used. This layer lives
 * inside the footage camera so its coordinates follow every zoom and pan.
 */
export const RecordedCursor = ({shot}: {shot: Shot & {cursorSource: string}}) => {
  const frame = useCurrentFrame();
  const [recording, setRecording] = useState<CursorRecording | null>(null);
  const [handle] = useState(() => delayRender(`Loading recorded cursor: ${shot.cursorSource}`));

  useEffect(() => {
    const controller = new AbortController();
    fetch(staticFile(shot.cursorSource), {signal: controller.signal})
      .then((response) => {
        if (!response.ok) throw new Error(`Could not load recorded cursor ${shot.cursorSource}: ${response.status}`);
        return response.json() as Promise<unknown>;
      })
      .then((data) => {
        setRecording(parseRecording(data));
        continueRender(handle);
      })
      .catch((error: unknown) => {
        if (!controller.signal.aborted) cancelRender(error);
      });
    return () => {
      controller.abort();
      continueRender(handle);
    };
  }, [handle, shot.cursorSource]);

  if (!recording) return null;
  const seconds = (shot.sourceIn + frame * shot.playbackRate) / DEMO.fps + (shot.cursorTimeOffsetSeconds ?? 0);
  const cursor = sampleCursor(recording.samples, seconds);
  const offsetX = shot.cursorOffsetX ?? 0;
  const offsetY = shot.cursorOffsetY ?? 0;
  const x = cursor ? cursor.x + offsetX : -100;
  const y = cursor ? cursor.y + offsetY : -100;
  const inside = cursor && x >= 0 && y >= 0 && x < DEMO.sourceWidth && y < DEMO.sourceHeight;
  const clicks = recording.clicks.filter((sample) => seconds >= sample.t && seconds < sample.t + 0.32);

  return (
    <svg
      viewBox={`0 0 ${DEMO.sourceWidth} ${DEMO.sourceHeight}`}
      aria-hidden
      style={{position: 'absolute', inset: 0, width: '100%', height: '100%', pointerEvents: 'none', overflow: 'hidden'}}
    >
      {clicks.map((click) => {
        const progress = (seconds - click.t) / 0.32;
        return (
          <circle
            key={click.t}
            cx={click.x + offsetX}
            cy={click.y + offsetY}
            r={8 + progress * 12}
            fill="none"
            stroke="#477bb3"
            strokeWidth={1.4}
            opacity={0.35 * (1 - progress)}
          />
        );
      })}
      {inside ? (
        <g transform={`translate(${x}, ${y})`} style={{filter: 'drop-shadow(0 1px 1px rgba(0,0,0,0.28))'}}>
          <path
            d="M0.8 0.8 L0.8 20.8 L6.2 16.3 L10.2 24 L14 22 L10 14.7 L17 14.3 Z"
            fill="#15171a"
            stroke="#fff"
            strokeWidth={1.35}
            strokeLinejoin="round"
          />
        </g>
      ) : null}
    </svg>
  );
};
