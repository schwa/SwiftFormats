import Foundation

// TODO: Make public and put in a doc explain why this is necessary :-(
internal struct IdentityFormatStyle <Value>: FormatStyle {
    func format(_ value: Value) -> Value {
        return value
    }
}

// TODO: Again annoyed that FormatStyle has to be Hashable/Codable. Also need to do a AnyParseableFormatStyle
internal struct AnyFormatStyle <FormatInput, FormatOutput>: FormatStyle {
    var closure: (FormatInput) -> FormatOutput

    init(_ closure: @escaping (FormatInput) -> FormatOutput) {
        self.closure = closure
    }

    func format(_ value: FormatInput) -> FormatOutput {
        return closure(value)
    }

    // MARK: -

    static func == (lhs: Self, rhs: Self) -> Bool {
        fatalError()
    }

    func hash(into hasher: inout Hasher) {
        fatalError()
    }

    init(from decoder: Decoder) throws {
        fatalError()
    }

    func encode(to encoder: Encoder) throws {
        fatalError()
    }
}

// MARK: -

// TODO: Make generic. Add subformatters.
internal struct SimpleMappingFormatStyle <Value, Substyle>: FormatStyle where Substyle: FormatStyle, Substyle.FormatInput == Value, Substyle.FormatOutput == String {

    let substyle: Substyle

    // TODO: Expose SimpleListFormatStyle options.

    init(substyle: Substyle) {
        self.substyle = substyle
    }

    func format(_ value: [(String, Value)]) -> String {
        let values = value.map { (key, value) in
            return "\(key): \(value, format: substyle)"
        }
        return SimpleListFormatStyle(substyle: IdentityFormatStyle()).format(values)
    }
}

internal extension SimpleMappingFormatStyle where Value == String, Substyle == IdentityFormatStyle<Value> {
    init() {
        self = .init(substyle: IdentityFormatStyle<String>())
    }
}

extension SimpleMappingFormatStyle: ParseableFormatStyle where Substyle: ParseableFormatStyle {
    var parseStrategy: SimpleMappingParseStrategy<Value, Substyle.Strategy> {
        // TODO: Pass down configuration
        return SimpleMappingParseStrategy()
    }
}

internal struct SimpleMappingParseStrategy <Value, Substrategy>: ParseStrategy where Substrategy: ParseStrategy, Substrategy.ParseInput == String, Substrategy.ParseOutput == Value {
    func parse(_ value: String) throws -> [(String, Value)] {
        unimplemented()
    }
}
