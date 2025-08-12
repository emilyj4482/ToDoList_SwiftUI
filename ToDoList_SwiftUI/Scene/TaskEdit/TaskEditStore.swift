//
//  TaskEditStore.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/06.
//

import Foundation

final class TaskEditStore: ObservableObject {
    private let repository: TodoRepository
    
    init(repository: TodoRepository, mode: TaskEditMode) {
        self.repository = repository
        self.state = TaskEditState(mode: mode)
    }
    
    @Published private(set) var state: TaskEditState
    
    func send(_ intent: TaskEditIntent) {
        reduce(intent)
    }
    
    private func reduce(_ intent: TaskEditIntent) {
        switch intent {
        case .createTask(let categoryID, let input):
            repository.createTask(input: input, to: categoryID)
        case .retitleTask(let input):
            print(input)
        }
    }
}
