//
//  Category.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/08/29.
//

import Foundation

// List, Group은 SwiftUI 예약어라 사용 불가능
struct Category: Identifiable, Codable, Hashable {
    let id: Int
    var name: String
    var tasks: [Task]
    
    mutating func update(name: String) {
        self.name = name
    }
}
