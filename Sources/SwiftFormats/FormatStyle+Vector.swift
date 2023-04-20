@_implementationOnly import RegexBuilder
import Foundation
import simd

public struct SIMDFormatStyle <V, ScalarStyle>: FormatStyle where V: SIMD, ScalarStyle: FormatStyle, ScalarStyle.FormatInput == V.Scalar, ScalarStyle.FormatOutput == String {

    public var scalarStyle: ScalarStyle
    public var mappingStyle: Bool
    public var scalarNames = ["x", "y", "z", "w"] // TODO: Localize, allow changing of names, e.g. rgba or quaternion fields

    public init(scalarStyle: ScalarStyle, mappingStyle: Bool = true) {
        self.scalarStyle = scalarStyle
        self.mappingStyle = mappingStyle
    }

    public func format(_ value: V) -> String {
        if mappingStyle {
            let mapping = Array(zip(scalarNames, value.scalars))
            return MappingFormatStyle(valueStyle: scalarStyle).format(mapping)
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
    func formatted<S>(_ format: S) -> S.FormatOutput where Self == S.FormatInput, S: FormatStyle {
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
        return SIMDParseStrategy(scalarStrategy: scalarStyle.parseStrategy, mappingStyle: mappingStyle)
    }
}

public struct SIMDParseStrategy <V, ScalarStrategy>: ParseStrategy where V: SIMD, ScalarStrategy: ParseStrategy, ScalarStrategy.ParseInput == String, ScalarStrategy.ParseOutput == V.Scalar {

    public enum ParseError: Error {
        case missingKeys
    }

    public var scalarStrategy: ScalarStrategy
    public var mappingStyle: Bool

    public init(scalarStrategy: ScalarStrategy, mappingStyle: Bool = false) {
        self.scalarStrategy = scalarStrategy
        self.mappingStyle = mappingStyle
    }

    public func parse(_ value: String) throws -> V {
        if mappingStyle {
            let strategy = MappingParseStrategy(keyStrategy: IdentityParseStategy(), valueStrategy: scalarStrategy)
            let dictionary = Dictionary(uniqueKeysWithValues: try strategy.parse(value).map { key, value in
                // TODO: Quick hack to prevent keys like " x", " y". Obviously fix in MappingParseStrategy…
                return (key.trimmingCharacters(in: .whitespaces), value)
            })
            switch V.scalarCount {
            case 2:
                guard let x = dictionary["x"], let y = dictionary["y"] else {
                    throw ParseError.missingKeys
                }
                return V([x, y])
            case 3:
                guard let x = dictionary["x"], let y = dictionary["y"], let z = dictionary["z"] else {
                    throw ParseError.missingKeys
                }
                return V([x, y, z])
            case 4:
                guard let x = dictionary["x"], let y = dictionary["y"], let z = dictionary["z"], let w = dictionary["w"] else {
                    throw ParseError.missingKeys
                }
                return V([x, y, z, w])
            default:
                throw ParseError.missingKeys
            }
        }
        else {
            let strategy = SimpleListParseStrategy(substrategy: scalarStrategy)
            let scalars = try strategy.parse(value)
            return V(scalars)
        }
    }
}
