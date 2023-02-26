import Foundation

public protocol IncrementalParseStrategy: ParseStrategy {
    // TODO: It may be better to restrict ParseInput to a type that supports API like SubString
    func incrementalParse(_ value: inout Self.ParseInput) throws -> Self.ParseOutput
}
