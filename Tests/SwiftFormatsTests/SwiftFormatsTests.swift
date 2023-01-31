import CoreLocation
import Foundation
/*@testable*/ import SwiftFormats
import XCTest

private let locale = Locale(identifier: "en_US")

class StringTests: XCTestCase {
    func test1() {
        XCTAssertEqual(String(123, format: .described), "123")
        XCTAssertEqual(String(123, format: .number), "123")
        XCTAssertEqual(String(123, format: .dumped), "- 123\n") // TODO: can dump format change? Probably
    }
}

class FormatStyleTests: XCTestCase {
    func testIntegerFormatStyle() {
        XCTAssertEqual(RadixedIntegerFormatStyle(radix: 2).format(UInt8.zero), "0")
        XCTAssertEqual(RadixedIntegerFormatStyle(radix: 2).format(UInt8.max), "11111111")
        XCTAssertEqual(RadixedIntegerFormatStyle(radix: 2).format(UInt8(0b11)), "11")
        XCTAssertEqual(RadixedIntegerFormatStyle(radix: 2, width: .count(4)).format(UInt8(0b11)), "0011")
        XCTAssertEqual(RadixedIntegerFormatStyle(radix: 2, width: .count(2)).format(UInt8.max), "11")

        XCTAssertEqual("\(255, format: .hex)", "0xFF")
        XCTAssertEqual(Int(255).formatted(.hex), "0xFF")
        XCTAssertEqual(Int(65535).formatted(.hex.group(2)), "0xFF_FF")
        XCTAssertEqual(Int(12345).formatted(.hex.group(2)), "0x30_39")
    }

    func testOthers() {
        XCTAssertEqual("\(100, format: .described)", "100")
        XCTAssertEqual("\("100", format: .described)", "100")
    }
}

class DMSTests: XCTestCase {
    func test1() {
        XCTAssertEqual("\(45.25125, format: .dmsNotation(mode: .decimalDegrees).locale(locale))", "45.25125°")
        XCTAssertEqual("\(45.25125, format: .dmsNotation(mode: .decimalMinutes).locale(locale))", "45° 15.075′")
        XCTAssertEqual("\(45.25125, format: .dmsNotation(mode: .decimalSeconds).locale(locale))", "45° 15′ 4.5″")
    }
}

class AngleTests: XCTestCase {
    func test1() {
        XCTAssertEqual("\(45.25125, format: .angle(inputUnit: .degrees, outputUnit: .degrees).locale(locale))", "45.25125°")
        XCTAssertEqual("\(45.25125, format: .angle(inputUnit: .degrees, outputUnit: .radians).locale(locale))", "0.789783rad")
        XCTAssertEqual("\(0.789783, format: .angle(inputUnit: .radians, outputUnit: .degrees).locale(locale))", "45.251233°")
        XCTAssertEqual("\(0.789783, format: .angle(inputUnit: .radians, outputUnit: .radians).locale(locale))", "0.789783rad")
    }
}

class CoordinatesTests: XCTestCase {
    func test1() {
        let coordinate = CLLocationCoordinate2D(latitude: 37.78, longitude: 122.43)
        XCTAssertEqual("\(coordinate, format: .coordinates().locale(locale))", "37.78° N, 122.43° E")
    }
}

class SimpleListTests: XCTestCase {
    func test1() {
        let style = SimpleListFormatStyle(substyle: FloatingPointFormatStyle<Double>.number).locale(locale)
        XCTAssertEqual(style.format([1.1,2.2,3.3,4.4]), "1.1, 2.2, 3.3, 4.4")
        let parser = style.parseStrategy
        XCTAssertEqual(try parser.parse("1.1, 2.2, 3.3, 4.4"), [1.1,2.2,3.3,4.4])
    }
}

class HexDumpTests: XCTestCase {
    func testHexdump() {
        XCTAssertEqual("\(Data([0xDE, 0xED, 0xBE, 0xEF]), format: .hexdump())", "0000000000000000  0xDE 0xED 0xBE 0xEF                              ????\n")
    }
}

