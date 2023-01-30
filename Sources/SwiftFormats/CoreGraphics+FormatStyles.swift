import CoreGraphics
import Foundation

public struct CGPointStyle: CompositeFormatStyle {
    public var componentStyle: FloatingPointFormatStyle<Double>

    public init() {
        componentStyle = .number
    }

    public func format(_ value: CGPoint) -> String {
        "\(componentStyle.format(value.x)), \(componentStyle.format(value.y))"
    }
}

public extension FormatStyle where Self == CGPointStyle {
    static var point: CGPointStyle {
        CGPointStyle()
    }
}

// MARK: -
