//
//  ServiceError.swift
//  TodoAll
//
//  Created by Franklin Cruz on 22/10/20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import UIKit

struct ServiceError: Error {
    var code: Int
    var message: String
}
