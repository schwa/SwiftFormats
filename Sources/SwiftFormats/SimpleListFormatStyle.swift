import Foundation

public struct SimpleListFormatStyle <Element, Substyle>: ParseableFormatStyle where Substyle: ParseableFormatStyle, Element == Substyle.FormatInput, Substyle.FormatOutput == String {

    // TODO: provide user separator

    public var parseStrategy: SimpleListParseStrategy <Element, Substyle.Strategy> {
        SimpleListParseStrategy(substrategy: substyle.parseStrategy)
    }

    public var substyle: Substyle

    public init(substyle: Substyle) {
        self.substyle = substyle
    }

    public func format(_ value: [Element]) -> String {
        return value.map { substyle.format($0) }.joined(separator: ", ")
    }
}

// MARK: -

public struct SimpleListParseStrategy <Element, Substrategy>: ParseStrategy where Substrategy: ParseStrategy, Element == Substrategy.ParseOutput, Substrategy.ParseInput == String {

    // TODO: allow skipping , and just split by whitespace
    // TODO: provide user separator

    public private(set) var substrategy: Substrategy

    public init(substrategy: Substrategy) {
        self.substrategy = substrategy
    }

    public func parse(_ value: String) throws -> [Element] {
        let components = try value
            .split(separator: ",", omittingEmptySubsequences: false)
            .map {
                try substrategy.parse(String($0))
            }
        return components
    }
}

