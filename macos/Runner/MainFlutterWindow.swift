import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private var windowChannel: FlutterMethodChannel?

  override func awakeFromNib() {
    let controller = AivaViewController()
    contentViewController = controller
    title = "Aiva"
    titleVisibility = .hidden
    titlebarAppearsTransparent = true
    titlebarSeparatorStyle = .none
    styleMask.insert(.fullSizeContentView)
    isMovableByWindowBackground = false
    setContentSize(NSSize(width: 1320, height: 880))
    contentMinSize = NSSize(width: 840, height: 600)
    center()
    setFrameAutosaveName("AIVAMainWindow")
    RegisterGeneratedPlugins(registry: controller)

    windowChannel = FlutterMethodChannel(
      name: "aiva/window",
      binaryMessenger: controller.engine.binaryMessenger
    )
    windowChannel?.setMethodCallHandler { [weak self] call, result in
      guard let self else { result(nil); return }
      switch call.method {
      case "startDragging":
        if let event = NSApp.currentEvent,
           event.type == .leftMouseDown || event.type == .leftMouseDragged {
          self.performDrag(with: event)
        }
        result(nil)
      case "doubleClick":
        let action = UserDefaults.standard.string(forKey: "AppleActionOnDoubleClick")
        if action == "Minimize" {
          self.miniaturize(nil)
        } else if action != "None" {
          self.zoom(nil)
        }
        result(nil)
      case "windowInfo":
        let buttons = [NSWindow.ButtonType.closeButton, .miniaturizeButton, .zoomButton]
          .compactMap { self.standardWindowButton($0) }
          .map { button -> [String: Any] in
            let frame = button.convert(button.bounds, to: nil)
            return ["x": frame.minX, "y": self.frame.height - frame.midY,
                    "visible": !button.isHidden, "enabled": button.isEnabled]
          }
        result(["fullSizeContent": self.styleMask.contains(.fullSizeContentView),
                "titleHidden": self.titleVisibility == .hidden,
                "transparentTitlebar": self.titlebarAppearsTransparent,
                "buttons": buttons])
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    super.awakeFromNib()
  }

  /// Keep the native traffic lights in the 56 pt header of the sidebar.
  /// The transparent title bar lets empty regions pass clicks to Flutter.
  fileprivate func alignWindowButtons() {
    guard !styleMask.contains(.fullScreen),
          let close = standardWindowButton(.closeButton),
          let titlebar = close.superview,
          let container = titlebar.superview else { return }
    let height: CGFloat = 56
    var frame = container.frame
    frame.origin.y += frame.height - height
    frame.size.height = height
    if container.frame != frame { container.frame = frame }
    var titleFrame = titlebar.frame
    titleFrame.origin.y = 0
    titleFrame.size.height = height
    if titlebar.frame != titleFrame { titlebar.frame = titleFrame }
    for type in [NSWindow.ButtonType.closeButton, .miniaturizeButton, .zoomButton] {
      guard let button = standardWindowButton(type) else { continue }
      var origin = button.frame.origin
      origin.y = (height - button.frame.height) / 2
      button.setFrameOrigin(origin)
    }
  }
}

private class AivaViewController: FlutterViewController {
  override func viewDidLayout() {
    super.viewDidLayout()
    (view.window as? MainFlutterWindow)?.alignWindowButtons()
  }
}
