import CoreGraphics
import SwiftFormats
import XCTest

class CoreGraphicsTests: XCTestCase {
    func testRectangle() {
        XCTAssertEqual(CGRect(x: 0, y: 0, width: 0, height: 0).formatted(), "x: 0, y: 0, width: 0, height: 0")
        XCTAssertEqual(CGRect(x: 1, y: 2, width: 3, height: 4).formatted(), "x: 1, y: 2, width: 3, height: 4")
    }
}
