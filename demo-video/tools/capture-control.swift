import AppKit
import ApplicationServices
import AVFoundation
import ScreenCaptureKit

// Native, real-window capture and real input. No application rendering is recreated.
enum ToolError: Error, CustomStringConvertible {
    case message(String)
    var description: String { if case let .message(text) = self { return text }; return "Unknown error" }
}

func emit(_ object: Any) {
    if let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]),
       let text = String(data: data, encoding: .utf8) { print(text); fflush(stdout) }
}

func windows(allSpaces: Bool = false) -> [[String: Any]] {
    let options: CGWindowListOption = allSpaces ? [.optionAll, .excludeDesktopElements] : [.optionOnScreenOnly, .excludeDesktopElements]
    let all = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] ?? []
    return all.filter { ($0[kCGWindowLayer as String] as? Int) == 0 }.map { w in
        ["id": w[kCGWindowNumber as String] ?? 0,
         "pid": w[kCGWindowOwnerPID as String] ?? 0,
         "owner": w[kCGWindowOwnerName as String] ?? "",
         "title": w[kCGWindowName as String] ?? "",
         "onScreen": w[kCGWindowIsOnscreen as String] ?? false,
         "alpha": w[kCGWindowAlpha as String] ?? 0,
         "bounds": w[kCGWindowBounds as String] ?? [:]]
    }
}

@MainActor
func appState(pid: pid_t) -> [String: Any] {
    guard let app = NSRunningApplication(processIdentifier: pid) else { return ["pid": pid, "notRunning": true] }
    let ax = AXUIElementCreateApplication(pid)
    var axWindows: CFTypeRef?
    let axResult = AXUIElementCopyAttributeValue(ax, kAXWindowsAttribute as CFString, &axWindows)
    let frontmost = NSWorkspace.shared.frontmostApplication
    return ["pid": pid, "name": app.localizedName ?? "", "bundle": app.bundleIdentifier ?? "",
            "active": app.isActive, "hidden": app.isHidden, "terminated": app.isTerminated,
            "finishedLaunching": app.isFinishedLaunching, "activationPolicy": app.activationPolicy.rawValue,
            "frontmostPID": frontmost?.processIdentifier ?? 0, "frontmostName": frontmost?.localizedName ?? "",
            "axWindowsError": axResult.rawValue, "axWindowCount": (axWindows as? [AXUIElement])?.count ?? 0,
            "windows": windows(allSpaces: true).filter { ($0["pid"] as? Int) == Int(pid) }]
}

func windowOrigin(_ id: UInt32?) throws -> CGPoint {
    guard let id else { return .zero }
    guard let w = windows().first(where: { ($0["id"] as? UInt32) == id }),
          let b = w["bounds"] as? [String: Any],
          let x = b["X"] as? Double, let y = b["Y"] as? Double else {
        throw ToolError.message("Window \(id) not found")
    }
    return CGPoint(x: x, y: y)
}

func needAccessibility() throws {
    guard AXIsProcessTrusted() else {
        throw ToolError.message("Accessibility permission is required for real input and window positioning. Enable the invoking terminal/Codex in System Settings > Privacy & Security > Accessibility.")
    }
}

func resize(pid: pid_t, x: Double, y: Double, width: Double, height: Double) throws {
    try needAccessibility()
    let app = AXUIElementCreateApplication(pid)
    var result: CFTypeRef?
    let error = AXUIElementCopyAttributeValue(app, kAXWindowsAttribute as CFString, &result)
    guard error == .success, let items = result as? [AXUIElement], let window = items.first else {
        throw ToolError.message("Cannot access windows for PID \(pid): \(error.rawValue)")
    }
    var point = CGPoint(x: x, y: y)
    var size = CGSize(width: width, height: height)
    let positionResult = AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, AXValueCreate(.cgPoint, &point)!)
    let sizeResult = AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, AXValueCreate(.cgSize, &size)!)
    NSRunningApplication(processIdentifier: pid)?.activate()
    emit(["positionError": positionResult.rawValue, "sizeError": sizeResult.rawValue, "windows": windows().filter { ($0["pid"] as? Int) == Int(pid) }])
}

func pause(_ seconds: Double) async {
    guard seconds > 0 else { return }
    try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
}

