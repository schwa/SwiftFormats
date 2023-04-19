import Foundation

internal struct SimpleMappingFormatStyle <Value, ValueStyle>: FormatStyle where ValueStyle: FormatStyle, ValueStyle.FormatInput == Value, ValueStyle.FormatOutput == String {

    let valueStyle: ValueStyle
    let listStyle: SimpleListFormatStyle<String, IdentityFormatStyle<String>>

    init(valueStyle: ValueStyle, separator: String = ", ", prefix: String? = nil, suffix: String? = nil) {
        self.valueStyle = valueStyle
        self.listStyle = SimpleListFormatStyle(substyle: IdentityFormatStyle(), separator: separator, prefix: prefix, suffix: suffix)
    }

    func format(_ value: [(String, Value)]) -> String {
        let values = value.map { (key, value) in
            return "\(key): \(value, format: valueStyle)"
        }
        return listStyle.format(values)
    }
}

internal extension SimpleMappingFormatStyle where Value == String, ValueStyle == IdentityFormatStyle<Value> {
    init() {
        self = .init(valueStyle: IdentityFormatStyle<String>())
    }
}

extension SimpleMappingFormatStyle: ParseableFormatStyle where ValueStyle: ParseableFormatStyle {
    var parseStrategy: SimpleMappingParseStrategy<Value, ValueStyle.Strategy> {
        return SimpleMappingParseStrategy()
    }
}

internal struct SimpleMappingParseStrategy <Value, Substrategy>: ParseStrategy where Substrategy: ParseStrategy, Substrategy.ParseInput == String, Substrategy.ParseOutput == Value {
    func parse(_ value: String) throws -> [(String, Value)] {
        unimplemented()
    }
}
