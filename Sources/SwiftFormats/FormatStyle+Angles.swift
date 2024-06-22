import Foundation
import SwiftUI

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
        AngleParseStrategy(type: FormatInput.self, defaultInputUnit: inputUnit, outputUnit: outputUnit, locale: locale)
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

    public var defaultInputUnit: Unit?
    public var outputUnit: Unit
    public var locale: Locale

    init(type: ParseOutput.Type, defaultInputUnit: Unit? = nil, outputUnit: Unit, locale: Locale = .autoupdatingCurrent) {
        self.defaultInputUnit = defaultInputUnit
        self.outputUnit = outputUnit
        self.locale = locale
    }

    public func parse(_ value: String) throws -> ParseOutput {
        let regex = #/^(.+?)(°|rad)?$/#
        guard let match = value.firstMatch(of: regex) else {
            throw SwiftFormatsError.parseError
        }
        let (value, unit) = (try Double(String(match.output.1), format: .number), match.output.2)
        let radians: Double
        switch (unit, defaultInputUnit) {
        case ("°", _), (.none, .degrees):
            radians = degreesToRadians(value)
        case ("rad", _), (.none, .radians):
            radians = value
        default:
            throw SwiftFormatsError.parseError
        }
        switch outputUnit {
        case .degrees:
            return ParseOutput(radiansToDegrees(radians))
        case .radians:
            return ParseOutput(radians)
        }
    }
}

public extension FormatStyle where Self == AngleFormatStyle<Double> {
    static func angle(inputUnit: Self.Unit, outputUnit: Self.Unit) -> Self {
        AngleFormatStyle(inputUnit: inputUnit, outputUnit: outputUnit)
    }
}

public extension ParseStrategy where Self == AngleParseStrategy<Double> {
    static func angle(defaultInputUnit: AngleFormatStyle<Double>.Unit? = nil, outputUnit: AngleFormatStyle<Double>.Unit, locale: Locale = .autoupdatingCurrent) -> Self {
        Self(type: Double.self, defaultInputUnit: defaultInputUnit, outputUnit: outputUnit, locale: locale)
    }
}

public extension BinaryFloatingPoint {
    init(_ value: String, format: AngleFormatStyle<Self>) throws {
        self = try format.parseStrategy.parse(value)
    }
}

// MARK: -


public struct AngleValueFormatStyle: FormatStyle {

    public static var defaultMeasurementStyle: Measurement<UnitAngle>.FormatStyle {
        .measurement(width: .narrow)
    }

    public enum Unit: Codable {
        case degrees
        case radians
    }

    public var unit: Unit
    public var measurementStyle: Measurement<UnitAngle>.FormatStyle
    public var locale: Locale
    public var defaultInputUnit: Unit?

    public init(unit: AngleValueFormatStyle.Unit, measurementStyle: Measurement<UnitAngle>.FormatStyle = Self.defaultMeasurementStyle, locale: Locale = .autoupdatingCurrent) {
        self.unit = unit
        self.measurementStyle = measurementStyle
        self.locale = locale
    }

    public func format(_ value: Angle) -> String {
        switch unit {
        case .degrees:
            return "\(value.degrees, unit: UnitAngle.degrees, format: measurementStyle.locale(locale))"
        case .radians:
            return "\(value.radians, unit: UnitAngle.radians, format: measurementStyle.locale(locale))"
        }
    }
}

public extension AngleValueFormatStyle {
    func unit(_ unit: Unit) -> Self {
        var copy = self
        copy.unit = unit
        return copy
    }

    var radians: Self {
        var copy = self
        copy.unit = .radians
        return copy
    }

    var degrees: Self {
        var copy = self
        copy.unit = .degrees
        return copy
    }
}

public extension FormatStyle where Self == AngleValueFormatStyle {
    static var angle: Self {
        AngleValueFormatStyle(unit: .degrees)
    }
}

public extension Angle {
    func formatted() -> String {
        return AngleValueFormatStyle(unit: .degrees, measurementStyle: AngleValueFormatStyle.defaultMeasurementStyle, locale: .autoupdatingCurrent).format(self)
    }
}

// MARK: -

extension AngleValueFormatStyle: ParseableFormatStyle {

    public var parseStrategy: AngleValueParseStrategy {
        return AngleValueParseStrategy(defaultInputUnit: defaultInputUnit)
    }

    public func defaultInputUnit(_ defaultInputUnit: Unit) -> Self {
        var copy = self
        copy.defaultInputUnit = defaultInputUnit
        return copy
    }
}

public struct AngleValueParseStrategy: ParseStrategy {
    public typealias Unit = AngleValueFormatStyle.Unit

    public var defaultInputUnit: Unit?

    public init(defaultInputUnit: AngleValueParseStrategy.Unit? = nil) {
        self.defaultInputUnit = defaultInputUnit
    }

    public func parse(_ value: String) throws -> Angle {
        let regex = #/^\s*(.+?)\s*(°|rad)?\s*$/#
        guard let match = value.firstMatch(of: regex) else {
            throw SwiftFormatsError.parseError
        }
        let (value, unit) = (try Double(String(match.output.1), format: .number), match.output.2)
        switch (unit, defaultInputUnit) {
        case ("°", _), (nil, .degrees):
            return Angle(degrees: value)
        case ("rad", _), (nil, .radians):
            return Angle(radians: value)
        default:
            throw SwiftFormatsError.parseError
        }
    }
}
