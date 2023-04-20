import Foundation
@_implementationOnly import RegexBuilder

public struct TupleFormatStyle <Element0, Element1, Substyle0, Substyle1>: FormatStyle where Substyle0: FormatStyle, Substyle1: FormatStyle, Element0 == Substyle0.FormatInput, Substyle0.FormatOutput == String, Element1 == Substyle1.FormatInput, Substyle1.FormatOutput == String {
    public typealias FormatInput = (Element0, Element1)
    public typealias FormatOutput = String

    var separator: String
    var substyle0: Substyle0
    var substyle1: Substyle1

    public init(type: (Element0, Element1).Type, separator: String, substyle0: Substyle0, substyle1: Substyle1) {
        self.separator = separator
        self.substyle0 = substyle0
        self.substyle1 = substyle1
    }

    public func format(_ value: (Element0, Element1)) -> String {
        return substyle0.format(value.0) + separator + substyle1.format(value.1)
    }
}

extension TupleFormatStyle: ParseableFormatStyle where Substyle0: ParseableFormatStyle, Substyle1: ParseableFormatStyle {
    public var parseStrategy: TupleParseStrategy <Element0, Element1, Substyle0.Strategy, Substyle1.Strategy> {
        TupleParseStrategy(type: (Element0, Element1).self, separators: [separator.trimmingCharacters(in: .whitespaces)], substrategy0: substyle0.parseStrategy, substrategy1: substyle1.parseStrategy)
    }
}

// MARK: -

public struct TupleParseStrategy <Element0, Element1, Substrategy0, Substrategy1>: ParseStrategy where Substrategy0: ParseStrategy, Substrategy0.ParseInput == String, Substrategy0.ParseOutput == Element0, Substrategy1: ParseStrategy, Substrategy1.ParseInput == String, Substrategy1.ParseOutput == Element1 {

    public typealias ParseInput = String
    public typealias ParseOutput = (Element0, Element1)

    var separators: [String]
    var disallowWhitespace: Bool
    var substrategy0: Substrategy0
    var substrategy1: Substrategy1

    public enum ParseError: Error {
        case parseError
    }

    public init(type: (Element0, Element1).Type, separators: [String], disallowWhitespace: Bool = false, substrategy0: Substrategy0, substrategy1: Substrategy1) {
        self.separators = separators
        self.disallowWhitespace = disallowWhitespace
        self.substrategy0 = substrategy0
        self.substrategy1 = substrategy1
    }

    public func parse(_ value: String) throws -> (Element0, Element1) {
        let string0: String
        let string1: String
        if disallowWhitespace {
            let regex = Regex {
                #/^/#
                Capture {
                    ZeroOrMore {
                        .any
                    }
                    One(.horizontalWhitespace.inverted)
                }
                ChoiceOf {
                    separators
                }
                Capture {
                    One(.horizontalWhitespace.inverted)
                    ZeroOrMore {
                        .any
                    }
                }
                #/$/#
            }
            guard let match = value.firstMatch(of: regex) else {
                throw ParseError.parseError
            }
            string0 = String(match.output.1)
            string1 = String(match.output.2)
        }
        else {
            let regex = Regex {
                #/^/#
                Capture {
                    OneOrMore(.reluctant) {
                        .any
                    }
                }
                ZeroOrMore(.horizontalWhitespace)
                ChoiceOf {
                    separators
                }
                ZeroOrMore(.horizontalWhitespace)
                Capture {
                    OneOrMore(.reluctant) {
                        .any
                    }
                }
                #/$/#
            }

            guard let match = value.firstMatch(of: regex) else {
                throw ParseError.parseError
            }
            string0 = String(match.output.1)
            string1 = String(match.output.2)
        }
        let element0 = try substrategy0.parse(string0)
        let element1 = try substrategy1.parse(string1)
        return (element0, element1)
    }
}

// MARK: -

public extension TupleParseStrategy {
    func separators(_ separators: [String]) -> Self {
        var copy = self
        copy.separators = separators
        return copy
    }

    func disallowingWhitespace() -> Self {
        var copy = self
        copy.disallowWhitespace = true
        return copy
    }
}
