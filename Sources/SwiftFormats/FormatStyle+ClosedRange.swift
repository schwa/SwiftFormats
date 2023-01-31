import Foundation
import RegexBuilder

public struct ClosedRangeFormatStyle <Bound, Substyle>: FormatStyle where Bound: Comparable, Substyle: FormatStyle, Substyle.FormatInput == Bound, Substyle.FormatOutput == String {

    public var substyle: Substyle
    public var delimiter: String? = "..."

    public init(substyle: Substyle, delimiter: String? = "...") {
        self.substyle = substyle
        self.delimiter = delimiter
    }

    public func format(_ value: ClosedRange<Bound>) -> String {
        let parts = [
            substyle.format(value.lowerBound),
            delimiter,
            substyle.format(value.upperBound),
        ]
        return parts.compactMap({ $0 }).joined(separator: " ")
    }
}

extension ClosedRangeFormatStyle: ParseableFormatStyle where Substyle: ParseableFormatStyle {
    public var parseStrategy: ClosedRangeParseStrategy<Bound, Substyle.Strategy> {
        return ClosedRangeParseStrategy(substrategy: substyle.parseStrategy)
    }
}

public struct ClosedRangeParseStrategy <Bound, Substrategy>: ParseStrategy where Bound: Comparable, Substrategy: ParseStrategy, Substrategy.ParseInput == String, Substrategy.ParseOutput == Bound {

    public var substrategy: Substrategy
    public var delimiters: [String]

    public enum ParseError: Error {
        case parseError
    }

    public init(substrategy: Substrategy, delimiters: [String] = ["...", "-"]) {
        self.substrategy = substrategy
        self.delimiters = delimiters
    }

    public func parse(_ value: String) throws -> ClosedRange<Bound> {
        // (?<lowerBound>.+?)\s*(?:\.\.\.|\-)\s*(?<upperBound>.+?)
        let lowerBoundReference = Reference(Substring.self)
        let upperBoundReference = Reference(Substring.self)
        let pattern = Regex {
            Capture(as: lowerBoundReference) {
                //OneOrMore(.reluctant, .any)
                OneOrMore(.any)
            }
            ZeroOrMore(.whitespace)
            delimiters
            ZeroOrMore(.whitespace)
            Capture(as: upperBoundReference) {
                OneOrMore(.any)
//                OneOrMore(.reluctant, .any)
            }
        }

        guard let match = value.firstMatch(of: pattern) else {
            throw ParseError.parseError
        }

        let lowerBound = match[lowerBoundReference]
        let upperBound = match[upperBoundReference]

        return try substrategy.parse(String(lowerBound)) ... substrategy.parse(String(upperBound))
    }
}

public extension ClosedRangeParseStrategy {
    func delimiters(_ delimiters: [String]) -> Self {
        var copy = self
        copy.delimiters = delimiters
        return copy
    }
}



extension Array: RegexComponent where Element == String {
    public var regex: Regex<Substring> {

        guard let first else {
            fatalError()
        }

        return Regex {
            dropFirst().reduce(AlternationBuilder.buildPartialBlock(first: first)) { regex, element in
                return AlternationBuilder.buildPartialBlock(accumulated: regex, next: element)
            }
        }
    }
}
