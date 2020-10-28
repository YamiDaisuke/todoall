//
//  Struct+TypeName.swift
//  TodoAll
//
//  Created by Franklin Cruz on 27-10-20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import Foundation

extension Identifiable {
    static var typeName: String {
        return String(describing: Self.self)
    }
}
