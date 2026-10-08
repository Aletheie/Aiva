# Native capture helper

`capture-control.swift` records a real macOS application window with ScreenCaptureKit, including its native cursor. It can coordinate real mouse and keyboard events using a timed JSON sequence. No UI, feedback, or application behavior is reconstructed.

Build on macOS 15 or newer:

```sh
swiftc -parse-as-library -module-cache-path /tmp/aiva-demo-swift-cache demo-video/tools/capture-control.swift -o demo-video/tools/capture-control
```

Run `status` outside a filesystem/process sandbox to inspect the actual macOS privacy permissions and screens. Running inside a sandbox can report an empty screen list. Capture requires Screen Recording permission; input and window positioning require Accessibility permission. The helper does not request either permission implicitly. `request-permissions` explicitly opens the operating system permission requests.

```sh
demo-video/tools/capture-control status
demo-video/tools/capture-control list
demo-video/tools/capture-control request-permissions
demo-video/tools/capture-control resize --pid APP_PID --x 40 --y 60 --width 1440 --height 900
demo-video/tools/capture-control activate --pid APP_PID
demo-video/tools/capture-control record --window WINDOW_ID --out /absolute/path/take.mp4 --seconds 35 --scale 2 --sequence /absolute/path/events.json
```

For an application-rendered capture that omits the system cursor, record actual pointer telemetry alongside the capture:

```sh
demo-video/tools/capture-control trace --window WINDOW_ID --out /absolute/path/cursor.json --seconds 35 --hz 120 --sequence /absolute/path/events.json
```

`trace` never reads screen pixels or invokes Screen Recording APIs. It samples the effective pointer position and left-button state using `CGEvent` and `CGEventSource`, rather than deriving positions from the planned sequence. Accessibility is still required to execute the optional input sequence. Omit `--sequence` to log existing interaction only. An optional `--delay` postpones the shared trace/sequence start.

The output contains `startUnixSeconds` for synchronization to the application capture, `startSystemUptime` for precise monotonic timing, the window origin/bounds, and `samples: [{"t": 0.0, "x": 320.0, "y": 250.0, "down": false}]`. Times are measured in seconds from the shared trace/sequence origin. Coordinates are window-relative points when `--window` is given, including the title bar. Convert those coordinates into the application capture's pixel coordinates when replaying the pointer. Samples are measured at their actual times; missed sampling slots are not synthesized. Keep the window stationary during a take. Faithful cursor replay should be disclosed as part of the capture method.

`record` uses H.264 in MP4, requests 30 fps, excludes the window shadow, and defaults to two output pixels per window point. ScreenCaptureKit may emit variable frame intervals for static UI; conform footage to 30 fps in the final edit. Existing output files are refused. The duration is a capture target; the Remotion composition determines the exact final 600 frames. If a sequence exceeds the requested duration, recording continues until it finishes.

Coordinates in sequences are window-relative macOS points when a window ID is supplied. They include the window title bar. Otherwise they are global display coordinates. Action times are absolute seconds from the recording start (or standalone sequence start). Each move uses smoothstep easing. Events run sequentially, so an action that overruns the next scheduled time delays subsequent actions.

The following illustrates the schema; replace coordinates and text with the verified controls from the real application before running:

```json
[
  {"at": 1.0, "action": "move", "x": 320, "y": 250, "duration": 0.65},
  {"at": 1.7, "action": "click"},
  {"at": 2.5, "action": "key", "key": "a", "mods": ["cmd"]},
  {"at": 2.7, "action": "type", "text": "System.out.println(\"Hello\");", "interval": 0.07},
  {"at": 5.0, "action": "scroll", "dy": -300, "duration": 0.8}
]
```

Other actions: `doubleClick` and `wait` (with `duration`). Supported modifiers: `cmd`, `shift`, `alt`, `ctrl`. Supported keys include letters, digits, punctuation, arrows, `return`, `tab`, `space`, `backspace`, `escape`, `home`, `end`, `pageup`, `pagedown`. Positive scroll values scroll upward. Unicode text is delivered via actual CGEvents without using or modifying the clipboard.

Fallback system recorder, once macOS permission is granted:

```sh
/usr/sbin/screencapture -v -V 35 -l WINDOW_ID /absolute/path/take.mov
```

Apple API references: [SCRecordingOutputConfiguration](https://developer.apple.com/documentation/screencapturekit/screcordingoutputconfiguration), [SCStreamConfiguration](https://developer.apple.com/documentation/screencapturekit/scstreamconfiguration), [minimumFrameInterval](https://developer.apple.com/documentation/screencapturekit/scstreamconfiguration/minimumframeinterval).
