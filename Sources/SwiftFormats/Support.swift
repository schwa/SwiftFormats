import Foundation
import simd
import RegexBuilder

public enum SwiftFormatsError: Error {
    case parseError
    case unitCannotBeDetermined
    case missingKeys
    case countError
}

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

internal extension SIMD {
    var scalars: [Scalar] {
        (0 ..< scalarCount).map { self[$0] }
    }
}


/// Generates a ChoiceOf regex pattern from an array of strings.
extension Array: RegexComponent where Element == String {
    public var regex: Regex<Substring> {

        guard let first else {
            fatalError("Cannot create ChoiceOf with zero elements.")
        }

        return Regex {
            dropFirst().reduce(AlternationBuilder.buildPartialBlock(first: first)) { regex, element in
                return AlternationBuilder.buildPartialBlock(accumulated: regex, next: element)
            }
        }
    }
}
