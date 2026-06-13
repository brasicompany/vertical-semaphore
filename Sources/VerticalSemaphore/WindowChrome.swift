#if os(macOS)
import SwiftUI
import AppKit

/// Auto-hides the native macOS traffic lights so your **vertical** semaphore can
/// own the chrome — and reveals the native ones (Safari/Finder-style) when the
/// cursor enters the top-left corner, so power users keep the OS controls.
///
/// Why a raw mouse monitor instead of a SwiftUI hover region? Because revealing
/// the lights shifts the layout; if the sensor lived *in* the layout, the reveal
/// would move the sensor and the lights would "flee" the cursor in a
/// reveal→relayout→hide oscillation. Driving it off the raw cursor position vs.
/// the window corner decouples the two.
///
/// Usage:
/// ```swift
/// @StateObject private var chrome = WindowChromeController()
///
/// var body: some View {
///     MyContent()
///         .background(WindowChromeAccessor { chrome.attach($0) })
///         .padding(.top, chrome.revealTrafficLights ? 26 : 0)   // retract under lights
/// }
/// ```
@MainActor
public final class WindowChromeController: ObservableObject {
    /// Drives both native-button visibility and your content's retract inset.
    @Published public private(set) var revealTrafficLights = false

    private weak var window: NSWindow?
    private var monitor: Any?

    /// Top-left corner (window base coords, origin bottom-left) that reveals the
    /// native lights. Keep its width inside whatever gutter your custom chrome
    /// reserves, so revealing fires over empty space — never over a tab control.
    public var cornerWidth: CGFloat
    public var cornerHeight: CGFloat

    public init(cornerWidth: CGFloat = 72, cornerHeight: CGFloat = 60) {
        self.cornerWidth = cornerWidth
        self.cornerHeight = cornerHeight
    }

    /// Attach to the hosting window: hide the native lights and start the monitor.
    public func attach(_ w: NSWindow) {
        window = w
        w.isMovableByWindowBackground = true
        w.acceptsMouseMovedEvents = true
        // Edge-to-edge content under the titlebar — no gray titlebar band.
        w.titlebarAppearsTransparent = true
        w.titleVisibility = .hidden
        w.styleMask.insert(.fullSizeContentView)
        apply()
        installMonitor()
    }

    private func installMonitor() {
        guard monitor == nil else { return }
        monitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { [weak self] event in
            self?.evaluate(event)
            return event
        }
    }

    private func evaluate(_ event: NSEvent) {
        guard let w = window, event.window === w else { setRevealed(false); return }
        let h = w.contentView?.bounds.height ?? w.frame.height
        let p = event.locationInWindow
        setRevealed(p.x <= cornerWidth && p.y >= h - cornerHeight)
    }

    public func setRevealed(_ revealed: Bool) {
        guard revealed != revealTrafficLights else { return }
        revealTrafficLights = revealed
        apply()
    }

    private func apply() {
        guard let w = window else { return }
        for type in [NSWindow.ButtonType.closeButton, .miniaturizeButton, .zoomButton] {
            w.standardWindowButton(type)?.isHidden = !revealTrafficLights
        }
    }

    deinit { if let m = monitor { NSEvent.removeMonitor(m) } }
}

/// Captures the hosting `NSWindow` so the controller can manage its buttons.
public struct WindowChromeAccessor: NSViewRepresentable {
    private let onResolve: (NSWindow) -> Void
    public init(onResolve: @escaping (NSWindow) -> Void) { self.onResolve = onResolve }

    public func makeNSView(context: Context) -> NSView {
        let v = NSView()
        DispatchQueue.main.async { if let w = v.window { onResolve(w) } }
        return v
    }
    public func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async { if let w = nsView.window { onResolve(w) } }
    }
}

public extension View {
    /// One-liner: hide the native traffic lights, reveal on top-left hover, and
    /// retract this content slightly while they're shown.
    func verticalSemaphoreWindow(_ chrome: WindowChromeController) -> some View {
        self
            .background(WindowChromeAccessor { chrome.attach($0) })
            .padding(.top, chrome.revealTrafficLights ? 26 : 0)
            .animation(.easeOut(duration: 0.18), value: chrome.revealTrafficLights)
    }
}
#endif
