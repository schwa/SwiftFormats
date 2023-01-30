@_implementationOnly import Algorithms
import Foundation

// public struct HexdumpFormatStyle<FormatInput>: FormatStyle where FormatInput: DataProtocol, FormatInput.Index == Int {
//    public typealias FormatInput = FormatInput
//    public typealias FormatOutput = String
//
//    public func format(_ value: FormatInput) -> String {
//        var s = ""
////        hexdump(value, stream: &s)
//        fatalError()
//        return s
//    }
// }
//
// public extension FormatStyle where Self == HexdumpFormatStyle<Data> {
//    static var hexdump: Self {
//        HexdumpFormatStyle()
//    }
// }
//
// public extension FormatStyle where Self == HexdumpFormatStyle<[UInt8]> {
//    static var hexdump: Self {
//        HexdumpFormatStyle()
//    }
// }

// Now do this for all DataProtocol types

//// TODO: Remove Buffer.index == Int restriction
//// TODO: Can we use DataProtocol instead?
//// swiftlint:disable:next line_length
// public func hexdump<Buffer>(_ buffer: Buffer, width: Int = 16, baseAddress: Int = 0, separator: String = "\n", terminator: String = "", stream: inout some TextOutputStream) where Buffer: RandomAccessCollection, Buffer.Element == UInt8, Buffer.Index == Int {
//    for index in stride(from: 0, through: buffer.count, by: width) {
//        let address = UInt(baseAddress + index).formatted(.hex.leadingZeros().prefix(.none))
//        let chunk = buffer[index ..< (index + min(width, buffer.count - index))]
//        if chunk.isEmpty {
//            break
//        }
//        let hex = chunk.map {
//            $0.formatted(.hex.leadingZeros())
//        }
//            .joined(separator: " ")
//        let paddedHex = hex.padding(toLength: width * 3 - 1, withPad: " ", startingAt: 0)
//
//        let string = chunk.map { (c: UInt8) -> String in
//            let scalar = UnicodeScalar(c)
//
//            let character = Character(scalar)
//            if isprint(Int32(c)) != 0 {
//                return String(character)
//            }
//            else {
//                return "?"
//            }
//        }
//            .joined()
//
//        stream.write("\(address)  \(paddedHex)  \(string)")
//        stream.write(separator)
//    }
//    stream.write(terminator)
// }

// public func hexdump<Buffer>(_ buffer: Buffer, width: Int = 16, baseAddress: Int = 0) where Buffer: RandomAccessCollection, Buffer.Element == UInt8, Buffer.Index == Int {
//    var string = String()
//    hexdump(buffer, width: width, baseAddress: baseAddress, stream: &string)
//    print(string)
// }

//
// public extension Collection<UInt8> {
//    func hexDump() {
//        let offsetFormatter = RadixedIntegerFormatStyle<Int>(radix: 16, prefix: .none, leadingZeros: true, groupCount: nil, groupSeparator: "_", uppercase: true)
//        let byteFormatter = RadixedIntegerFormatStyle<UInt8>(radix: 16, leadingZeros: true, uppercase: true)
//        let bytesPerChunk = 16
//        let s = chunks(ofCount: bytesPerChunk).enumerated()
//            .map { offset, chunk -> [String] in
//                let offset = offsetFormatter.format(offset * bytesPerChunk)
//                let bytes = chunk.map { byteFormatter.format($0) }.extend(repeating: "  ", to: bytesPerChunk).joined(separator: " ")
//                let ascii = chunk.escapedAscii()
//                return [offset, bytes, ascii]
//            }
//            .map { $0.joined(separator: " | ") }
//            .joined(separator: "\n")
//        print(s)
//    }
// }
