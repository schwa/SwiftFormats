import CoreLocation
import Foundation
@testable import SwiftFormats
import XCTest

private let locale = Locale(identifier: "en_US")
private let fp = FloatingPointFormatStyle<Double>.number

class SimpleListTests: XCTestCase {
    func test1() {
        let style = SimpleListFormatStyle(substyle: fp).locale(locale)
        XCTAssertEqual(style.format([1.1, 2.2, 3.3, 4.4]), "1.1, 2.2, 3.3, 4.4")
        let parser = style.parseStrategy
        XCTAssertEqual(try parser.parse("1.1, 2.2, 3.3, 4.4"), [1.1, 2.2, 3.3, 4.4])
    }

    func testIncrementalParsing1() {
        let string = "1, 2, 3, 4, 5"
        let listStrategy = SimpleListParseStrategy(substrategy: fp.parseStrategy, countRange: 3...3)
        XCTAssertThrowsError(try listStrategy.parse(string))
        var copy = string
        XCTAssertEqual(try listStrategy.incrementalParse(&copy), [1, 2, 3])
        XCTAssertEqual(copy, " 4, 5")
    }

    func testIncrementalParsing2() {
        let string = "1\n2\n3\n4\n5"
        let listStrategy = SimpleListParseStrategy(substrategy: fp.parseStrategy, separator: "\n", countRange: 3...3)
        XCTAssertThrowsError(try listStrategy.parse(string))
        var copy = string
        XCTAssertEqual(try listStrategy.incrementalParse(&copy), [1, 2, 3])
        XCTAssertEqual(copy, "4\n5")
    }

    func testIncrementalParsing3() {
        let string = "1,2,3\n4,5"
        let innerStrategy = SimpleListParseStrategy(substrategy: fp.parseStrategy, separator: ",")
        let outerStrategy = SimpleListParseStrategy(substrategy: innerStrategy, separator: "\n")
        XCTAssertEqual(try outerStrategy.parse(string), [[1, 2, 3], [4, 5]])
    }
}
