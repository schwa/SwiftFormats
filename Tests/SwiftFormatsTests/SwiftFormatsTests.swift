import CoreLocation
import Foundation
@testable import SwiftFormats
import XCTest
import simd

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
        XCTAssertEqual(45.25125.formatted(.dmsNotation().locale(locale)), "45.25125°")
        XCTAssertEqual("\(45.25125, format: .angle(inputUnit: .degrees, outputUnit: .degrees).locale(locale))", "45.25125°")

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

class CGPointTests: XCTestCase {
    func test1() {
        XCTAssertEqual(CGPoint.zero.formatted(), "0, 0")
        XCTAssertEqual(try CGPointParseStrategy().parse("0, 0"), CGPoint.zero)
        XCTAssertEqual(try CGPointParseStrategy().parse("0.1, 2.3"), CGPoint(x: 0.1, y: 2.3))
        XCTAssertThrowsError(try CGPointParseStrategy().parse(""))
        XCTAssertThrowsError(try CGPointParseStrategy().parse("0.1"))
        XCTAssertThrowsError(try CGPointParseStrategy().parse("1, 2, 2"))
    }
}

class ClosedRangeTests: XCTestCase {
    func test1() throws {
        XCTAssertEqual("\(1 ... 2, format: ClosedRangeFormatStyle(substyle: .number))", "1 ... 2")

        XCTAssertEqual(
            try ClosedRangeFormatStyle(substyle: FloatingPointFormatStyle<Double>.number).parseStrategy.parse("1 ... 2"),
            1 ... 2
        )
        XCTAssertEqual(
            try ClosedRangeFormatStyle(substyle: FloatingPointFormatStyle<Double>.number).parseStrategy.parse("1 - 2"),
            1 ... 2
        )
        XCTAssertEqual(
            try ClosedRangeFormatStyle(substyle: FloatingPointFormatStyle<Double>.number).parseStrategy.delimiters([" "]).parse("1 2"),
            1 ... 2
        )
        XCTAssertThrowsError(
            try ClosedRangeFormatStyle(substyle: FloatingPointFormatStyle<Double>.number).parseStrategy.parse("1 2")
        )
    }
}

class SIMDRangeTests: XCTestCase {
    func test1() throws {
        XCTAssertEqual("\(SIMD3<Float>(0, 1, 2), format: .simd())", "x: 0, y: 1, z: 2")
    }
}

class QuaternionTests: XCTestCase {
    func test1() throws {
        let angle = 0.785398 // 45°
        let q = simd_quatd(angle: angle, axis: [0, 0, 1])
        XCTAssertEqual("\(q, format: .quaternion(numberStyle: .number.precision(.fractionLength(...2))))", "real: 0.92, ix: 0, iy: 0, iz: 0.38")
        XCTAssertEqual("\(q, format: .quaternion(style: .components, numberStyle: .number.precision(.fractionLength(...2))))", "real: 0.92, ix: 0, iy: 0, iz: 0.38")
        XCTAssertEqual("\(q, format: .quaternion(style: .imaginaryReal, numberStyle: .number.precision(.fractionLength(...2))))", "real: 0.92, imaginary: x: 0, y: 0, z: 0.38")
        XCTAssertEqual("\(q, format: .quaternion(style: .vector, numberStyle: .number.precision(.fractionLength(...2))))", "x: 0, y: 0, z: 0.38, w: 0.92")
        XCTAssertEqual("\(q, format: .quaternion(style: .angleAxis, numberStyle: .number.precision(.fractionLength(...2))))", "angle: 0.79, axis: x: 0, y: 0, z: 1")
    }
}
