import Foundation

// TODO: Localisation?

public struct BoolFormatStyle: FormatStyle {
    
    var falseString: String
    var trueString: String
    
    public init(_ falseString: String = "false", _ trueString: String = "true") {
        self.falseString = falseString
        self.trueString = trueString
    }
    
    public func format(_ value: Bool) -> String {
        switch value {
        case true:
            return trueString
        case false:
            return falseString
        }
    }
}

public extension BoolFormatStyle {

    func values(_ falseString: String = "false", _ trueString: String = "true") -> Self {
        return self.false(falseString).true(trueString)
    }

    func `true`(_ string: String) -> Self {
        var copy = self
        copy.trueString = string
        return copy
    }

    func `false`(_ string: String) -> Self {
        var copy = self
        copy.falseString = string
        return copy
    }
}

public extension FormatStyle where Self == BoolFormatStyle {
    static var bool: BoolFormatStyle {
        return BoolFormatStyle()
    }
}

public extension Bool {
    func formatted() -> String {
        return formatted(.bool)
    }
    
    func formatted<S>(_ style: S) -> S.FormatOutput where S: FormatStyle, S.FormatInput == Bool {
        return style.format(self)
    }
}

// MARK: -

public struct BoolParseStrategy: ParseStrategy {

    public init() {
    }

    // This is really quick and simple.
    public func parse(_ value: String) throws -> Bool {
        let value = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch value {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            throw SwiftFormatsError.parseError
        }
    }
}

extension BoolFormatStyle: ParseableFormatStyle {
    public var parseStrategy: BoolParseStrategy {
        return BoolParseStrategy()
    }
}
