#if os(macOS)
import SwiftUI
import VerticalSemaphore

/// A window whose chrome is a floating **vertical** semaphore on a side-rail,
/// with the native macOS lights auto-hidden and revealed on top-left hover.
struct WindowExample: View {
    @StateObject private var chrome = WindowChromeController()
    @Environment(\.controlActiveState) private var active
    @State private var sidebarCollapsed = false

    var body: some View {
        HStack(spacing: 0) {
            // A sidebar the reducer collapses.
            Color(white: 0.16)
                .frame(width: sidebarCollapsed ? 0 : 180)
                .clipped()

            // Your app content.
            Color(white: 0.12)
                .overlay(Text("Your content").foregroundStyle(.white.opacity(0.6)))

            // Side-rail with the custom vertical semaphore.
            VStack {
                VerticalSemaphore(
                    onClose:    { NSApp.keyWindow?.performClose(nil) },
                    onMinimize: { NSApp.keyWindow?.performMiniaturize(nil) },
                    onZoom:     { NSApp.keyWindow?.performZoom(nil) },
                    onToggleSidebar: { withAnimation(.snappy) { sidebarCollapsed.toggle() } },
                    isSidebarCollapsed: sidebarCollapsed,
                    style: .window
                )
                .padding(.top, 14)
                Spacer()
            }
            .frame(width: 48)
            .background(Color(white: 0.08))
        }
        .ignoresSafeArea()
        .verticalSemaphoreWindow(chrome)   // hide native lights + reveal on hover
    }
}
#endif
