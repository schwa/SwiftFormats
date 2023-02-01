@_implementationOnly import Algorithms
import Foundation

// TODO: Remove FormatInput.Index == Int restriction

/// Hex dump `DataProtocol``
public struct HexdumpFormatStyle<FormatInput>: FormatStyle where FormatInput: DataProtocol, FormatInput.Index == Int {

    public typealias FormatInput = FormatInput
    public typealias FormatOutput = String

    public var width: Int
    public var baseAddress: Int
    public var separator: String
    public var terminator: String

    /// - Parameters:
    ///   - width: Number of octets per line.
    ///   - baseAddress:  Base address to use for the first line.
    ///   - separator: Separator string to use between lines.
    ///   - terminator: Terminator string to use after the last line.
    public init(width: Int = 16, baseAddress: Int = 0, separator: String = "\n", terminator: String = "") {
        self.width = width
        self.baseAddress = baseAddress
        self.separator = separator
        self.terminator = terminator
    }

    public func format(_ buffer: FormatInput) -> String {
        var string = ""
        for index in stride(from: 0, through: buffer.count, by: width) {
            let address = UInt(baseAddress + index).formatted(.hex.leadingZeros().prefix(.none))

            let chunk = buffer[index ..< (index + min(width, buffer.count - index))]
            if chunk.isEmpty {
                break
            }
            let hex = chunk.map {
                $0.formatted(.hex.leadingZeros())
            }
            .joined(separator: " ")
            .padding(toLength: width * 3 - 1, withPad: " ", startingAt: 0)

            let part = chunk.map { (c: UInt8) -> String in
                let scalar = UnicodeScalar(c)
                let character = Character(scalar)
                return isprint(Int32(c)) != 0 ? String(character) : "?"
            }
            .joined()

            string.write("\(address)  \(hex)  \(part)")
            string.write(separator)
        }
        string.write(terminator)
        return string
    }
}

public extension FormatStyle where Self == HexdumpFormatStyle<Data> {
    static func hexdump(width: Int = 16, baseAddress: Int = 0, separator: String = "\n", terminator: String = "") -> Self {
        HexdumpFormatStyle(width: width, baseAddress: baseAddress, separator: separator, terminator: terminator)
    }
}

public extension FormatStyle where Self == HexdumpFormatStyle<[UInt8]> {
    static func hexdump(width: Int = 16, baseAddress: Int = 0, separator: String = "\n", terminator: String = "") -> Self {
        HexdumpFormatStyle(width: width, baseAddress: baseAddress, separator: separator, terminator: terminator)
    }
}
