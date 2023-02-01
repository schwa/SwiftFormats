import Foundation

// TODO: This could work with any Sequence and only the ParseableFormatStyle needs to restrict to an Array
/// A format style that formats a list of elements by formatting each element with a substyle and joining them with a separator.
public struct SimpleListFormatStyle <Element, Substyle>: FormatStyle where Substyle: FormatStyle, Element == Substyle.FormatInput, Substyle.FormatOutput == String {

    public var substyle: Substyle
    public var separator: String
    public var prefix: String?
    public var suffix: String?

    public init(substyle: Substyle, separator: String = ", ", prefix: String? = nil, suffix: String? = nil) {
        self.substyle = substyle
        self.separator = separator
        self.prefix = prefix
        self.suffix = suffix
    }

    public func format(_ value: [Element]) -> String {
        return (prefix ?? "") + value.map { substyle.format($0) }.joined(separator: separator) + (suffix ?? "")
    }
}

extension SimpleListFormatStyle: ParseableFormatStyle where Substyle: ParseableFormatStyle {
    public var parseStrategy: SimpleListParseStrategy <Element, Substyle.Strategy> {
        SimpleListParseStrategy(substrategy: substyle.parseStrategy)
    }
}

// MARK: -

/// A parse strategy that parses a list of elements by parsing each element with a substrategy and splitting them by a separator.
public struct SimpleListParseStrategy <Element, Substrategy>: ParseStrategy where Substrategy: ParseStrategy, Element == Substrategy.ParseOutput, Substrategy.ParseInput == String {

    // TODO: allow skipping , and just split by whitespace
    // TODO: provide user separator

    public enum ParseError: Error {
        case countError
    }

    public private(set) var substrategy: Substrategy

    public var countRange: ClosedRange <Int> = .zero ... .max

    public init(substrategy: Substrategy) {
        self.substrategy = substrategy
    }

    /// TODO: this will totally break when the substrategy emits commas (e.g. localisation that use commas as digit group separators) 
    public func parse(_ value: String) throws -> [Element] {
        let components = try value
            .split(separator: ",", omittingEmptySubsequences: false)
            .map {
                try substrategy.parse(String($0))
            }

        guard countRange.contains(components.count) else {
            throw ParseError.countError
        }
        return components
    }
}
