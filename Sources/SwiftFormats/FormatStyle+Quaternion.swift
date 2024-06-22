import RegexBuilder
import Foundation
import simd

public protocol FormattableQuaternion: Equatable {
    associatedtype Scalar: SIMDScalar, BinaryFloatingPoint

    var real: Scalar { get }
    var imag: SIMD3<Scalar> { get }

    var angle: Scalar { get }
    var axis: SIMD3<Scalar> { get }

    var vector: SIMD4<Scalar> { get }

    init(real: Scalar, imag: SIMD3<Scalar>)
    init(vector: SIMD4<Scalar>)
    init(angle: Scalar, axis: SIMD3<Scalar>)
}

internal extension FormattableQuaternion {
    static var identity: Self {
        Self(real: 1, imag: .zero)
    }
}

// MARK: -

public struct QuaternionFormatStyle <Q>: FormatStyle where Q: FormattableQuaternion {

    public enum Style: Codable, CaseIterable {
        case components // ix, iy, iz, r
        case vector // x, y, z, w
        case angleAxis // angle, axis x, axis y, axis z
    }

    public var style: Style
    public var compositeStyle: CompositeStyle
    public var isHumanReadable: Bool // TODO: rename
    public typealias NumberStyle = FloatingPointFormatStyle<Q.Scalar>
    public var numberStyle: NumberStyle

    public init(type: Q.Type, style: QuaternionFormatStyle.Style = .components, compositeStyle: CompositeStyle = .mapping, isHumanReadable: Bool = true, numberStyle: NumberStyle = NumberStyle()) {
        self.style = style
        self.compositeStyle = compositeStyle
        self.isHumanReadable = isHumanReadable
        self.numberStyle = numberStyle
    }

    public func format(_ value: Q) -> String {
        if value == .identity && isHumanReadable {
            return "identity"
        }

        switch style {
        case .components:
            let mapping = [
                ("real", value.real),
                ("ix", value.imag.x),
                ("iy", value.imag.y),
                ("iz", value.imag.z),
            ]
            return MappingFormatStyle(keyStyle: IdentityFormatStyle(), valueStyle: numberStyle).format(mapping)
        case .vector:
            return VectorFormatStyle(type: SIMD4<Q.Scalar>.self, scalarStyle: numberStyle).format(value.vector)
        case .angleAxis:
            let mapping = [
                ("angle", value.angle),
                ("x", value.axis.x),
                ("y", value.axis.y),
                ("z", value.axis.z),
            ]
            return MappingFormatStyle(keyStyle: IdentityFormatStyle(), valueStyle: numberStyle).format(mapping)
        }
    }
}

public extension QuaternionFormatStyle {
    func style(_ style: Style) -> Self {
        var copy = self
        copy.style = style
        return copy
    }

    func compositeStyle(_ compositeStyle: CompositeStyle) -> Self {
        var copy = self
        copy.compositeStyle = compositeStyle
        return copy
    }

    func isHumanReadable(_ isHumanReadable: Bool) -> Self {
        var copy = self
        copy.isHumanReadable = isHumanReadable
        return copy
    }

    func numberStyle(_ numberStyle: FloatingPointFormatStyle<Q.Scalar>) -> Self {
        var copy = self
        copy.numberStyle = numberStyle
        return copy
    }
}

public extension FormatStyle where Self == QuaternionFormatStyle<simd_quatf> {
    static var quaternion: Self {
        return QuaternionFormatStyle(type: simd_quatf.self)
    }
}

public extension FormatStyle where Self == QuaternionFormatStyle<simd_quatd> {
    static var quaternion: Self {
        return QuaternionFormatStyle(type: simd_quatd.self)
    }
}

// MARK: -

public struct QuaternionParseStrategy <Q>: ParseStrategy where Q: FormattableQuaternion {
    public typealias Style = QuaternionFormatStyle<Q>.Style
    public typealias NumberStrategy = FloatingPointParseStrategy<FloatingPointFormatStyle<Q.Scalar>>

    public var style: Style
    public var compositeStyle: CompositeStyle
    public var isHumanReadable: Bool
    public var numberStrategy: NumberStrategy

    public init(type: Q.Type, style: QuaternionParseStrategy<Q>.Style = .components, compositeStyle: CompositeStyle = .mapping, isHumanReadable: Bool = true, numberStrategy: NumberStrategy = FloatingPointFormatStyle<Q.Scalar>().parseStrategy) {
        self.style = style
        self.compositeStyle = compositeStyle
        self.isHumanReadable = isHumanReadable
        self.numberStrategy = numberStrategy
    }

    public func parse(_ value: String) throws -> Q {
        let value = value.trimmingCharacters(in: .whitespaces)
        if value.lowercased() == "identity" {
            return Q.identity
        }
        switch style {
        case .components: // ix, iy, iz, real
            let mapping = try MappingParseStrategy(keyStrategy: IdentityParseStategy(), valueStrategy: numberStrategy).parse(value)
            let dictionary = Dictionary(uniqueKeysWithValues: mapping)
            guard let ix = dictionary["ix"], let iy = dictionary["iy"], let iz = dictionary["iz"], let real = dictionary["real"] else {
                throw SwiftFormatsError.missingKeys
            }
            return Q(real: real, imag: [ix, iy, iz])
        case .vector: // x, y, z, w
            let vector: SIMD4<Q.Scalar> = try VectorParseStrategy(scalarStrategy: numberStrategy, compositeStyle: compositeStyle).parse(value)
            return Q(vector: vector)
        case .angleAxis: // angle, axis x, axis y, axis z
            let mapping = try MappingParseStrategy(keyStrategy: IdentityParseStategy(), valueStrategy: numberStrategy).parse(value)
            let dictionary = Dictionary(uniqueKeysWithValues: mapping)
            guard let angle = dictionary["angle"], let x = dictionary["x"], let y = dictionary["y"], let z = dictionary["z"] else {
                throw SwiftFormatsError.missingKeys
            }
            return Q(angle: angle, axis: [x, y, z])
        }
    }
}

extension QuaternionFormatStyle: ParseableFormatStyle {
    public var parseStrategy: QuaternionParseStrategy <Q> {
        return QuaternionParseStrategy(type: Q.self, style: style, compositeStyle: compositeStyle, isHumanReadable: isHumanReadable, numberStrategy: numberStyle.parseStrategy)
    }
}

// MARK: -

extension simd_quatf: FormattableQuaternion {
}

extension simd_quatd: FormattableQuaternion {
}

public extension FormattableQuaternion {

    func formatted<S>(_ format: S) -> S.FormatOutput where Self == S.FormatInput, S: FormatStyle {
        return format.format(self)
    }

    func formatted() -> String {
        return self.formatted(QuaternionFormatStyle(type: Self.self))
    }
}
