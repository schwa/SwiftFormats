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
            let seconds = 3600 * (value - degrees) - 60 * minutes
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

// TODO: SwiftUI.Angle

// MARK: -

/// Format angles in degrees or radians, input and output units can be different.
public struct AngleFormatStyle<FormatInput>: FormatStyle where FormatInput: BinaryFloatingPoint {
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

    public init(inputUnit: AngleFormatStyle<FormatInput>.Unit, outputUnit: AngleFormatStyle<FormatInput>.Unit, measurementStyle: Measurement<UnitAngle>.FormatStyle = Self.defaultMeasurementStyle) {
        self.inputUnit = inputUnit
        self.outputUnit = outputUnit
        self.measurementStyle = measurementStyle
    }

    public func format(_ value: FormatInput) -> String {
        switch (inputUnit, outputUnit) {
        case (.degrees, .degrees):
            return "\(Double(value), unit: UnitAngle.degrees, format: measurementStyle)"
        case (.radians, .radians):
            return "\(Double(value), unit: UnitAngle.radians, format: measurementStyle)"
        case (.degrees, .radians):
            return "\(degreesToRadians(Double(value)), unit: UnitAngle.radians, format: measurementStyle)"
        case (.radians, .degrees):
            return "\(radiansToDegrees(Double(value)), unit: UnitAngle.degrees, format: measurementStyle)"
        }
    }
}

public extension FormatStyle where Self == AngleFormatStyle<Double> {
    static func angle(inputUnit: Self.Unit, outputUnit: Self.Unit) -> Self {
        AngleFormatStyle(inputUnit: inputUnit, outputUnit: outputUnit)
    }
}

// TODO: Measurement doesn't support parsing, so we may need to implement our own parsing strategy. Possible only for english locale.

/*
public struct AngleParseStrategy <ParseOutput>: ParseStrategy where ParseOutput: BinaryFloatingPoint {

    public typealias Unit = AngleFormatStyle<ParseOutput>.Unit

    public var outputUnit: Unit
//    public var measurementStyle: Measurement<UnitAngle>.FormatStyle

    public func parse(_ value: String) throws -> ParseOutput {






        fatalError()
    }

}
*/
