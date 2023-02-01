import CoreLocation
import Foundation

// TODO: add support for UTM (can import https://github.com/wtw-software/UTMConversion)
// TODO: add support for geohash

internal enum LatitudeLongitude: CaseIterable {
    case latitude
    case longitude
}

internal enum Hemisphere: CaseIterable {
    case east
    case west
    case north
    case south
}

internal extension Hemisphere {
    init(latitude value: CLLocationDegrees) {
        self = value >= 0 ? .north : .south
    }

    init(longitude value: CLLocationDegrees) {
        self = value >= 0 ? .east : .west
    }
}

// TODO: Localized
// TODO: Really should be `cardinal direction`
extension Hemisphere: CustomStringConvertible {
    var description: String {
        switch self {
        case .north:
            return "North"
        case .south:
            return "South"
        case .east:
            return "East"
        case .west:
            return "West"
        }
    }
}

internal struct HemisphereFormatStyle: FormatStyle {
    let abbreviated: Bool

    init(abbreviated: Bool) {
        self.abbreviated = abbreviated
    }

    func format(_ value: Hemisphere) -> String {
        abbreviated ? "\(value.description.first!)" : value.description
    }
}

internal extension FormatStyle where Self == HemisphereFormatStyle {
    static func hemisphere(abbreviated: Bool = true) -> Self {
        HemisphereFormatStyle(abbreviated: abbreviated)
    }
}

// MARK: -

/// Format latitude values, including hemisphere.
public struct LatitudeFormatStyle<FormatInput>: FormatStyle where FormatInput: BinaryFloatingPoint {
    public typealias Substyle = DegreesMinutesSecondsNotationFormatStyle<FormatInput>

    public static var defaultSubstyle: Substyle {
        .init()
    }

    public var includeHemisphere: Bool
    public var substyle: Substyle

    public init(includeHemisphere: Bool = true, substyle: Substyle = Self.defaultSubstyle) {
        self.includeHemisphere = includeHemisphere
        self.substyle = substyle
    }

    public func format(_ value: FormatInput) -> String {
        if includeHemisphere {
            // TODO: Need a flipped flag
            return "\(value, format: substyle) \(Hemisphere(latitude: Double(value)), format: .hemisphere())"
        }
        else {
            return "\(value, format: substyle)"
        }
    }
}

public extension FormatStyle where Self == LatitudeFormatStyle<Double> {
    static func latitude(includeHemisphere: Bool = true, substyle: Self.Substyle = Self.defaultSubstyle) -> Self {
        .init(includeHemisphere: includeHemisphere, substyle: substyle)
    }
}

public extension FormatStyle where Self == LatitudeFormatStyle<Float> {
    static func latitude(includeHemisphere: Bool = true, substyle: Self.Substyle = Self.defaultSubstyle) -> Self {
        .init(includeHemisphere: includeHemisphere, substyle: substyle)
    }
}

// MARK: -

/// Format latitude values, including hemisphere.
public struct LongitudeFormatStyle<FormatInput>: FormatStyle where FormatInput: BinaryFloatingPoint {
    public typealias Substyle = DegreesMinutesSecondsNotationFormatStyle<FormatInput>

    public static var defaultSubstyle: Substyle {
        .init()
    }

    public var includeHemisphere: Bool
    public var substyle: Substyle

    public init(includeHemisphere: Bool = true, substyle: Substyle = Self.defaultSubstyle) {
        self.includeHemisphere = includeHemisphere
        self.substyle = substyle
    }

    public func format(_ value: FormatInput) -> String {
        if includeHemisphere {
            // TODO: Need a flipped flag
            return "\(value, format: substyle) \(Hemisphere(longitude: Double(value)), format: .hemisphere())"
        }
        else {
            return "\(value, format: substyle)"
        }
    }
}

public extension FormatStyle where Self == LongitudeFormatStyle<Double> {
    static func longitude(includeHemisphere: Bool = true, substyle: Self.Substyle = Self.defaultSubstyle) -> Self {
        .init(includeHemisphere: includeHemisphere, substyle: substyle)
    }
}

public extension FormatStyle where Self == LongitudeFormatStyle<Float> {
    static func longitude(includeHemisphere: Bool = true, substyle: Self.Substyle = Self.defaultSubstyle) -> Self {
        .init(includeHemisphere: includeHemisphere, substyle: substyle)
    }
}

// MARK: -

/// A format style for a lat/long coordinate.
public struct CoordinatesFormatter: FormatStyle {
    // TODO: need a way to pass options down to sub styles

    public func format(_ value: CLLocationCoordinate2D) -> String {
        "\(value.latitude, format: .latitude()), \(value.longitude, format: .longitude())"
    }
}

public extension FormatStyle where Self == CoordinatesFormatter {
    static func coordinates() -> Self {
        CoordinatesFormatter()
    }
}
