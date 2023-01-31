import RegexBuilder
import Foundation
@_implementationOnly import SIMDSupport

// TODO: Make generic
public struct SIMDFormatStyle: ParseableFormatStyle {

    public var parseStrategy: SIMDParseStrategy {
        return SIMDParseStrategy(componentFormat: componentFormat)
    }

    public var componentFormat: FloatingPointFormatStyle<Float> = .number

    public init() {
    }

    public func format(_ value: SIMD3<Float>) -> String {
        let style = SimpleListFormatStyle(substyle: componentFormat)
        return style.format(value.scalars)
    }
}

public extension FormatStyle where Self == SIMDFormatStyle {
    static func simd() -> Self {
        return Self()
    }
}

// MARK: -

public struct SIMDParseStrategy: ParseStrategy {
    public var componentFormat: FloatingPointFormatStyle<Float>

    public init(componentFormat: FloatingPointFormatStyle<Float>) {
        self.componentFormat = componentFormat
    }

    public func parse(_ value: String) throws -> SIMD3<Float> {
        let style = SimpleListFormatStyle(substyle: componentFormat)
        let scalars = try style.parseStrategy.parse(value)
        return SIMD3<Float>(scalars)
    }
}

