import Foundation

public extension String {
    init<F>(_ input: F.FormatInput, format: F) where F: FormatStyle, F.FormatOutput == String {
        self = format.format(input)
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation<Value, Style>(_ value: Value, format: Style) where Style: FormatStyle, Style.FormatOutput == String, Style.FormatInput == Value {
        appendInterpolation(format.format(value))
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation<Style, Unit>(_ value: Double, unit: Unit, format: Style) where Style: FormatStyle, Style.FormatInput == Measurement<Unit>, Style.FormatOutput == String, Unit: Dimension {
        let measurement = Measurement(value: value, unit: unit)
        appendInterpolation(format.format(measurement))
    }
}