func mouseMove(to point: CGPoint, duration: Double) async {
    let start = CGEvent(source: nil)?.location ?? point
    let steps = max(1, Int(duration * 120))
    for i in 1...steps {
        let t = Double(i) / Double(steps)
        let u = t * t * (3 - 2 * t)
        let p = CGPoint(x: start.x + (point.x - start.x) * u, y: start.y + (point.y - start.y) * u)
        CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: p, mouseButton: .left)?.post(tap: .cghidEventTap)
        if i < steps { await pause(duration / Double(steps)) }
    }
}

func flags(_ names: [String]) -> CGEventFlags {
    names.reduce(into: CGEventFlags()) { result, name in
        switch name.lowercased() {
        case "cmd", "command": result.insert(.maskCommand)
        case "shift": result.insert(.maskShift)
        case "alt", "option": result.insert(.maskAlternate)
        case "ctrl", "control": result.insert(.maskControl)
        default: break
        }
    }
}

func keycode(_ key: String) throws -> CGKeyCode {
    let codes: [String: CGKeyCode] = [
        "a": 0, "s": 1, "d": 2, "f": 3, "h": 4, "g": 5, "z": 6, "x": 7,
        "c": 8, "v": 9, "b": 11, "q": 12, "w": 13, "e": 14, "r": 15,
        "y": 16, "t": 17, "1": 18, "2": 19, "3": 20, "4": 21, "6": 22,
        "5": 23, "=": 24, "9": 25, "7": 26, "-": 27, "8": 28, "0": 29,
        "]": 30, "o": 31, "u": 32, "[": 33, "i": 34, "p": 35, "return": 36,
        "enter": 36, "l": 37, "j": 38, "'": 39, "k": 40, ";": 41, "\\": 42,
        ",": 43, "/": 44, "n": 45, "m": 46, ".": 47, "tab": 48,
        "space": 49, "`": 50, "backspace": 51, "delete": 51, "escape": 53,
        "home": 115, "pageup": 116, "forwarddelete": 117, "end": 119,
        "pagedown": 121, "left": 123, "right": 124, "down": 125, "up": 126
    ]
    if let code = codes[key.lowercased()] { return code }
    if let code = UInt16(key) { return code }
    throw ToolError.message("Unknown key: \(key)")
}

func press(_ code: CGKeyCode, modifiers: CGEventFlags = []) async {
    let down = CGEvent(keyboardEventSource: nil, virtualKey: code, keyDown: true)
    down?.flags = modifiers
    down?.post(tap: .cghidEventTap)
    await pause(0.035)
    let up = CGEvent(keyboardEventSource: nil, virtualKey: code, keyDown: false)
    up?.flags = modifiers
    up?.post(tap: .cghidEventTap)
}

func typeText(_ text: String, interval: Double) async {
    for char in text {
        if char == "\n" { await press(36) }
        else if char == "\t" { await press(48) }
        else {
            let utf16 = Array(String(char).utf16)
            for down in [true, false] {
                let event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: down)
                utf16.withUnsafeBufferPointer { ptr in
                    event?.keyboardSetUnicodeString(stringLength: utf16.count, unicodeString: ptr.baseAddress!)
                }
                event?.post(tap: .cghidEventTap)
            }
        }
        await pause(interval)
    }
}

