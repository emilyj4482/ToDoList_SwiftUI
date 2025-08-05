//
//  TaskListViewModel.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/05.
//

import Foundation

final class TaskListStore: ObservableObject {
    private let repository: TodoRepository
    private let category: Category
    
    init(repository: TodoRepository, category: Category) {
        self.repository = repository
        self.category = category
    }
}
