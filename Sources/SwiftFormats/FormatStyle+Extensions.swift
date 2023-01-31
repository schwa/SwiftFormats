//
//  File.swift
//  
//
//  Created by Jonathan Wight on 1/30/23.
//

import Foundation

public extension ListFormatStyle {
    /// Convenience method to fully create a `ListFormatStyle`
    init(_ base: Base.Type, style: Style, width: Self.Width = .narrow, listType: Self.ListType = .and) {
        self = .init(memberStyle: style)
        self.width = width
        self.listType = listType
    }
}
