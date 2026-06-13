import SwiftUI
import VerticalSemaphore

/// A tab chip carrying its own tiny vertical semaphore. Pass only `onClose` to
/// get a single red dot (a tab usually just closes); add minimize/zoom if your
/// tabs can detach into their own windows.
struct TabExample: View {
    let title: String
    var isActive: Bool = false
    var onClose: () -> Void
    var onDetach: (() -> Void)? = nil   // optional: green dot → pop into a window

    @State private var hovering = false

    var body: some View {
        HStack(spacing: 8) {
            // The motif: a per-tab vertical semaphore, only as many dots as actions.
            VerticalSemaphore(
                onClose: onClose,
                onZoom: onDetach,
                style: .tab
            )
            .opacity(isActive || hovering ? 1 : 0.55)

            Text(title)
                .font(.system(size: 12.5, weight: .medium))
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(isActive ? Color.accentColor.opacity(0.18) : Color.primary.opacity(hovering ? 0.08 : 0.04))
        )
        .onHover { hovering = $0 }
    }
}

struct TabStripExample: View {
    var body: some View {
        HStack(spacing: 6) {
            TabExample(title: "index.html", isActive: true, onClose: {}, onDetach: {})
            TabExample(title: "styles.css", onClose: {})
            TabExample(title: "app.js", onClose: {})
        }
        .padding(12)
    }
}
