import Foundation

// TODO: Make public and put in a doc explain why this is necessary :-(
public struct IdentityFormatStyle <Value>: FormatStyle {
    public init() {
    }

    public func format(_ value: Value) -> Value {
        return value
    }
}

extension IdentityFormatStyle: ParseableFormatStyle {
    public var parseStrategy: IdentityParseStategy <Value> {
        return IdentityParseStategy()
    }
}

public struct IdentityParseStategy <Value>: ParseStrategy {
    public init() {
    }
    public func parse(_ value: Value) throws -> Value {
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

    // swiftlint:disable:next unavailable_function
    static func == (lhs: Self, rhs: Self) -> Bool {
        fatalError("Unimplemented")
    }

    // swiftlint:disable:next unavailable_function
    func hash(into hasher: inout Hasher) {
        fatalError("Unimplemented")
    }

    // swiftlint:disable:next unavailable_function
    init(from decoder: Decoder) throws {
        fatalError("Unimplemented")
    }

    // swiftlint:disable:next unavailable_function
    func encode(to encoder: Encoder) throws {
        fatalError("Unimplemented")
    }
}
