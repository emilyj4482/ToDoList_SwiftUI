//
//  Category.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/08/29.
//

import Foundation

// List, Group은 SwiftUI 예약어라 사용 불가능
struct Category: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var tasks: [Task]
    
    mutating func rename(to name: String) {
        self.name = name
    }
    
    static let defaultImportantCategory: Category = Category(name: "Important", tasks: [])
}
