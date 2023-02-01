import Foundation

public struct DescribedFormatStyle<FormatInput>: FormatStyle {
    public typealias FormatInput = FormatInput
    public typealias FormatOutput = String

    public func format(_ value: FormatInput) -> String {
        String(describing: value)
    }
}

public extension FormatStyle where Self == DescribedFormatStyle<Any> {
    /// A format style that uses `String(describing:)` to format the value. Useful for debugging.
    ///
    /// Example:
    /// - `"\(123, format: .described)"`` vs `String(describing: 123)` // :shrug:
    static var described: DescribedFormatStyle<FormatInput> {
        DescribedFormatStyle()
    }
}

// MARK: -

public struct DumpedFormatStyle<FormatInput>: FormatStyle {
    public typealias FormatInput = FormatInput
    public typealias FormatOutput = String

    public func format(_ value: FormatInput) -> String {
        var s = ""
        dump(value, to: &s)
        return s
    }
}

public extension FormatStyle where Self == DescribedFormatStyle<Any> {
    /// A format style that uses `dump` to format the value. Useful for debugging.
    static var dumped: DumpedFormatStyle<FormatInput> {
        DumpedFormatStyle()
    }
}
