//
//  Task.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/05/12.
//

import Foundation

struct Task: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let categoryID: Int
    var title: String
    var isDone: Bool
    var isImportant: Bool
    
    mutating func update(title: String, isDone: Bool, isImportant: Bool) {
        self.title = title
        self.isDone = isDone
        self.isImportant = isImportant
    }
}
