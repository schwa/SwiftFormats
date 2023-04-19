import Foundation
import SwiftFormats
import XCTest
import RegexBuilder

class TupleTests: XCTestCase {

    func testRegexAssumptions() {
        let regex = #/(.*[^\h]),([^\h].*)/#
        XCTAssertNotNil("1,2".firstMatch(of: regex))
        XCTAssertNil("1, 2".firstMatch(of: regex))

        let regex2 = Regex {
            ChoiceOf {
                [",", ";"]
            }
        }
        XCTAssertNotNil(",".firstMatch(of: regex2))
        XCTAssertNotNil(";".firstMatch(of: regex2))
        XCTAssertNil("x".firstMatch(of: regex2))
     }

    func test1() {
        let tuple = (1, 2)
        let style = TupleFormatStyle(type: (Int, Int).self, separator: ", ", substyle0: .number, substyle1: .number)
        XCTAssertEqual(style.format(tuple), "1, 2")
        let strategy = style.parseStrategy
        XCTAssertThrowsError(try strategy.parse("1,"))
        XCTAssertThrowsError(try strategy.parse(",1"))
        XCTAssertNotNil(try strategy.parse("1,2"))
        XCTAssertNotNil(try strategy.parse("1 ,2"))
        XCTAssertNotNil(try strategy.parse("1, 2"))
        XCTAssertNotNil(try strategy.parse("1 , 2"))
        XCTAssertEqual(try strategy.parse("1,2").0, 1)
        XCTAssertEqual(try strategy.parse("1,2").1, 2)
        XCTAssertThrowsError(try strategy.disallowingWhitespace().parse("1, 2"))
        XCTAssertEqual(try strategy.disallowingWhitespace().parse("1,2").0, 1)
        XCTAssertNotNil(try strategy.separators([";", ","]).parse("1;2"))
        XCTAssertNotNil(try strategy.separators([";", ","]).parse("1,2"))
    }
}
