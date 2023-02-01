import Foundation

// TODO: Experimental, possibly not very useful.

public protocol CompositeFormatStyle: FormatStyle {
    associatedtype ComponentStyle: FormatStyle
    var componentStyle: ComponentStyle { get set }
}

public extension CompositeFormatStyle {
    func component(_ style: ComponentStyle) -> Self {
        var copy = self
        copy.componentStyle = style
        return copy
    }
}
