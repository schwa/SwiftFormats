import Foundation

public extension ListFormatStyle {
    /// Convenience method to fully create a `SimpleListFormatStyle`
    init(_ base: Base.Type, style: Style, width: Self.Width = .narrow, listType: Self.ListType = .and) {
        self = .init(memberStyle: style)
        self.width = width
        self.listType = listType
    }
}
