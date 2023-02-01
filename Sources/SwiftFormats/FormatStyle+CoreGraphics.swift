import CoreGraphics
import Foundation

/// A `FormatStyle` for `CGPoint`.
public struct CGPointFormatStyle: ParseableFormatStyle {

    public var parseStrategy: CGPointParseStrategy {
        return CGPointParseStrategy(componentFormat: componentFormat)
    }

    public var componentFormat: FloatingPointFormatStyle<Double> = .number

    public init() {
    }

    public func format(_ value: CGPoint) -> String {
        let style = SimpleListFormatStyle(substyle: componentFormat)
        return style.format([value.x, value.y])
    }
}

public extension FormatStyle where Self == CGPointFormatStyle {
    static func point() -> Self {
        return Self()
    }
}

// MARK: -

public struct CGPointParseStrategy: ParseStrategy {
    public var componentFormat: FloatingPointFormatStyle<Double>

    public init(componentFormat: FloatingPointFormatStyle<Double> = .number) {
        self.componentFormat = componentFormat
    }

    public func parse(_ value: String) throws -> CGPoint {
        var strategy = SimpleListFormatStyle(substyle: componentFormat).parseStrategy
        strategy.countRange = 2 ... 2
        let scalars = try strategy.parse(value)
        return CGPoint(x: scalars[0], y: scalars[1])
    }
}

// MARK: -

public extension CGPoint {
    func formatted<S>(_ format: S) -> S.FormatOutput where Self == S.FormatInput, S : FormatStyle {
        return format.format(self)
    }

    func formatted() -> String {
        formatted(CGPointFormatStyle())
    }
}
