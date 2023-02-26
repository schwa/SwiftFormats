import RegexBuilder
import Foundation
//@_implementationOnly import SIMDSupport
import simd

// TODO: Make generic
public struct SIMDFormatStyle <V, ScalarStyle>: FormatStyle where V: SIMD, ScalarStyle: FormatStyle, ScalarStyle.FormatInput == V.Scalar, ScalarStyle.FormatOutput == String {

    public var scalarStyle: ScalarStyle
    public var mappingStyle: Bool

    public init(scalarStyle: ScalarStyle, mappingStyle: Bool = true) {
        self.scalarStyle = scalarStyle
        self.mappingStyle = mappingStyle
    }

    public func format(_ value: V) -> String {
        if mappingStyle {
            let scalarNames = ["x", "y", "z", "w"] // TODO: Localize
            let mapping = Array(zip(scalarNames, value.scalars))
            return SimpleMappingFormatStyle(substyle: scalarStyle).format(mapping)
        }
        else {
            return SimpleListFormatStyle(substyle: scalarStyle).format(value.scalars)
        }
    }
}

public extension FormatStyle where Self == SIMDFormatStyle<SIMD2<Float>, FloatingPointFormatStyle<Float>> {
    static func simd(_ scalarStyle: FloatingPointFormatStyle<Float> = .number, mappingStyle: Bool = true) -> Self {
        return Self(scalarStyle: scalarStyle, mappingStyle: mappingStyle)
    }
}

public extension FormatStyle where Self == SIMDFormatStyle<SIMD3<Float>, FloatingPointFormatStyle<Float>> {
    static func simd(_ scalarStyle: FloatingPointFormatStyle<Float> = .number, mappingStyle: Bool = true) -> Self {
        return Self(scalarStyle: scalarStyle, mappingStyle: mappingStyle)
    }
}

public extension FormatStyle where Self == SIMDFormatStyle<SIMD4<Float>, FloatingPointFormatStyle<Float>> {
    static func simd(_ scalarStyle: FloatingPointFormatStyle<Float> = .number, mappingStyle: Bool = true) -> Self {
        return Self(scalarStyle: scalarStyle, mappingStyle: mappingStyle)
    }
}

public extension FormatStyle where Self == SIMDFormatStyle<SIMD2<Double>, FloatingPointFormatStyle<Double>> {
    static func simd(_ scalarStyle: FloatingPointFormatStyle<Double> = .number, mappingStyle: Bool = true) -> Self {
        return Self(scalarStyle: scalarStyle, mappingStyle: mappingStyle)
    }
}

public extension FormatStyle where Self == SIMDFormatStyle<SIMD3<Double>, FloatingPointFormatStyle<Double>> {
    static func simd(_ scalarStyle: FloatingPointFormatStyle<Double> = .number, mappingStyle: Bool = true) -> Self {
        return Self(scalarStyle: scalarStyle, mappingStyle: mappingStyle)
    }
}

public extension FormatStyle where Self == SIMDFormatStyle<SIMD4<Double>, FloatingPointFormatStyle<Double>> {
    static func simd(_ scalarStyle: FloatingPointFormatStyle<Double> = .number, mappingStyle: Bool = true) -> Self {
        return Self(scalarStyle: scalarStyle, mappingStyle: mappingStyle)
    }
}

public extension SIMD {
    func formatted<S>(_ format: S) -> S.FormatOutput where Self == S.FormatInput, S : FormatStyle {
        return format.format(self)
    }
}

// TODO: Cannot appease the generic gods.
//public extension SIMD where Scalar: BinaryFloatingPoint {
//    func formatted() -> String {
//        return formatted(.simd())
//    }
//}

// MARK: -

// TODO: We need simple mapping and list and whatnot to be parseable too

extension SIMDFormatStyle: ParseableFormatStyle where ScalarStyle: ParseableFormatStyle {
    public var parseStrategy: SIMDParseStrategy <V, ScalarStyle.Strategy> {
        return SIMDParseStrategy(scalarStrategy: scalarStyle.parseStrategy)
    }
}

public struct SIMDParseStrategy <V, ScalarStrategy>: ParseStrategy where V: SIMD, ScalarStrategy: ParseStrategy, ScalarStrategy.ParseInput == String, ScalarStrategy.ParseOutput == V.Scalar {

    public var scalarStrategy: ScalarStrategy
    //public var mappingStyle: Bool = true // TODO

    public init(scalarStrategy: ScalarStrategy) {
        self.scalarStrategy = scalarStrategy
    }

    public func parse(_ value: String) throws -> V {
        let strategy = SimpleListParseStrategy(substrategy: scalarStrategy)
        let scalars = try strategy.parse(value)
        return V(scalars)
    }
}

// MARK: -

// TODO: To make fully generic we need a … ugh.
//internal protocol Quaternion {
//    associatedtype Scalar: BinaryFloatingPoint
//}

// TODO: Only works with simd_quatd right now
public struct QuaternionFormatStyle: FormatStyle {

    public enum Style: Codable {
        case components // ix, iy, iz, r
        case imaginaryReal // (ix, iy, iz), r
        case vector // x, y, z, w
        case angleAxis // angle, axis x, axis y, axis z
    }

    public init(style: QuaternionFormatStyle.Style = .components, mappingStyle: Bool = true, humanReadable: Bool = true, numberStyle: FloatingPointFormatStyle<Double> = .number) {
        self.style = style
        self.mappingStyle = mappingStyle
        self.humanReadable = humanReadable
        self.numberStyle = numberStyle
    }

    public var style: Style = .components
    public var mappingStyle: Bool = true
    public var humanReadable: Bool = true // TODO: rename
    public var numberStyle: FloatingPointFormatStyle<Double> = .number

    public func format(_ value: simd_quatd) -> String {
        if value == .identity && humanReadable {
            return "identity"
        }

        switch style {
        case .components:
            let mapping = [
                ("real", value.real.formatted(numberStyle)),
                ("ix", value.imag.x.formatted(numberStyle)),
                ("iy", value.imag.y.formatted(numberStyle)),
                ("iz", value.imag.z.formatted(numberStyle)),
            ]
            return SimpleMappingFormatStyle().format(mapping)
        case .imaginaryReal:
            let mapping = [
                ("real", value.real.formatted(numberStyle)),
                ("imaginary", "\(value.imag, format: .simd(numberStyle))"),
            ]
            return SimpleMappingFormatStyle().format(mapping)
        case .vector:
            return value.vector.formatted(.simd(numberStyle))
        case .angleAxis:
            let mapping = [
                ("angle", value.angle.formatted(numberStyle)),
                ("axis", "\(value.axis, format: .simd(numberStyle))"),
            ]
            return SimpleMappingFormatStyle().format(mapping)
        }
    }
}


public extension FormatStyle where Self == QuaternionFormatStyle {
    static func quaternion(style: QuaternionFormatStyle.Style = .components, mappingStyle: Bool = true, humanReadable: Bool = true, numberStyle: FloatingPointFormatStyle<Double> = .number) -> Self {
        return QuaternionFormatStyle(style: style, mappingStyle: mappingStyle, humanReadable: humanReadable, numberStyle: numberStyle)
    }
}
