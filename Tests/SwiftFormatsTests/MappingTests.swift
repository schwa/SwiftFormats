import Foundation
@testable import SwiftFormats
import XCTest

class MappingTests: XCTestCase {
    func test1() {
        let style = MappingFormatStyle(keyType: Int.self, valueType: Int.self, keyStyle: .number, valueStyle: .number)
        XCTAssertEqual(style.format([(1, 10), (2, 20)]), "1: 10, 2: 20")
        let parser = style.parseStrategy
        XCTAssertEqual(Dictionary(uniqueKeysWithValues: try parser.parse("1:10, 2:20")), [1: 10, 2: 20])
    }

    func test2() {
        let style = MappingFormatStyle(keyType: String.self, valueType: Int.self, keyStyle: IdentityFormatStyle(), valueStyle: .number)
        XCTAssertEqual(style.format([("A", 10), ("B", 20)]), "A: 10, B: 20")
        let parser = style.parseStrategy
        XCTAssertEqual(Dictionary(uniqueKeysWithValues: try parser.parse("A:10, B:20")), ["A": 10, "B": 20])
    }
}
