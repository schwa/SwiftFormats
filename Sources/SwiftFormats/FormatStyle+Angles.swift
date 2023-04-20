import Foundation

/// Formats an angle in degrees, minutes, and seconds.
public struct DegreesMinutesSecondsNotationFormatStyle<FormatInput>: FormatStyle where FormatInput: BinaryFloatingPoint {

    public enum Mode: Codable {
        /// Only the degrees are shown, e.g. "45.25125°".
        case decimalDegrees
        /// The degrees and minutes are shown, e.g. "45° 15.075'".
        case decimalMinutes
        /// The degrees, minutes, and seconds are shown, e.g. "45° 15' 4.5".
        case decimalSeconds
    }

    public static var defaultMeasurementStyle: Measurement<UnitAngle>.FormatStyle {
        .measurement(width: .narrow)
    }

    public var mode: Mode

    /// The style used to format the degrees, minutes, and seconds.
    public var measurementStyle: Measurement<UnitAngle>.FormatStyle

    public init(mode: DegreesMinutesSecondsNotationFormatStyle.Mode = .decimalDegrees, measurementStyle: Measurement<UnitAngle>.FormatStyle = Self.defaultMeasurementStyle) {
        self.mode = mode
        self.measurementStyle = measurementStyle
    }

    public func format(_ value: FormatInput) -> String {
        let value = Double(value)
        switch mode {
        case .decimalDegrees:
            let degrees = value
            return "\(degrees, unit: UnitAngle.degrees, format: measurementStyle)"
        case .decimalMinutes:
            let degrees = floor(value)
            let minutes = (value - degrees) * 60
            return "\(degrees, unit: UnitAngle.degrees, format: measurementStyle) \(minutes, unit: UnitAngle.arcMinutes, format: measurementStyle)"
        case .decimalSeconds:
            let degrees = floor(value)
            let minutes = floor(60 * (value - degrees))
            let seconds = 3_600 * (value - degrees) - 60 * minutes
            return "\(degrees, unit: UnitAngle.degrees, format: measurementStyle) \(minutes, unit: UnitAngle.arcMinutes, format: measurementStyle) \(seconds, unit: UnitAngle.arcSeconds, format: measurementStyle)"
        }
    }
}

public extension FormatStyle where Self == DegreesMinutesSecondsNotationFormatStyle<Float> {
    static func dmsNotation(mode: Self.Mode = .decimalDegrees, measurementStyle: Measurement<UnitAngle>.FormatStyle = Self.defaultMeasurementStyle) -> Self {
        DegreesMinutesSecondsNotationFormatStyle(mode: mode, measurementStyle: measurementStyle)
    }
}

public extension FormatStyle where Self == DegreesMinutesSecondsNotationFormatStyle<Double> {
    static func dmsNotation(mode: Self.Mode = .decimalDegrees, measurementStyle: Measurement<UnitAngle>.FormatStyle = Self.defaultMeasurementStyle) -> Self {
        DegreesMinutesSecondsNotationFormatStyle(mode: mode, measurementStyle: measurementStyle)
    }
}

// MARK: -

/// Format angles in degrees or radians, input and output units can be different.
public struct AngleFormatStyle<FormatInput>: ParseableFormatStyle where FormatInput: BinaryFloatingPoint {
    public static var defaultMeasurementStyle: Measurement<UnitAngle>.FormatStyle {
        .measurement(width: .narrow)
    }

    public enum Unit: Codable {
        case degrees
        case radians
    }

    public var inputUnit: Unit
    public var outputUnit: Unit
    public var measurementStyle: Measurement<UnitAngle>.FormatStyle
    public var locale: Locale

    public var parseStrategy: AngleParseStrategy<FormatInput> {
        AngleParseStrategy(inputUnit: inputUnit, outputUnit: outputUnit, locale: locale)
    }

    public init(
        inputUnit: AngleFormatStyle<FormatInput>.Unit,
        outputUnit: AngleFormatStyle<FormatInput>.Unit,
        measurementStyle: Measurement<UnitAngle>.FormatStyle = Self.defaultMeasurementStyle,
        locale: Locale = .autoupdatingCurrent
    ) {
        self.inputUnit = inputUnit
        self.outputUnit = outputUnit
        self.measurementStyle = measurementStyle
        self.locale = locale
    }

    public func format(_ value: FormatInput) -> String {
        switch (inputUnit, outputUnit) {
        case (.degrees, .degrees):
            return "\(Double(value), unit: UnitAngle.degrees, format: measurementStyle.locale(locale))"
        case (.radians, .radians):
            return "\(Double(value), unit: UnitAngle.radians, format: measurementStyle.locale(locale))"
        case (.degrees, .radians):
            return "\(degreesToRadians(Double(value)), unit: UnitAngle.radians, format: measurementStyle.locale(locale))"
        case (.radians, .degrees):
            return "\(radiansToDegrees(Double(value)), unit: UnitAngle.degrees, format: measurementStyle.locale(locale))"
        }
    }
}

public struct AngleParseStrategy<ParseOutput>: ParseStrategy where ParseOutput: BinaryFloatingPoint {

    public typealias Unit = AngleFormatStyle<ParseOutput>.Unit

    public let inputUnit: Unit
    public let outputUnit: Unit
    public let locale: Locale

    init(inputUnit: Unit, outputUnit: Unit, locale: Locale = .autoupdatingCurrent) {
        self.inputUnit = inputUnit
        self.outputUnit = outputUnit
        self.locale = locale
    }

    public func parse(_ value: String) throws -> ParseOutput {
        let number = try Double(value, format: .number)
        switch (inputUnit, outputUnit) {
        case (.degrees, .degrees), (.radians, .radians):
            return ParseOutput(number)
        case (.degrees, .radians):
            return ParseOutput(degreesToRadians(number))
        case (.radians, .degrees):
            return ParseOutput(radiansToDegrees(number))
        }
    }
}

public extension FormatStyle where Self == AngleFormatStyle<Double> {
    static func angle(inputUnit: Self.Unit, outputUnit: Self.Unit) -> Self {
        AngleFormatStyle(inputUnit: inputUnit, outputUnit: outputUnit)
    }
}

public extension ParseStrategy where Self == AngleParseStrategy<Double> {
    static func angle(inputUnit: AngleFormatStyle<Double>.Unit, outputUnit: AngleFormatStyle<Double>.Unit, locale: Locale = .autoupdatingCurrent) -> Self {
        Self(inputUnit: inputUnit, outputUnit: outputUnit, locale: locale)
    }
}

public extension BinaryFloatingPoint {
    init(_ value: String, format: AngleFormatStyle<Self>) throws {
        self = try format.parseStrategy.parse(value)
    }
}
