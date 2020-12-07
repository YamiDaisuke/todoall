//
//  Entity.swift
//  TodoAll
//
//  Created by Franklin Cruz on 07-12-20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import UIKit

protocol Entity: Identifiable, Codable {
    var id: Self.ID { get set }
}
