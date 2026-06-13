import SwiftUI

/// A **vertical** traffic-light control — Apple's close/minimize/zoom semaphore,
/// stacked top-to-bottom instead of left-to-right.
///
/// Designed for custom window chrome and tab strips where a horizontal cluster
/// doesn't fit (a narrow side-rail, a tall tab). Pure SwiftUI, cross-platform
/// (macOS/iOS/iPadOS); the optional native-window auto-hide effect is macOS-only
/// (see ``WindowChrome``).
///
/// ```swift
/// VerticalSemaphore(
///     onClose:    { closeWindow() },
///     onMinimize: { minimizeWindow() },
///     onZoom:     { zoomWindow() },
///     style: .window
/// )
/// ```
///
/// Pass `nil` for any handler to render that dot dimmed and non-interactive
/// (e.g. a tab that can only close → give only `onClose`).
public struct VerticalSemaphore: View {
    private let onClose: (() -> Void)?
    private let onMinimize: (() -> Void)?
    private let onZoom: (() -> Void)?
    private let style: SemaphoreStyle

    @State private var hovering = false

    public init(
        onClose: (() -> Void)? = nil,
        onMinimize: (() -> Void)? = nil,
        onZoom: (() -> Void)? = nil,
        style: SemaphoreStyle = SemaphoreStyle()
    ) {
        self.onClose = onClose
        self.onMinimize = onMinimize
        self.onZoom = onZoom
        self.style = style
    }

    public var body: some View {
        let cluster = VStack(spacing: style.spacing) {
            // Top-to-bottom order mirrors macOS left-to-right: close, minimize, zoom.
            SemaphoreDot(color: style.closeColor, glyph: "xmark",
                         action: onClose, hovering: hovering, style: style)
            SemaphoreDot(color: style.minimizeColor, glyph: "minus",
                         action: onMinimize, hovering: hovering, style: style)
            SemaphoreDot(color: style.zoomColor, glyph: "plus",
                         action: onZoom, hovering: hovering, style: style)
        }
        .padding(.vertical, style.showsCapsule ? 8 : 0)
        .padding(.horizontal, style.showsCapsule ? 6 : 0)
        .background {
            if style.showsCapsule {
                Capsule(style: .continuous)
                    .fill(.regularMaterial)
                    .overlay(Capsule(style: .continuous).strokeBorder(.white.opacity(0.10), lineWidth: 1))
                    .shadow(color: .black.opacity(0.26), radius: 8, x: 0, y: 4)
            }
        }
        .onHover { hovering = $0 }
        .animation(.easeOut(duration: 0.16), value: hovering)

        cluster
    }
}

/// A single traffic-light dot with hover glyph + glow.
struct SemaphoreDot: View {
    let color: Color
    let glyph: String
    let action: (() -> Void)?
    let hovering: Bool
    let style: SemaphoreStyle

    private var enabled: Bool { action != nil }

    var body: some View {
        Button(action: { action?() }) {
            ZStack {
                Circle()
                    .fill(color.opacity(enabled ? 1 : 0.35))
                    .overlay(Circle().strokeBorder(.black.opacity(enabled ? 0.18 : 0.08), lineWidth: 0.7))
                    .shadow(color: (style.glow && enabled && hovering) ? color.opacity(0.55) : .clear,
                            radius: 4)

                if style.showsGlyphsOnHover && hovering && enabled {
                    Image(systemName: glyph)
                        .font(.system(size: style.dotSize * 0.55, weight: .bold))
                        .foregroundStyle(.black.opacity(0.55))
                }
            }
            .frame(width: style.dotSize, height: style.dotSize)
            // Larger invisible hit target so the small dots stay easy to click.
            .frame(width: style.dotSize + style.hitPadding * 2,
                   height: style.dotSize + style.hitPadding * 2)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .accessibilityLabel(Text(glyph == "xmark" ? "Close" : glyph == "minus" ? "Minimize" : "Zoom"))
    }
}

#if DEBUG
struct VerticalSemaphore_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 60) {
            VerticalSemaphore(onClose: {}, onMinimize: {}, onZoom: {}, style: .window)
            VerticalSemaphore(onClose: {}, onMinimize: {}, onZoom: {}, style: .tab)
            VerticalSemaphore(onClose: {}, style: .tab)   // close-only (a tab)
        }
        .padding(50)
        .background(Color.gray.opacity(0.25))
    }
}
#endif
