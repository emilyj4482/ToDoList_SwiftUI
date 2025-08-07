//
//  Task.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/05/12.
//

import Foundation

struct Task: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    let categoryID: UUID
    var title: String
    var isDone: Bool = false
    var isImportant: Bool = false
    
    mutating func retitle(to title: String) {
        self.title = title
    }
    
    mutating func toggleDone() {
        isDone.toggle()
    }
    
    mutating func toggleImportant() {
        isImportant.toggle()
    }
}
