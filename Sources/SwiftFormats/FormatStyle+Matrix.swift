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

    public init(type: FormatInput.Type, order: MatrixOrder = .rowMajor, scalarStyle: ScalarStyle) {
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

public extension MatrixFormatStyle {

    func scalarStyle(_ order: MatrixOrder) -> Self {
        var copy = self
        copy.order = order
        return copy
    }

    func scalarStyle(_ scalarStyle: ScalarStyle) -> Self {
        var copy = self
        copy.scalarStyle = scalarStyle
        return copy
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
        let innerStrategy = SimpleListParseStrategy(substrategy: scalarStrategy, separator: ",", countRange: result.rowCount ... result.rowCount)
        let elementsStrategy = SimpleListParseStrategy(substrategy: innerStrategy, separator: "\n", countRange: result.columnCount ... result.columnCount)
        let elements = try elementsStrategy.parse(value)
        switch order {
        case .columnMajor:
            for column in 0 ..< result.columnCount {
                for row in 0 ..< result.rowCount {
                    result[row, column] = elements[row][column]
                }
            }
        case .rowMajor:
            for column in 0 ..< result.columnCount {
                for row in 0 ..< result.rowCount {
                    result[row, column] = elements[column][row]
                }
            }
        }
        return result
    }
}

// MARK: -

public extension FormatStyle where Self == MatrixFormatStyle<simd_float2x2, FloatingPointFormatStyle<Float>> {
    static var matrix: Self {
        return MatrixFormatStyle(type: FormatInput.self, scalarStyle: .number)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float3x2, FloatingPointFormatStyle<Float>> {
    static var matrix: Self {
        return MatrixFormatStyle(type: FormatInput.self, scalarStyle: .number)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float4x2, FloatingPointFormatStyle<Float>> {
    static var matrix: Self {
        return MatrixFormatStyle(type: FormatInput.self, scalarStyle: .number)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float2x3, FloatingPointFormatStyle<Float>> {
    static var matrix: Self {
        return MatrixFormatStyle(type: FormatInput.self, scalarStyle: .number)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float3x3, FloatingPointFormatStyle<Float>> {
    static var matrix: Self {
        return MatrixFormatStyle(type: FormatInput.self, scalarStyle: .number)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float4x3, FloatingPointFormatStyle<Float>> {
    static var matrix: Self {
        return MatrixFormatStyle(type: FormatInput.self, scalarStyle: .number)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float2x4, FloatingPointFormatStyle<Float>> {
    static var matrix: Self {
        return MatrixFormatStyle(type: FormatInput.self, scalarStyle: .number)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float3x4, FloatingPointFormatStyle<Float>> {
    static var matrix: Self {
        return MatrixFormatStyle(type: FormatInput.self, scalarStyle: .number)
    }
}

public extension FormatStyle where Self == MatrixFormatStyle<simd_float4x4, FloatingPointFormatStyle<Float>> {
    static var matrix: Self {
        return MatrixFormatStyle(type: FormatInput.self, scalarStyle: .number)
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
