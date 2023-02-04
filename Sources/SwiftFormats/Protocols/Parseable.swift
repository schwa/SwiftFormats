//
//  Parseable.swift
//  
//
//  Created by brett ohland on 02/04/23.
//

import Foundation

public protocol Parseable: Formattable {}

public extension Parseable {
    init<ParseInput, Format>(_ input: ParseInput, format: Format) throws where Format: ParseableFormatStyle, ParseInput == Format.Strategy.ParseInput, Self == Format.Strategy.ParseOutput {
        self = try format.parseStrategy.parse(input)
    }
    init<ParseInput, Strategy>(_ input: ParseInput, strategy: Strategy) throws where Strategy: ParseStrategy, ParseInput == Strategy.ParseInput, Self == Strategy.ParseOutput {
        self = try strategy.parse(input)
    }
}
