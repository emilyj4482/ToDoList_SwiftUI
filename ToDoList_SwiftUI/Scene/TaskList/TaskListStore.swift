//
//  TaskListViewModel.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/05.
//

import Foundation

final class TaskListStore: ObservableObject {
    private let repository: TodoRepository
    
    init(repository: TodoRepository, category: Category) {
        self.repository = repository
        self.state = TaskListState(category: category)
    }
    
    @Published private(set) var state: TaskListState
    
    func send(_ intent: TaskListIntent) {
        reduce(intent)
    }
    
    private func reduce(_ intent: TaskListIntent) {
        switch intent {
        case .renameCategory(let input):
            print(input)
        }
    }
}
