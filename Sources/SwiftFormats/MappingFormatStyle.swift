import Foundation

public struct MappingFormatStyle <Key, Value, KeyStyle, ValueStyle>: FormatStyle where KeyStyle: FormatStyle, KeyStyle.FormatInput == Key, KeyStyle.FormatOutput == String, ValueStyle: FormatStyle, ValueStyle.FormatInput == Value, ValueStyle.FormatOutput == String {

    let listStyle: SimpleListFormatStyle<(Key, Value), TupleFormatStyle<Key, Value, KeyStyle, ValueStyle>>
    let keyValueSeparator: String
    let itemSeparator: String

    public init(keyStyle: KeyStyle, valueStyle: ValueStyle, keyValueSeparator: String = ":", itemSeparator: String = ", ") {
        self.keyValueSeparator = keyValueSeparator
        self.itemSeparator = itemSeparator
        let keyValueStyle = TupleFormatStyle(type: (Key, Value).self, separator: keyValueSeparator, substyle0: keyStyle, substyle1: valueStyle)
        self.listStyle = SimpleListFormatStyle(substyle: keyValueStyle, separator: itemSeparator)
    }

    public func format(_ value: [(Key, Value)]) -> String {
        return listStyle.format(Array(value))
    }
}

// MARK: -

public extension MappingFormatStyle {
    public init(keyType: Key.Type, valueType: Value.Type, keyStyle: KeyStyle, valueStyle: ValueStyle, keyValueSeparator: String = ":", itemSeparator: String = ", ") {
        self.init(keyStyle: keyStyle, valueStyle: valueStyle, keyValueSeparator: keyValueSeparator, itemSeparator: itemSeparator)
    }

}

public extension MappingFormatStyle where Key == String, KeyStyle == IdentityFormatStyle<Key> {
    init(valueStyle: ValueStyle, keyValueSeparator: String = ":", itemSeparator: String = ", ") {
        self = .init(keyStyle: IdentityFormatStyle<String>(), valueStyle: valueStyle, keyValueSeparator: keyValueSeparator)
    }
}

extension MappingFormatStyle: ParseableFormatStyle where KeyStyle: ParseableFormatStyle, ValueStyle: ParseableFormatStyle {
    public var parseStrategy: MappingParseStrategy<Key, Value, KeyStyle.Strategy, ValueStyle.Strategy> {
        return MappingParseStrategy(listStrategy: listStyle.parseStrategy, keyValueSeparator: keyValueSeparator, itemSeparator: itemSeparator)
    }
}

// MARK: -

public struct MappingParseStrategy <Key, Value, KeyStrategy, ValueStrategy>: ParseStrategy where KeyStrategy: ParseStrategy, KeyStrategy.ParseInput == String, KeyStrategy.ParseOutput == Key, ValueStrategy: ParseStrategy, ValueStrategy.ParseInput == String, ValueStrategy.ParseOutput == Value {
    public typealias ListStrategy = SimpleListParseStrategy<(Key, Value), TupleParseStrategy<Key, Value, KeyStrategy, ValueStrategy>>
    let listStrategy: ListStrategy
    let keyValueSeparator: String
    let itemSeparator: String

    public init(listStrategy: ListStrategy, keyValueSeparator: String = ":", itemSeparator: String = ", ") {
        self.listStrategy = listStrategy
        self.keyValueSeparator = keyValueSeparator
        self.itemSeparator = itemSeparator

    }

    public func parse(_ value: String) throws -> [(Key, Value)] {
        return try listStrategy.parse(value)
    }
}
