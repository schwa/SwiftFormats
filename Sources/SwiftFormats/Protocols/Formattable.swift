//
//  Formattable.swift
//  
//
//  Created by brett ohland on 02/04/23.
//

import Foundation

public protocol Formattable {
    associatedtype Format: InitializableFormatStyle
}

public protocol InitializableFormatStyle: ParseableFormatStyle {
    init()
}

public extension Formattable {
    func formatted(_ format: Format) -> Format.FormatOutput where Format.FormatInput == Self {
        format.format(self)
    }

    func formatted() -> Format.FormatOutput where Format.FormatInput == Self {
        Format().format(self)
    }
}
