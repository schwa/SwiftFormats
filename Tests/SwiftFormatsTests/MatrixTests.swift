import CoreLocation
import Foundation
@testable import SwiftFormats
import XCTest
import simd

private let locale = Locale(identifier: "en_US")

class MatrixTests: XCTestCase {
    func test1() throws {
        let matrix = simd_float4x4(rows: [
            [0, 1, 2, 3],
            [4, 5, 6, 7],
            [8, 9, 10, 11],
            [12, 13, 14, 15],
        ])
        let string = "0, 1, 2, 3\n4, 5, 6, 7\n8, 9, 10, 11\n12, 13, 14, 15"
        XCTAssertEqual("\(matrix, format: .matrix())", string)
        XCTAssertEqual(try MatrixParseStrategy(scalarStrategy: FloatingPointFormatStyle<Float>.number.parseStrategy).parse(string), matrix)
    }
}
