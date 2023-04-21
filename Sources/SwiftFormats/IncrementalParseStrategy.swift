import Foundation

public protocol IncrementalParseStrategy: ParseStrategy {
    func incrementalParse(_ value: inout Self.ParseInput) throws -> Self.ParseOutput
}
