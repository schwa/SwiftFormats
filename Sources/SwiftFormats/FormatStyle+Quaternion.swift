@_implementationOnly import RegexBuilder
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
}

internal extension FormattableQuaternion {
    static var identity: Self {
        Self(real: 1, imag: .zero)
    }
}

extension simd_quatf: FormattableQuaternion {
}

extension simd_quatd: FormattableQuaternion {
}

// MARK: -

public struct QuaternionFormatStyle <Q>: FormatStyle where Q: FormattableQuaternion {

    public enum Style: Codable {
        case components // ix, iy, iz, r
        case imaginaryReal // (ix, iy, iz), r
        case vector // x, y, z, w
        case angleAxis // angle, axis x, axis y, axis z
    }

    var style: Style
    var compositeStyle: CompositeStyle
    var isHumanReadable: Bool // TODO: rename
    var numberStyle: FloatingPointFormatStyle<Double> // TODO: This needs to be generic

    public init(style: QuaternionFormatStyle.Style = .components, compositeStyle: CompositeStyle = .mapping, isHumanReadable: Bool = true, numberStyle: FloatingPointFormatStyle<Double> = .number) {
        self.style = style
        self.compositeStyle = compositeStyle
        self.isHumanReadable = isHumanReadable
        self.numberStyle = numberStyle
    }

    public func format(_ value: Q) -> String {
        // TODO: We're converting components to SIMDx<Double> here a lot where we probably shouldn't need to
        if value == .identity && isHumanReadable {
            return "identity"
        }

        switch style {
        case .components:
            let mapping = [
                ("real", Double(value.real)),
                ("ix", Double(value.imag.x)),
                ("iy", Double(value.imag.y)),
                ("iz", Double(value.imag.z)),
            ]
            return MappingFormatStyle(keyStyle: IdentityFormatStyle(), valueStyle: numberStyle).format(mapping)
        case .imaginaryReal:
            let mapping = [
                ("real", value.real.formatted(numberStyle)),
                ("imaginary", "\(SIMD3<Double>(value.imag), format: .vector.scalarStyle(numberStyle))"),
            ]
            return MappingFormatStyle(keyStyle: IdentityFormatStyle(), valueStyle: IdentityFormatStyle()).format(mapping)
        case .vector:
            return SIMD4<Double>(value.vector).formatted(.vector.scalarStyle(numberStyle))
        case .angleAxis:
            let mapping = [
                ("angle", value.angle.formatted(numberStyle)),
                ("axis", "\(SIMD3<Double>(value.axis), format: .vector.scalarStyle(numberStyle))"),
            ]
            return MappingFormatStyle(keyStyle: IdentityFormatStyle(), valueStyle: IdentityFormatStyle()).format(mapping)
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

    func numberStyle(_ numberStyle: FloatingPointFormatStyle<Double>) -> Self {
        var copy = self
        copy.numberStyle = numberStyle
        return copy
    }
}

public extension FormatStyle where Self == QuaternionFormatStyle<simd_quatf> {
    static var quaternion: Self {
        return QuaternionFormatStyle()
    }
}

public extension FormatStyle where Self == QuaternionFormatStyle<simd_quatd> {
    static var quaternion: Self {
        return QuaternionFormatStyle()
    }
}

