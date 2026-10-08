# AIVA application demonstration

An editable, 20-second demonstration of the real AIVA desktop application, with its integrated Java exercise editor as the main subject. The application interface is Czech; the small explanatory captions are English. The export includes a deep English male narration generated with ElevenLabs and an original, restrained ambient score. Spoken cues follow the actual mouse actions, and the music lowers smoothly beneath each phrase. There is no promotional introduction or end card.

## Deliverables and edit

| File | Purpose |
| --- | --- |
| `aiva-demo.mp4` | Final H.264 MP4, 1920 × 1080, 30 fps, exactly 600 frames / 20 seconds |
| `aiva-preview.gif` | Smaller animated preview for a GitHub README |
| `aiva-thumbnail.png` | Still from the coding workspace |
| `aiva-remotion-project.zip` | Locally generated portable project; create with `python3 tools/package-project.py` |
| `src/` | Editable Remotion composition, timing, camera keyframes, captions, and recorded-pointer replay |
| `public/footage/` | Application footage and pointer data consumed by Remotion |
| `capture/` | Capture-only Flutter entrypoint and input sequences; raw takes, telemetry, profiles, and encoder metadata stay local |
| `tools/` | Native capture/input helper and isolated recording-profile preparation |
| `review/` | Render review images and technical checks, when generated |

The composition uses one gentle camera move, brief dissolves, and captions beneath the interface. The complete application window stays visible. Its center remains fixed, and all section boundaries share the same resting framing; the editor push reaches 1.08× and uses smootherstep easing into and out of a stable hold. The editor section moves closer during the code interaction, then returns to a wider view of the assignment, source, and feedback. Timing is defined in `src/edit.ts`:

| Time | Application view |
| --- | --- |
| 0–4 s | Overview and sidebar navigation |
| 4–7 s | Lesson and transition into its exercise |
| 7–16.4 s | Integrated workspace: instructions, actual Java editing, execution, and validation |
| 16.4–18.5 s | Learning progress recorded after the real successful check |
| 18.5–20 s | Clean closing view of the complete workspace |

Short overlaps at the section boundaries are intentional. `src/edit.ts` is the source of truth for exact frame numbers, source offsets, playback rates, captions, and the global camera keyframes. The audio mix is independently editable in `src/audioMix.ts`.

## Provenance and capture method

