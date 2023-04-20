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

public struct QuaternionFormatStyle <Q>: FormatStyle where Q: FormattableQuaternion {

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
    public var mappingStyle = true
    public var humanReadable = true // TODO: rename
    public var numberStyle: FloatingPointFormatStyle<Double> = .number // TODO: This needs to be generic

    public func format(_ value: Q) -> String {
        // TODO: We're converting components to SIMDx<Double> here a lot where we probably shouldn't need to
        if value == .identity && humanReadable {
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
                ("imaginary", "\(SIMD3<Double>(value.imag), format: .simd(numberStyle))"),
            ]
            return MappingFormatStyle(keyStyle: IdentityFormatStyle(), valueStyle: IdentityFormatStyle()).format(mapping)
        case .vector:
            return SIMD4<Double>(value.vector).formatted(.simd(numberStyle))
        case .angleAxis:
            let mapping = [
                ("angle", value.angle.formatted(numberStyle)),
                ("axis", "\(SIMD3<Double>(value.axis), format: .simd(numberStyle))"),
            ]
            return MappingFormatStyle(keyStyle: IdentityFormatStyle(), valueStyle: IdentityFormatStyle()).format(mapping)
        }
    }
}

public extension FormatStyle where Self == QuaternionFormatStyle<simd_quatf> {
    static func quaternion(style: QuaternionFormatStyle<simd_quatf>.Style = .components, mappingStyle: Bool = true, humanReadable: Bool = true, numberStyle: FloatingPointFormatStyle<Double> = .number) -> Self {
        return QuaternionFormatStyle(style: style, mappingStyle: mappingStyle, humanReadable: humanReadable, numberStyle: numberStyle)
    }
}

public extension FormatStyle where Self == QuaternionFormatStyle<simd_quatd> {
    static func quaternion(style: QuaternionFormatStyle<simd_quatd>.Style = .components, mappingStyle: Bool = true, humanReadable: Bool = true, numberStyle: FloatingPointFormatStyle<Double> = .number) -> Self {
        return QuaternionFormatStyle(style: style, mappingStyle: mappingStyle, humanReadable: humanReadable, numberStyle: numberStyle)
    }
}

