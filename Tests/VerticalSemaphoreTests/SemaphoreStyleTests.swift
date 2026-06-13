import XCTest
@testable import VerticalSemaphore

final class SemaphoreStyleTests: XCTestCase {
    func testWindowPresetUsesFloatingCapsuleDefaults() {
        let style = SemaphoreStyle.window

        XCTAssertEqual(style.dotSize, 12)
        XCTAssertEqual(style.spacing, 8)
        XCTAssertEqual(style.hitPadding, 5)
        XCTAssertTrue(style.showsCapsule)
        XCTAssertTrue(style.showsGlyphsOnHover)
        XCTAssertTrue(style.glow)
    }

    func testTabPresetUsesCompactNonGlyphDefaults() {
        let style = SemaphoreStyle.tab

        XCTAssertEqual(style.dotSize, 9)
        XCTAssertEqual(style.spacing, 6)
        XCTAssertEqual(style.hitPadding, 3)
        XCTAssertFalse(style.showsCapsule)
        XCTAssertFalse(style.showsGlyphsOnHover)
        XCTAssertFalse(style.glow)
    }

    func testCustomStyleStoresPublicConfiguration() {
        let style = SemaphoreStyle(
            dotSize: 14,
            spacing: 10,
            hitPadding: 6,
            showsCapsule: true,
            showsGlyphsOnHover: false,
            glow: false
        )

        XCTAssertEqual(style.dotSize, 14)
        XCTAssertEqual(style.spacing, 10)
        XCTAssertEqual(style.hitPadding, 6)
        XCTAssertTrue(style.showsCapsule)
        XCTAssertFalse(style.showsGlyphsOnHover)
        XCTAssertFalse(style.glow)
    }
}
