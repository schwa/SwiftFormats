//
//  StringFormattable.swift
//  
//
//  Created by brett ohland on 02/04/23.
//

import Foundation

public protocol StringFormattable: Formattable where Format.FormatOutput == String {}
