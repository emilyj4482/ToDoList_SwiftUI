//
//  Task.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/12.
//

import Foundation

/* Model */

// 할 일 Object
struct Task: Codable, Hashable {
    let id: Int
    let groupId: Int
    var title: String
    var isDone: Bool
    var isImportant: Bool
    
    mutating func update(title: String, isDone: Bool, isImportant: Bool) {
        self.title = title
        self.isDone = isDone
        self.isImportant = isImportant
    }
}

// 할 일 그룹 Object
struct Group: Codable, Hashable {
    let id: Int
    var name: String
    var tasks: [Task]
    
    mutating func update(name: String) {
        self.name = name
    }
}