The footage runs [Aletheie/Aiva](https://github.com/Aletheie/Aiva), version **1.1.0**, from commit [`b76088b`](https://github.com/Aletheie/Aiva/commit/b76088b). The integrated editor is present in that commit. It is enabled using the application's existing `exerciseEditorMode=embedded` preference. Production application source files are not modified for this video.

This recording uses an **explicitly approved application-rendered capture fallback**. It is not a desktop screen recording. `capture/main.dart` loads the real application and places its existing `AivaApp` inside a Flutter `RepaintBoundary`. Frames from that render tree are sent to FFmpeg at 2640 × 1488, 30 fps, representing a 1320 × 744 logical application surface at 2× resolution. This captures the application's real controls, text, editing state, animations, and results. It does not recreate the interface in Remotion or read pixels from other desktop applications.

Mouse clicks and keyboard input are real macOS `CGEvent` interactions with the running native application. The system pointer is absent from the Flutter render tree, so it is shown in the final composition using **replay of measured native pointer telemetry**. The helper samples effective pointer positions and left-button state; the replay follows those measurements, including their actual timing. Any click accent corresponds to a measured button-down transition. The pointer graphic and click accent are editorial overlays, not pixels captured from the operating system. The pointer and interface share the same camera transform.

`capture/*-events.json` records the intended input sequence. `capture/*-cursor.json` records the actual sampled events. Capture metadata beside each raw MP4 records the start time, frame count, duplicate-frame count, elapsed time, and encoder exit code. The recorder repeats the preceding real frame when it needs to maintain the 30 fps timebase; it does not invent intermediate application states. Source and telemetry timing offsets are preserved in the edit.

## What the coding interaction shows

The lesson is **První pozdrav (Hello World)**, and its exercise is **Rozjeď únikovku pro Wednesday** (`ex-hello-escape-room`). The source project and assignment are the real course assets.

Before the take, the first three deliberate syntax errors in the exercise starter are corrected in an isolated learner workspace: a missing semicolon, the capitalization of `println`, and escaped quotation marks. The final output statement is left blank and entered in the running integrated editor during the recording:

```java
System.out.println("Tvuj tah!");
```

The completed program is compiled and run locally. Its actual output is:

```text
UNIKOVA HRA
Dvere jsou zamcene.
Na zdi je napis: "Najdi klic."
Tvuj tah!
```

**Zkontrolovat řešení** performs the application's actual output comparison. The subsequent progress view comes from that result. No completed exercises, lesson completion, or previous learning history are seeded into the recording profile. The prepared work-in-progress files are capture fixtures, not changes to bundled application content.

## Edit and render

Requirements: Node.js/npm, FFmpeg, and a browser supported by Remotion. The application does not need to be running to re-render the existing footage.

From this directory:

```sh
npm ci
npm run studio
```

Change shot timing and camera keyframes in `src/edit.ts`, visual framing and captions in `src/AivaDemo.tsx`, or the pointer presentation in `src/RecordedCursor.tsx`. All times and source offsets use the 30 fps composition timebase. `from` is a destination frame; `sourceIn` is a source frame. Keep the composition at 600 frames to preserve the requested duration.

```sh
npm run check
npm run compositions
npm run render
npm run thumbnail
npm run gif
```

The render command uses H.264, CRF 16, `yuv420p`, and stereo AAC audio at 320 kb/s. Its automatic `postrender` step removes AAC container padding to preserve exactly 20.000 seconds while copying the 600 video frames unchanged. The thumbnail command selects frame 477, showing the actual passing check in the complete workspace. To regenerate a compact, looping GitHub preview from the final MP4:

```sh
npm run gif
```

## English narration and music

The final voice is **Brian — Deep, Resonant and Comforting**, voice ID `nPczCjzI2devNBz1zQrb`, selected from the voices actually available to the connected ElevenLabs account. Speech was generated using `eleven_multilingual_v2`; the exact settings, factual script, generated sources, measured durations, and final cue positions are retained in `public/narration/`.

| Start | Narration |
| --- | --- |
| 0.50 s | Browse structured Java lessons. |
| 4.27 s | Open an exercise. |
| 7.33 s | Write code beside the instructions. |
| 11.10 s | Run it. |
| 13.40 s | Check your solution. |
| 16.70 s | Your progress is saved. |

The six cues use the actual generated recordings. Their ends are preserved, and no spoken phrase is cut off to fit a slot. Run and check narration starts at the corresponding native input in the footage. The closing workspace is left unspoken.

Speech mastering removes low rumble, applies light compression, and uses measured gain with an oversampled lookahead limiter. Final cue loudness measures **−16.72 to −16.00 LUFS**, with true peaks at or below **−1.60 dBTP**. Original MP3 generations remain available alongside the mastered WAV files. `src/audioMix.ts` controls the narration gain and the smooth music ducking, with a 0.3-second anticipation and 0.6-second recovery.

The music, **Quiet Workspace**, is an original 20-second procedural composition: warm suspended chords, a soft bass pulse, and sparse struck-glass notes. It lifts gently around the editor section, resolves near the progress view, and fades to silence at 20 seconds. No external samples or existing recordings are used. Its deterministic Python generator, notes, seed, arrangement, and measured audio properties are included. The source is 48 kHz stereo / 24-bit PCM, mastered to −24 LUFS.

To change the performance, copy `.env.example` to `.env` or `.env.local` and set `ELEVENLABS_API_KEY` locally. Both files are ignored by Git and excluded from the portable project; `.env.local` takes precedence. Only Text to Speech access and Voices read access are needed. Inspect available voices before choosing a different `ELEVENLABS_VOICE_ID`:

```sh
npm run narration:plan
npm run narration:voices
npm run narration
npm run render
```

The generator uses the official [ElevenLabs text-to-speech API](https://elevenlabs.io/docs/api-reference/text-to-speech/convert). Generating speech consumes ElevenLabs credits. Re-rendering the existing project does not call ElevenLabs or require credentials. These commands rebuild the audio treatment entirely offline:

```sh
npm run narration:master
npm run music
npm run render
```

Technical checks cover duration, cue placement, waveform levels, true peaks, the music fade, and the exported audio track. The final stereo mix measures −19.34 LUFS integrated and −4.18 dBTP; its narration remains above the ducked instrumental bed. Direct auditory audition was unavailable in the editing environment; the generated voice has not been subjectively auditioned here.

## Record another take on macOS

Recording additionally requires Flutter desktop tooling, Xcode, Python 3, a JDK, and the native input helper. Read [`tools/README.md`](tools/README.md) for its build commands, native permissions, sequence schema, and ScreenCaptureKit recording option. This take uses the helper's `trace` mode for interaction and telemetry, and the Flutter capture entrypoint for image frames.

The capture entrypoint currently invokes `/usr/local/bin/ffmpeg`; adjust that capture-only path if FFmpeg is installed elsewhere. Its small recording-control server listens on `127.0.0.1:9891` while this entrypoint is running. Use it only for local capture; it is not part of the production application.

From the repository root, build the separate capture target:

```sh
flutter build macos --release --target demo-video/capture/main.dart
```

Choose fresh directories under `demo-video/`. Launch once with the isolated profile to let AIVA initialize its real SQLite schema, then quit the application before preparing the fixture. `AIVA_PROFILE` isolates the database; the preparation script also sets an explicit workspace so exercise files do not go into the user's normal Documents folder.

```sh
AIVA_PROFILE="$PWD/demo-video/capture-profile" build/macos/Build/Products/Release/Aiva.app/Contents/MacOS/Aiva
```

After quitting that initial launch:

```sh
python3 demo-video/tools/prepare-profile.py --profile "$PWD/demo-video/capture-profile" --workspace "$PWD/demo-video/capture-workspace"
```

The script refuses an existing workspace, paths outside `demo-video/`, or a profile containing learning history. It copies the actual starter and its recognized workspace marker, applies the disclosed three corrections, and sets embedded editing, light theme, and code-execution consent in this isolated profile. It prefers a verified JDK 25 or 21 and uses `/private/tmp/aiva-jdtls-live` if that existing language-server installation is available. For this recording, Java and `javac` 25.0.4 were verified at `/Applications/IntelliJ IDEA.app/Contents/jbr/Contents/Home`; no external IDE is opened during the demonstration.

Launch again with the same `AIVA_PROFILE`. Keep the window stationary during each take. Navigate through **Hledat → Hello World → Cvičení (1)**. Use real inputs to focus the blank line, enter the final statement, click **Spustit kód**, and click **Zkontrolovat řešení**. Select **Můj postup** only after validation succeeds.

The capture server accepts these local requests; use fresh output filenames because overwrite is refused:

```sh
curl -sS -X POST http://127.0.0.1:9891/start -H 'Content-Type: application/json' --data '{"output":"/absolute/path/inside/demo-video/capture/new-take.mp4"}'
curl -sS -X POST http://127.0.0.1:9891/stop
```

Run `capture-control trace` alongside the recording as described in the helper documentation. Synchronize its `startUnixSeconds` with the application's microsecond `startedAt` field, account for any window-content inset, and keep those measured offsets with the source footage. Do not substitute planned pointer paths for recorded telemetry. Add the prepared footage and synchronized sample arrays to `public/footage/` and update the corresponding shots in `src/edit.ts`.

## Quality review

Inspect the first render at the opening, both sides of each cut, the editor close-up, code entry, output, validation result, progress view, and final frame. Check that captions remain secondary, syntax stays readable, cursor alignment survives every zoom, and no framing clips the relevant assignment or output. Review the transitions in motion as well as individual frames, then re-render after any adjustment.

Check final media properties with:

```sh
ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,width,height,avg_frame_rate,nb_frames,pix_fmt:format=duration -of json aiva-demo.mp4
```

The required MP4 result is `h264`, `1920 × 1080`, `30/1`, `600` frames, `yuv420p`, and `20.000000` seconds. The GIF uses a lower frame rate and size for repository previews; the MP4 is the full-quality version.

The regular macOS application build was restored afterward with `flutter build macos --release --target=lib/main.dart`; the recording server is not present in that normal build.

Export properties and SHA-256 hashes are recorded in `quality-review.json`. The later camera revision removes shot-to-shot anchor changes, the clipped editor zoom, and the vertical drift. It keeps the full interface visible during one 1.08× push and return, with a stationary opening and ending. The actual exercise passed **1 of 1 tests**.

The portable project ZIP contains the Remotion source, locked dependencies manifest, real footage, measured pointer data, original speech takes, mastered narration, music, and capture tooling; it excludes `node_modules`, personal profiles, and rejected takes. Regenerate it with `python3 tools/package-project.py`.
