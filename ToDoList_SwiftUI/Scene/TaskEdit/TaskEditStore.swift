//
//  TaskEditStore.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/06.
//

import Foundation

final class TaskEditStore: ObservableObject {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
}
