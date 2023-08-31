//
//  Group.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/08/29.
//

import Foundation

struct Group: Identifiable, Codable, Hashable {
    let id: Int
    var name: String
    var tasks: [Task]
    
    mutating func update(name: String) {
        self.name = name
    }
}
