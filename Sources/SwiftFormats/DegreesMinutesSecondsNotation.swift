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

    var mode: Mode
    var measurementStyle: Measurement<UnitAngle>.FormatStyle

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