func sequence(path: String, windowID: UInt32?, delay: Double = 0, startAt: Double? = nil) async throws {
    try needAccessibility()
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    guard let events = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
        throw ToolError.message("Sequence must be a JSON array of timed actions")
    }
    let origin = try windowOrigin(windowID)
    await pause(delay)
    let start = startAt ?? ProcessInfo.processInfo.systemUptime
    for event in events {
        let at = event["at"] as? Double ?? 0
        await pause(at - (ProcessInfo.processInfo.systemUptime - start))
        let action = event["action"] as? String ?? ""
        let position = CGPoint(x: origin.x + (event["x"] as? Double ?? 0), y: origin.y + (event["y"] as? Double ?? 0))
        switch action {
        case "move":
            await mouseMove(to: position, duration: event["duration"] as? Double ?? 0.5)
        case "click", "doubleClick":
            if event["x"] != nil { await mouseMove(to: position, duration: event["duration"] as? Double ?? 0.25) }
            let p = CGEvent(source: nil)?.location ?? position
            let count = action == "doubleClick" ? 2 : 1
            for n in 1...count {
                for type in [CGEventType.leftMouseDown, .leftMouseUp] {
                    let click = CGEvent(mouseEventSource: nil, mouseType: type, mouseCursorPosition: p, mouseButton: .left)
                    click?.setIntegerValueField(.mouseEventClickState, value: Int64(n))
                    click?.post(tap: .cghidEventTap)
                    await pause(0.035)
                }
            }
        case "key":
            try await press(keycode(event["key"] as? String ?? ""), modifiers: flags(event["mods"] as? [String] ?? []))
        case "type":
            await typeText(event["text"] as? String ?? "", interval: event["interval"] as? Double ?? 0.04)
        case "scroll":
            let dy = event["dy"] as? Double ?? 0
            let dx = event["dx"] as? Double ?? 0
            let duration = event["duration"] as? Double ?? 0.5
            let steps = max(1, Int(duration * 60))
            var sentX = 0, sentY = 0
            for n in 1...steps {
                let t = Double(n) / Double(steps)
                let u = t * t * (3 - 2 * t)
                let targetX = Int((dx * u).rounded()), targetY = Int((dy * u).rounded())
                CGEvent(scrollWheelEvent2Source: nil, units: .pixel, wheelCount: 2,
                        wheel1: Int32(targetY - sentY), wheel2: Int32(targetX - sentX), wheel3: 0)?.post(tap: .cghidEventTap)
                sentX = targetX; sentY = targetY
                await pause(duration / Double(steps))
            }
        case "wait": await pause(event["duration"] as? Double ?? 0)
        default: throw ToolError.message("Unknown action: \(action)")
        }
        emit(["action": action, "elapsed": ProcessInfo.processInfo.systemUptime - start])
    }
}

// Logs the effective system pointer, not an inferred path from planned actions.
// This needs no screen pixels and never requests Screen Recording permission.
@MainActor
func trace(id: UInt32?, path: String, seconds: Double, hz: Double, delay: Double, sequencePath: String?) async throws {
    guard seconds > 0, hz > 0, hz <= 240, delay >= 0 else {
        throw ToolError.message("Trace requires positive seconds, 0 < hz <= 240, and nonnegative delay")
    }
    guard !FileManager.default.fileExists(atPath: path) else { throw ToolError.message("Output already exists: \(path)") }
    if sequencePath != nil { try needAccessibility() }
    let origin = try windowOrigin(id)
    let targetWindow = id.flatMap { id in windows().first(where: { ($0["id"] as? UInt32) == id }) }
    await pause(delay)
    let startUnixSeconds = Date().timeIntervalSince1970
    let start = ProcessInfo.processInfo.systemUptime
    var sequenceFinished = sequencePath == nil
    var sequenceError: Error?
    let interactionTask = Task { @MainActor in
        guard let sequencePath else { return }
        do { try await sequence(path: sequencePath, windowID: id, startAt: start) }
        catch { sequenceError = error }
        sequenceFinished = true
    }
    emit(["tracing": path, "startUnixSeconds": startUnixSeconds,
          "startSystemUptime": start, "requestedHz": hz,
          "coordinateSpace": id == nil ? "display-points" : "window-points"])
    var samples: [[String: Any]] = []
    var nextSampleTime = start
    repeat {
        let now = ProcessInfo.processInfo.systemUptime
        if let pointer = CGEvent(source: nil)?.location {
            samples.append(["t": now - start, "x": pointer.x - origin.x, "y": pointer.y - origin.y,
                            "down": CGEventSource.buttonState(.combinedSessionState, button: .left)])
        }
        nextSampleTime += 1 / hz
        // Skip missed sampling slots; never manufacture positions for missing time.
        if nextSampleTime < now { nextSampleTime = now + 1 / hz }
        await pause(nextSampleTime - ProcessInfo.processInfo.systemUptime)
    } while ProcessInfo.processInfo.systemUptime - start < seconds || !sequenceFinished
    await interactionTask.value
    let duration = ProcessInfo.processInfo.systemUptime - start
    var document: [String: Any] = [
        "schemaVersion": 1, "source": "macOS CGEvent pointer telemetry",
        "coordinateSpace": id == nil ? "display-points" : "window-points",
        "windowOrigin": ["x": origin.x, "y": origin.y],
        "startUnixSeconds": startUnixSeconds, "startSystemUptime": start,
        "requestedHz": hz, "duration": duration, "samples": samples
    ]
    if let id { document["windowID"] = id }
    if let targetWindow { document["window"] = targetWindow }
    if let sequenceError { document["sequenceError"] = String(describing: sequenceError) }
    let data = try JSONSerialization.data(withJSONObject: document, options: [.prettyPrinted, .sortedKeys])
    try data.write(to: URL(fileURLWithPath: path), options: .atomic)
    emit(["finished": path, "samples": samples.count, "duration": duration])
    if let sequenceError { throw sequenceError }
}

