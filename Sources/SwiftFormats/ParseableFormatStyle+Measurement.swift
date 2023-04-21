import Foundation

public struct UnitAngleParseStrategy {

    /// The format style's locale and (optionally) the unit's width width to be used to match the candidate unit.
    let format: Measurement<UnitAngle>.FormatStyle
    /// Determines how strict the unit parsing detection will be.
    /// If `False`: The candidate unit will be case-sensitive matched against the format's `Measurement<UnitAngle>.FormatStyle.UnitWidth` value.
    /// if `True`: The candidate unit will be case-insensitive matched against all possible `Measurement<UnitAngle>.FormatStyle.UnitWidth` values.
    let lenient: Bool

    init(format: Measurement<UnitAngle>.FormatStyle, lenient: Bool = false) {
        self.format = format
        self.lenient = lenient
    }

    public func lenient(_ isLenient: Bool) -> UnitAngleParseStrategy {
        Self(format: format, lenient: isLenient)
    }
}

// MARK: - ParseStrategy

extension UnitAngleParseStrategy: ParseStrategy {
    public func parse(_ value: String) throws -> Measurement<UnitAngle> {
        let parsedUnit = try parseUnit(from: value, for: format.locale)
        let numericalValue = try Double(value, format: format.numberFormatStyle ?? .number)
        return Measurement<UnitAngle>(value: numericalValue, unit: parsedUnit)
    }
}

// MARK: - Private Methods

private extension UnitAngleParseStrategy {
    private func parseUnit(from string: String, for locale: Locale) throws -> UnitAngle {
        let matchingUnit = try UnitAngle.allFoundationUnits.first { candidateUnit in
            let checkWidths = lenient ? [format.width] : Measurement<UnitAngle>.FormatStyle.UnitWidth.allCases
            let unitStrings = try candidateUnit.localizedUnitStrings(for: locale, widths: checkWidths)
            switch lenient {
            case true:
                return unitStrings.map({ $0.lowercased() }).contains(where: { string.contains($0.lowercased()) })
            case false:
                return unitStrings.contains(where: { string.contains($0) })
            }

        }
        guard let matchingUnit else {
            throw SwiftFormatsError.unitCannotBeDetermined
        }
        return matchingUnit
    }
}

// MARK: - Convenience Initializers

extension Measurement.FormatStyle: ParseableFormatStyle where UnitType == UnitAngle {
    public var parseStrategy: UnitAngleParseStrategy {
        UnitAngleParseStrategy(format: self, lenient: false)
    }
}

public extension Measurement where UnitType == UnitAngle {
    init(_ value: String, format: Measurement<UnitAngle>.FormatStyle, lenient: Bool = false) throws {
        self = try format.parseStrategy.lenient(lenient).parse(value)
    }

    init(_ value: String, locale: Locale = .autoupdatingCurrent) throws {
        self = try Measurement<UnitAngle>.FormatStyle.measurement(width: .wide).locale(locale).parseStrategy.parse(value)
    }
}

// MARK: - UnitAngle Extensions

public extension UnitAngle {
    static var allFoundationUnits: [UnitAngle] {
        [
            .degrees,
            .radians,
            .arcMinutes,
            .arcSeconds,
            .gradians,
            .revolutions,
        ]
    }
}

extension UnitAngle {

    private static var whitespaceNewlinesAndCharacterForZero: CharacterSet {
        var set = CharacterSet()
        set.insert(charactersIn: "0")
        set.formUnion(.whitespacesAndNewlines)
        return set
    }

    func localizedUnitString(for locale: Locale, width: Measurement<UnitAngle>.FormatStyle.UnitWidth) throws -> String {
        // Create a zero value measurement to feed into the Measurement.FormatStyle
        let dummyMeasurement = Measurement<UnitAngle>(value: 0, unit: self)
        let formattedString = dummyMeasurement.formatted(.measurement(width: width).locale(locale))

        // Remove only whitespace characters and the "0" character from the string. Leaving only the localized unit
        return String(formattedString.components(separatedBy: Self.whitespaceNewlinesAndCharacterForZero).joined())
    }

    func localizedUnitStrings(
        for locale: Locale,
        widths: [Measurement<UnitAngle>.FormatStyle.UnitWidth]
    ) throws -> [String] {
        try widths.map { try localizedUnitString(for: locale, width: $0) }
    }
}

// MARK: - Measurement Extensions

extension Measurement<UnitAngle>.FormatStyle.UnitWidth: CaseIterable {
    public static var allCases: [Self] {
        [
            .wide,
            .abbreviated,
            .narrow
        ]
    }
}
