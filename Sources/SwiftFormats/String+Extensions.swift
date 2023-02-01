import Foundation

public extension String {
    /// A convenience initializer for `String` that takes a `FormatStyle` and a value to format.
    ///
    /// - Discussion:
    ///   Use as an alternative when the type you're formatting does not or cannot provide a `.formatted()` method.
    /// - Parameters:
    ///   - input: The value to format.
    ///   - format: The format style to use.
    /// - Example:
    ///   - `String(123, format: .number)`
    init<F>(_ input: F.FormatInput, format: F) where F: FormatStyle, F.FormatOutput == String {
        self = format.format(input)
    }
}

public extension String.StringInterpolation {
    /// Use format styles directly in string interpolation.
    /// - Example:
    ///   - `"The value is \(123, format: .number)"`
    mutating func appendInterpolation<Value, Style>(_ value: Value, format: Style) where Style: FormatStyle, Style.FormatOutput == String, Style.FormatInput == Value {
        appendInterpolation(format.format(value))
    }
}

public extension String.StringInterpolation {
    /// Format a `Measurement` directly in string interpolation.
    /// - Example:
    ///   - `"The value is \(123, unit: .meters, format: .number) meters"`
    mutating func appendInterpolation<Style, Unit>(_ value: Double, unit: Unit, format: Style) where Style: FormatStyle, Style.FormatInput == Measurement<Unit>, Style.FormatOutput == String, Unit: Dimension {
        let measurement = Measurement(value: value, unit: unit)
        appendInterpolation(format.format(measurement))
    }
}
