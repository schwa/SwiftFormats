import Foundation

public extension String {
    init<F>(_ input: F.FormatInput, format: F) where F: FormatStyle, F.FormatInput: Equatable, F.FormatOutput == String {
        self = format.format(input)
    }
}

public extension String {
    init<Value, Style>(_ value: Value, format: Style) where Style: FormatStyle, Style.FormatOutput == String, Style.FormatInput == Value {
        self = format.format(value)
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation<Value, Style>(_ value: Value, format: Style) where Style: FormatStyle, Style.FormatOutput == String, Style.FormatInput == Value {
        appendInterpolation(format.format(value))
    }
}
