import SwiftUI

/// Visual configuration for a ``VerticalSemaphore``.
///
/// Defaults reproduce Apple's traffic-light palette (close/minimize/zoom) but
/// stacked **vertically** — the BRACOPED motif. Tune freely for tabs vs. windows.
public struct SemaphoreStyle: Sendable {
    /// Apple's exact traffic-light colors.
    public static let appleRed = Color(red: 1.00, green: 0.373, blue: 0.341)    // #FF5F57
    public static let appleYellow = Color(red: 0.996, green: 0.737, blue: 0.180) // #FEBC2E
    public static let appleGreen = Color(red: 0.157, green: 0.784, blue: 0.251)  // #28C840

    public var closeColor: Color
    public var minimizeColor: Color
    public var zoomColor: Color

    /// Diameter of each dot in points.
    public var dotSize: CGFloat
    /// Vertical gap between dots.
    public var spacing: CGFloat
    /// Tappable padding around each dot (hit target).
    public var hitPadding: CGFloat
    /// Wrap the cluster in a frosted capsule (great for a floating right bar).
    public var showsCapsule: Bool
    /// Reveal the Apple-style glyph (×, −, +) when hovering the cluster.
    public var showsGlyphsOnHover: Bool
    /// Soft glow under the active/hovered dot.
    public var glow: Bool

    public init(
        closeColor: Color = SemaphoreStyle.appleRed,
        minimizeColor: Color = SemaphoreStyle.appleYellow,
        zoomColor: Color = SemaphoreStyle.appleGreen,
        dotSize: CGFloat = 12,
        spacing: CGFloat = 8,
        hitPadding: CGFloat = 4,
        showsCapsule: Bool = false,
        showsGlyphsOnHover: Bool = true,
        glow: Bool = true
    ) {
        self.closeColor = closeColor
        self.minimizeColor = minimizeColor
        self.zoomColor = zoomColor
        self.dotSize = dotSize
        self.spacing = spacing
        self.hitPadding = hitPadding
        self.showsCapsule = showsCapsule
        self.showsGlyphsOnHover = showsGlyphsOnHover
        self.glow = glow
    }

    /// Compact, glyph-less dots — sized for a tab chip.
    public static var tab: SemaphoreStyle {
        SemaphoreStyle(dotSize: 9, spacing: 6, hitPadding: 3,
                       showsCapsule: false, showsGlyphsOnHover: false, glow: false)
    }

    /// Larger dots in a floating frosted capsule — for a window side-rail.
    public static var window: SemaphoreStyle {
        SemaphoreStyle(dotSize: 12, spacing: 8, hitPadding: 5,
                       showsCapsule: true, showsGlyphsOnHover: true, glow: true)
    }
}
