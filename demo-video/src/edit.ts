/**
 * The entire edit is defined here. All frame numbers use the composition's
 * 30 fps timebase, including sourceIn. The recordings are never reconstructed.
 *
 * Put captures in public/footage/, update sourceWidth/sourceHeight to the actual
 * cropped application dimensions, then set sourceIn and playbackRate per shot.
 * CAMERA uses global composition frames and a fixed center pivot for the whole
 * application window. Captions use local shot frames, starting at zero.
 * Optional cursorSource points to measured native pointer JSON [{t,x,y,down}].
 * t is source-take seconds; x/y are logical capture-content coordinates.
 * cursorOffsetX/Y correct a known content inset, never invent pointer motion.
 */
export const DEMO = {
  width: 1920,
  height: 1080,
  fps: 30,
  durationInFrames: 600,
  background: '#131922',
  sourceWidth: 1320,
  sourceHeight: 744,
  maxScreenWidth: 1784,
  maxScreenHeight: 888,
  screenCenterY: 506,
} as const;

export type CameraKeyframe = {
  frame: number;
  scale: number;
};

// A single restrained move; every cut lands at the identical resting geometry.
// The entire window stays visible, including the sidebar, code, and output.
export const CAMERA: CameraKeyframe[] = [
  {frame: 0, scale: 1},
  {frame: 219, scale: 1},
  {frame: 285, scale: 1.08},
  {frame: 410, scale: 1.08},
  {frame: 480, scale: 1},
  {frame: 599, scale: 1},
];

export type Caption = {
  text: string;
  from: number;
  durationInFrames: number;
};

export type Shot = {
  id: string;
  source: string;
  cursorSource?: string;
  cursorOffsetX?: number;
  cursorOffsetY?: number;
  cursorTimeOffsetSeconds?: number;
  sourceIn: number;
  from: number;
  durationInFrames: number;
  playbackRate: number;
  dissolveIn: number;
  captions: Caption[];
};

// Adjacent clips overlap by six frames. 126 + 96 + 288 + 69 + 45 - 24 = 600.
export const SHOTS: Shot[] = [
  {
    id: 'Workspace overview',
    source: 'footage/overview.mp4',
    cursorSource: 'footage/overview-cursor.json',
    sourceIn: 18,
    from: 0,
    durationInFrames: 126,
    playbackRate: 1,
    dissolveIn: 0,
    captions: [{text: 'Structured Java lessons', from: 10, durationInFrames: 99}],
  },
  {
    id: 'Lesson into exercise',
    source: 'footage/lesson.mp4',
    cursorSource: 'footage/lesson-cursor.json',
    sourceIn: 9,
    from: 120,
    durationInFrames: 96,
    playbackRate: 1.6,
    dissolveIn: 6,
    captions: [],
  },
  {
    id: 'Integrated coding workspace',
    source: 'footage/studio.mp4',
    cursorSource: 'footage/studio-cursor.json',
    sourceIn: 27,
    from: 210,
    durationInFrames: 288,
    playbackRate: 1,
    dissolveIn: 6,
    captions: [
      {text: 'Integrated code editor', from: 10, durationInFrames: 123},
      {text: 'Run and check Java', from: 150, durationInFrames: 117},
    ],
  },
  {
    id: 'Learning progress',
    source: 'footage/studio.mp4',
    cursorSource: 'footage/studio-cursor.json',
    sourceIn: 354,
    from: 492,
    durationInFrames: 69,
    playbackRate: 1.3,
    dissolveIn: 6,
    captions: [{text: 'Learning progress', from: 6, durationInFrames: 54}],
  },
  {
    id: 'Complete workspace',
    source: 'footage/studio.mp4',
    cursorSource: 'footage/studio-cursor.json',
    sourceIn: 498,
    from: 555,
    durationInFrames: 45,
    playbackRate: 1,
    dissolveIn: 6,
    captions: [],
  },
];
