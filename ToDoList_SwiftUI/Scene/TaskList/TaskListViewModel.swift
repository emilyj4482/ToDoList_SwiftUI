//
//  TaskListViewModel.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/05.
//

import Foundation

final class TaskListViewModel: ObservableObject {
    private let repository: TodoRepository
    private let categoryID: Int
    
    init(repository: TodoRepository, categoryID: Int) {
        self.repository = repository
        self.categoryID = categoryID
    }
}
