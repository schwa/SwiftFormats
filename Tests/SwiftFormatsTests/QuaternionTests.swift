import Foundation
@testable import SwiftFormats
import XCTest
import simd

class QuaternionTests: XCTestCase {
    func test1() throws {
        let angle = 0.785398 // 45°
        let q = simd_quatd(angle: angle, axis: [0, 0, 1])
        XCTAssertEqual("\(q, format: .quaternion.numberStyle(.number.precision(.fractionLength(...2))))", "real: 0.92, ix: 0, iy: 0, iz: 0.38")
        XCTAssertEqual("\(q, format: .quaternion.style(.components).numberStyle( .number.precision(.fractionLength(...2))))", "real: 0.92, ix: 0, iy: 0, iz: 0.38")
        XCTAssertEqual("\(q, format: .quaternion.style(.vector).numberStyle(.number.precision(.fractionLength(...2))))", "x: 0, y: 0, z: 0.38, w: 0.92")
        XCTAssertEqual("\(q, format: .quaternion.style(.angleAxis).numberStyle( .number.precision(.fractionLength(...2))))", "angle: 0.79, x: 0, y: 0, z: 1")
    }

    func testParsing() throws {
        let angle = 0.785398 // 45°
        let q = simd_quatd(angle: angle, axis: [0, 0, 1])
        let s = q.formatted()

        let strategy = QuaternionParseStrategy(type: simd_quatd.self)

        let q2 = try strategy.parse(s)
        XCTAssertEqual(q2.formatted(), "real: 0.92388, ix: 0, iy: 0, iz: 0.382683")
    }

    func testStyles() throws {
        let angle = 0.785398 // 45°
        let q = simd_quatd(angle: angle, axis: [0, 0, 1])
        var style = QuaternionFormatStyle(type: simd_quatd.self)
        XCTAssertEqual(try style.parseStrategy.parse(style.format(q)).formatted(), q.formatted())
        style = style.style(.components)
        XCTAssertEqual(try style.style(.components).parseStrategy.parse(style.format(q)).formatted(), q.formatted())
        style = style.style(.vector)
        XCTAssertEqual(try style.parseStrategy.parse(style.format(q)).formatted(), q.formatted())
        style = style.style(.angleAxis)
        XCTAssertEqual(try style.parseStrategy.parse(style.format(q)).formatted(), q.formatted())
    }
}
