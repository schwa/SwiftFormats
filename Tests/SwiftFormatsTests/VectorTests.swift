import CoreLocation
import Foundation
@testable import SwiftFormats
import XCTest
import simd

private let locale = Locale(identifier: "en_US")

class VectorTests: XCTestCase {
    func test1() throws {
        let vector = SIMD3<Float>(0, 1, 2)
//        XCTAssertEqual("\(vector, format: .simd())", "x: 0, y: 1, z: 2")
//        XCTAssertEqual("\(vector, format: .simd(mappingStyle: false))", "0, 1, 2")
//        XCTAssertEqual(try SIMDParseStrategy(scalarStrategy: FloatingPointFormatStyle<Float>.number.parseStrategy, mappingStyle: false).parse("0, 1, 2"), vector)
        XCTAssertEqual(try SIMDParseStrategy(scalarStrategy: FloatingPointFormatStyle<Float>.number.parseStrategy, mappingStyle: true).parse("x: 0, y: 1, z: 2"), vector)
    }
}
