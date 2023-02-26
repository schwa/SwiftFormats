
import Foundation
import simd

public protocol FormattableMatrix: Equatable {
    associatedtype Scalar: SIMDScalar

    var columnCount: Int { get }
    var rowCount: Int { get }

    init()

    subscript(column: Int, row: Int) -> Scalar { get set }
}

public enum MatrixOrder: Codable {
    case columnMajor
    case rowMajor
}

public struct MatrixFormatStyle <Matrix, ScalarStyle>: FormatStyle where Matrix: FormattableMatrix, ScalarStyle: FormatStyle, ScalarStyle.FormatInput == Matrix.Scalar, ScalarStyle.FormatOutput == String {

    public var order: MatrixOrder
    public var scalarStyle: ScalarStyle

    public init(order: MatrixOrder = .rowMajor, scalarStyle: ScalarStyle) {
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

extension MatrixFormatStyle: ParseableFormatStyle where ScalarStyle: ParseableFormatStyle {
    public var parseStrategy: MatrixParseStrategy<Matrix, ScalarStyle.Strategy> {
        return MatrixParseStrategy<Matrix, ScalarStyle.Strategy>(order: order, scalarStrategy: scalarStyle.parseStrategy)
    }
}

public struct MatrixParseStrategy <Matrix, ScalarStrategy>: ParseStrategy where Matrix: FormattableMatrix, ScalarStrategy: ParseStrategy, ScalarStrategy.ParseInput == String, ScalarStrategy.ParseOutput == Matrix.Scalar {

    public var order: MatrixOrder
    public var scalarStrategy: ScalarStrategy

    public init(order: MatrixOrder = .rowMajor, scalarStrategy: ScalarStrategy) {
        self.order = order
        self.scalarStrategy = scalarStrategy
    }

    public func parse(_ value: String) throws -> Matrix {
        var result = Matrix()
        switch order {
        case .columnMajor:
            // TODO:
            fatalError()
        case .rowMajor:
            let innerStrategy = SimpleListParseStrategy(substrategy: scalarStrategy, separator: ",", countRange: result.columnCount ... result.columnCount)
            let elementsStrategy = SimpleListParseStrategy(substrategy: innerStrategy, separator: "\n", countRange: result.rowCount ... result.rowCount)
            let elements = try elementsStrategy.parse(value)
            for row in 0 ..< result.rowCount {
                for column in 0 ..< result.columnCount {
                    result[row, column] = elements[row][column]
                }
            }
        }
        return result
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