@available(macOS 15.0, *)
final class RecordingDelegate: NSObject, SCRecordingOutputDelegate {
    var started = false
    var finished = false
    var error: Error?
    func recordingOutputDidStartRecording(_ recordingOutput: SCRecordingOutput) { started = true }
    func recordingOutputDidFinishRecording(_ recordingOutput: SCRecordingOutput) { finished = true }
    func recordingOutput(_ recordingOutput: SCRecordingOutput, didFailWithError error: Error) { self.error = error; finished = true }
}

@available(macOS 15.0, *)
@MainActor
func record(id: UInt32, path: String, seconds: Double, scale: Double, sequencePath: String?) async throws {
    guard CGPreflightScreenCaptureAccess() else {
        throw ToolError.message("Screen Recording permission is required. Enable the invoking terminal/Codex in System Settings > Privacy & Security > Screen & System Audio Recording, then restart that application if macOS requests it.")
    }
    guard !FileManager.default.fileExists(atPath: path) else { throw ToolError.message("Output already exists: \(path)") }
    let content = try await SCShareableContent.excludingDesktopWindows(true, onScreenWindowsOnly: true)
    guard let window = content.windows.first(where: { $0.windowID == id }) else { throw ToolError.message("Window \(id) is not shareable") }
    let filter = SCContentFilter(desktopIndependentWindow: window)
    let config = SCStreamConfiguration()
    config.width = Int((filter.contentRect.width * scale / 2).rounded()) * 2
    config.height = Int((filter.contentRect.height * scale / 2).rounded()) * 2
    config.minimumFrameInterval = CMTime(value: 1, timescale: 30)
    config.showsCursor = true
    config.capturesAudio = false
    config.queueDepth = 6
    config.ignoreShadowsSingleWindow = true
    config.shouldBeOpaque = true
    let stream = SCStream(filter: filter, configuration: config, delegate: nil)
    let outputConfig = SCRecordingOutputConfiguration()
    outputConfig.outputURL = URL(fileURLWithPath: path)
    outputConfig.videoCodecType = .h264
    outputConfig.outputFileType = .mp4
    let delegate = RecordingDelegate()
    let output = SCRecordingOutput(configuration: outputConfig, delegate: delegate)
    try stream.addRecordingOutput(output)
    try await stream.startCapture()
    for _ in 0..<100 {
        if delegate.started || delegate.error != nil { break }
        await pause(0.05)
    }
    if let error = delegate.error { throw error }
    guard delegate.started else { throw ToolError.message("Recording did not start") }
    emit(["recording": path, "width": config.width, "height": config.height, "fps": 30, "window": id])
    let start = ProcessInfo.processInfo.systemUptime
    if let sequencePath { try await sequence(path: sequencePath, windowID: id) }
    await pause(seconds - (ProcessInfo.processInfo.systemUptime - start))
    try await stream.stopCapture()
    for _ in 0..<100 {
        if delegate.finished { break }
        await pause(0.05)
    }
    if let error = delegate.error { throw error }
    guard delegate.finished else { throw ToolError.message("Recording finish callback timed out") }
    emit(["finished": path, "secondsRequested": seconds])
}

