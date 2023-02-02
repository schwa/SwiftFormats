import CoreGraphics
import Foundation

/// Format `CGPoint`s.
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
    init(_ string: String) throws {
        self = try CGPointFormatStyle().parseStrategy.parse(string)
    }

    init<T, Value>(_ value: Value, format: T) throws where T: ParseableFormatStyle, Value: StringProtocol, T.Strategy == CGPointParseStrategy {
        self = try format.parseStrategy.parse(value.description)
    }

    init<T, Value>(_ value: Value, strategy: T) throws where T: ParseStrategy, Value: StringProtocol, T.ParseInput == String, T.ParseOutput == CGPoint {
        self = try strategy.parse(value.description)
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension ParseableFormatStyle where Self == CGPointFormatStyle {
    static var cgPoint: Self { .init() }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension ParseStrategy where Self == CGPointParseStrategy {
    static var cgPoint: Self { .init() }
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
