import Foundation
import SwiftFormats
import XCTest

class BoolValueTests: XCTestCase {
    func testFormatting() {
        XCTAssertEqual(true.formatted(), "true")
        XCTAssertEqual(false.formatted(), "false")
        XCTAssertEqual(true.formatted(.bool), "true")
        XCTAssertEqual(false.formatted(.bool), "false")
        XCTAssertEqual(true.formatted(.bool.true("YES")), "YES")
        XCTAssertEqual(false.formatted(.bool.false("NO")), "NO")
    }

    func testParsing() {
        XCTAssertTrue(try BoolParseStrategy().parse("true"))
        XCTAssertFalse(try BoolParseStrategy().parse("false"))
        XCTAssertThrowsError(try BoolParseStrategy().parse("aardvark"))
    }
}
