import Foundation
@testable import SwiftFormats
import XCTest

class MappingTests: XCTestCase {
    func test1() {
        let style = MappingFormatStyle(keyType: Int.self, valueType: Int.self, keyStyle: .number, valueStyle: .number)
        XCTAssertEqual(style.format([(1, 10), (2, 20)]), "1:10, 2:20")
        let parser = style.parseStrategy
        XCTAssertEqual(Dictionary(uniqueKeysWithValues: try parser.parse("1:10, 2:20")), [1:10, 2:20])
    }
}
