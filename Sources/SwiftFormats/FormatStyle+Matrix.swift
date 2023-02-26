
import Foundation
import simd

public protocol FormattableMatrix: Equatable {
    associatedtype Scalar: SIMDScalar

    var columnCount: Int { get }
    var rowCount: Int { get }

    subscript(column: Int, row: Int) -> Scalar { get }
}

public struct MatrixFormatStyle <Matrix, ScalarStyle>: FormatStyle where Matrix: FormattableMatrix, ScalarStyle: FormatStyle, ScalarStyle.FormatInput == Matrix.Scalar, ScalarStyle.FormatOutput == String {

    public enum Order: Codable {
        case columnMajor
        case rowMajor
    }

    public var order: Order
    public var scalarStyle: ScalarStyle

    public init(order: Order = .rowMajor, scalarStyle: ScalarStyle) {
        self.order = order
        self.scalarStyle = scalarStyle
    }

    public func format(_ value: Matrix) -> String {
        let elements: [[Matrix.Scalar]]
        switch order {
        case .columnMajor:
            elements = (0 ..< value.columnCount).map { column in
                return (0 ..< value.rowCount).map { row in
                    value[column, row]
                }
            }
        case.rowMajor:
            elements = (0 ..< value.rowCount).map { row in
                return (0 ..< value.columnCount).map { column in
                    value[column, row]
                }
            }
        }
        return SimpleListFormatStyle(substyle: SimpleListFormatStyle(substyle: scalarStyle), separator: "\n").format(elements)
    }
}

// MARK: -

public extension FormatStyle where Self == MatrixFormatStyle<simd_float2x2, FloatingPointFormatStyle<Float>> {
    static func matrix(scalarStyle: FloatingPointFormatStyle<Float> = .number) -> Self {
        return MatrixFormatStyle(scalarStyle: scalarStyle)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float3x2, FloatingPointFormatStyle<Float>> {
    static func matrix(scalarStyle: FloatingPointFormatStyle<Float> = .number) -> Self {
        return MatrixFormatStyle(scalarStyle: scalarStyle)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float4x2, FloatingPointFormatStyle<Float>> {
    static func matrix(scalarStyle: FloatingPointFormatStyle<Float> = .number) -> Self {
        return MatrixFormatStyle(scalarStyle: scalarStyle)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float2x3, FloatingPointFormatStyle<Float>> {
    static func matrix(scalarStyle: FloatingPointFormatStyle<Float> = .number) -> Self {
        return MatrixFormatStyle(scalarStyle: scalarStyle)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float3x3, FloatingPointFormatStyle<Float>> {
    static func matrix(scalarStyle: FloatingPointFormatStyle<Float> = .number) -> Self {
        return MatrixFormatStyle(scalarStyle: scalarStyle)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float4x3, FloatingPointFormatStyle<Float>> {
    static func matrix(scalarStyle: FloatingPointFormatStyle<Float> = .number) -> Self {
        return MatrixFormatStyle(scalarStyle: scalarStyle)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float2x4, FloatingPointFormatStyle<Float>> {
    static func matrix(scalarStyle: FloatingPointFormatStyle<Float> = .number) -> Self {
        return MatrixFormatStyle(scalarStyle: scalarStyle)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float3x4, FloatingPointFormatStyle<Float>> {
    static func matrix(scalarStyle: FloatingPointFormatStyle<Float> = .number) -> Self {
        return MatrixFormatStyle(scalarStyle: scalarStyle)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float4x4, FloatingPointFormatStyle<Float>> {
    static func matrix(scalarStyle: FloatingPointFormatStyle<Float> = .number) -> Self {
        return MatrixFormatStyle(scalarStyle: scalarStyle)
    }
}

// MARK: -

extension simd_float2x2: FormattableMatrix {
    public var columnCount: Int { return 2 }
    public var rowCount: Int { return 2 }
}
extension simd_float3x2: FormattableMatrix {
    public var columnCount: Int { return 3 }
    public var rowCount: Int { return 2 }
}
extension simd_float4x2: FormattableMatrix {
    public var columnCount: Int { return 4 }
    public var rowCount: Int { return 2 }
}
extension simd_float2x3: FormattableMatrix {
    public var columnCount: Int { return 2 }
    public var rowCount: Int { return 3 }
}
extension simd_float3x3: FormattableMatrix {
    public var columnCount: Int { return 3 }
    public var rowCount: Int { return 3 }
}
extension simd_float4x3: FormattableMatrix {
    public var columnCount: Int { return 4 }
    public var rowCount: Int { return 3 }
}
extension simd_float2x4: FormattableMatrix {
    public var columnCount: Int { return 2 }
    public var rowCount: Int { return 4 }
}
extension simd_float3x4: FormattableMatrix {
    public var columnCount: Int { return 3 }
    public var rowCount: Int { return 4 }
}
extension simd_float4x4: FormattableMatrix {
    public var columnCount: Int { return 4 }
    public var rowCount: Int { return 4 }
}
