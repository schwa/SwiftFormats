import Foundation

// TODO: From Everything.
internal func unimplemented(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError(message(), file: file, line: line)
}

internal func degreesToRadians<F>(_ value: F) -> F where F: FloatingPoint {
    value * .pi / 180
}

internal func radiansToDegrees<F>(_ value: F) -> F where F: FloatingPoint {
    value * 180 / .pi
}

// MARK: -
