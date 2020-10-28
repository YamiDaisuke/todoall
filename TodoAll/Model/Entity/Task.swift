//
//  Task.swift
//  TodoAll
//
//  Created by Franklin Cruz on 22/10/20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import UIKit

struct Task: Identifiable, Codable {
    var id: Int
    var title: String
    var description: String?
    var dueDate: Date?
    var duration: TimeInterval?
    var tags: [String] = []
    var completed = false
}