@main
struct Main {
    @MainActor static func main() async {
        let args = Array(CommandLine.arguments.dropFirst())
        func value(_ name: String) -> String? {
            guard let i = args.firstIndex(of: name), i + 1 < args.count else { return nil }
            return args[i + 1]
        }
        do {
            if ["sequence", "trace"].contains(args.first ?? ""), let pid = value("--pid").flatMap(Int32.init) {
                guard let app = NSRunningApplication(processIdentifier: pid) else { throw ToolError.message("No running app for PID \(pid)") }
                app.unhide()
                guard app.activate(options: [.activateAllWindows]) else { throw ToolError.message("AIVA activation was not accepted") }
                await pause(Double(value("--activation-wait") ?? "2")!)
                guard NSWorkspace.shared.frontmostApplication?.processIdentifier == pid else {
                    throw ToolError.message("Target application did not remain frontmost; no input was sent")
                }
                emit(["activatedPID": pid, "windows": windows().filter { ($0["pid"] as? Int) == Int(pid) }])
            }
            switch args.first ?? "help" {
            case "status":
                emit(["screenRecording": CGPreflightScreenCaptureAccess(), "accessibility": AXIsProcessTrusted(),
                      "screens": NSScreen.screens.map { ["width": $0.frame.width, "height": $0.frame.height, "scale": $0.backingScaleFactor] }])
            case "list": emit(windows(allSpaces: args.contains("--all")))
            case "app-status":
                guard let pid = value("--pid").flatMap(Int32.init) else { throw ToolError.message("app-status requires --pid") }
                emit(appState(pid: pid))
            case "request-permissions":
                let ax = AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary)
                emit(["accessibility": ax, "screenRecording": CGRequestScreenCaptureAccess()])
            case "resize":
                guard let pid = value("--pid").flatMap(Int32.init) else { throw ToolError.message("resize requires --pid") }
                try resize(pid: pid, x: Double(value("--x") ?? "40")!, y: Double(value("--y") ?? "60")!,
                           width: Double(value("--width") ?? "1440")!, height: Double(value("--height") ?? "900")!)
            case "activate":
                guard let pid = value("--pid").flatMap(Int32.init) else { throw ToolError.message("activate requires --pid") }
                guard let app = NSRunningApplication(processIdentifier: pid) else { throw ToolError.message("No running app for PID \(pid)") }
                let unhide = app.unhide()
                let activated = app.activate(options: [.activateAllWindows])
                emit(["activationRequested": activated, "unhideRequested": unhide])
                await pause(Double(value("--wait") ?? "2")!)
                emit(appState(pid: pid))
            case "sequence":
                guard let path = value("--file") else { throw ToolError.message("sequence requires --file") }
                try await sequence(path: path, windowID: value("--window").flatMap(UInt32.init), delay: Double(value("--delay") ?? "0")!)
            case "trace":
                guard let path = value("--out") else { throw ToolError.message("trace requires --out") }
                try await trace(id: value("--window").flatMap(UInt32.init), path: path,
                                seconds: Double(value("--seconds") ?? "35")!, hz: Double(value("--hz") ?? "120")!,
                                delay: Double(value("--delay") ?? "0")!, sequencePath: value("--sequence"))
            case "record":
                guard let id = value("--window").flatMap(UInt32.init), let path = value("--out") else { throw ToolError.message("record requires --window and --out") }
                if #available(macOS 15.0, *) {
                    try await record(id: id, path: path, seconds: Double(value("--seconds") ?? "30")!,
                                     scale: Double(value("--scale") ?? "2")!, sequencePath: value("--sequence"))
                } else { throw ToolError.message("Native recording requires macOS 15 or later; use screencapture -v -V seconds -l windowID output.mov") }
            default:
                print("""
                capture-control status | list [--all] | request-permissions
                capture-control app-status --pid PID
                capture-control resize --pid PID [--x 40 --y 60 --width 1440 --height 900]
                capture-control activate --pid PID
                capture-control sequence --file events.json [--window ID --delay 0 --pid PID --activation-wait 2]
                capture-control trace --out cursor.json [--window ID --seconds 35 --hz 120 --delay 0 --sequence events.json --pid PID]
                capture-control record --window ID --out capture.mp4 [--seconds 30 --scale 2 --sequence events.json]
                Coordinates are screen points, or window-relative points when --window is supplied.
                Sequence actions: move, click, doubleClick, key, type, scroll, wait. Each has absolute `at` seconds.
                Screen recording includes the real cursor. Trace logs actual cursor positions for optional faithful replay.
                """)
            }
        } catch {
            fputs("capture-control: \(error)\n", stderr)
            exit(1)
        }
    }
}
