import Foundation
import SwiftFormats
import SwiftUI
import XCTest

class AngleValueTests: XCTestCase {
    func test1() {
        let angle = Angle(degrees: 90)
        XCTAssertEqual(angle.formatted(), "90°")
        XCTAssertEqual("\(angle, format: .angle)", "90°")
        XCTAssertEqual("\(angle, format: .angle.degrees)", "90°")
        XCTAssertEqual("\(angle, format: .angle.radians)", "1.570796rad")

        XCTAssertEqual(try AngleValueParseStrategy().parse("90°"), Angle(degrees: 90))
        XCTAssertEqual(try AngleValueParseStrategy(defaultInputUnit: .degrees).parse("90"), Angle(degrees: 90))
        XCTAssertEqual(try AngleValueParseStrategy().parse("1.570796rad").degrees, 90, accuracy: 0.001)
        XCTAssertEqual(try AngleValueParseStrategy().parse("90"), Angle(degrees: 90))
        XCTAssertThrowsError(try AngleValueParseStrategy(defaultInputUnit: nil).parse("90"))
        XCTAssertThrowsError(try AngleValueParseStrategy().parse("xxx°"))

        XCTAssertEqual(try AngleValueParseStrategy().parse("  90°"), Angle(degrees: 90))
        XCTAssertEqual(try AngleValueParseStrategy().parse("90°  "), Angle(degrees: 90))
        XCTAssertEqual(try AngleValueParseStrategy().parse("90  °"), Angle(degrees: 90))
        XCTAssertEqual(try AngleValueParseStrategy().parse("  90  °  "), Angle(degrees: 90))
    }
}
