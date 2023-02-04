//
//  StringParseable.swift
//  
//
//  Created by brett ohland on 02/04/23.
//

import Foundation

/// Describes the ability to parse a given type from a String
public protocol StringParseable: Parseable where Format.Strategy.ParseInput == String, Format.Strategy.ParseOutput == Self {}

public extension StringParseable where Format.FormatInput == Self {
    init<ParseInput>(_ input: ParseInput) throws where ParseInput: StringProtocol {
        self = try Format().parseStrategy.parse(String(input))
    }
}
