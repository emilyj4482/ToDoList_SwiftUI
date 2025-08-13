//
//  TaskListStore.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/05.
//

import Foundation
import Combine

final class TaskListStore: ObservableObject {
    private let repository: TodoRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: TodoRepository, category: Category) {
        self.repository = repository
        self.state = TaskListState(category: category)
        
        bind(with: category)
    }
    
    @Published private(set) var state: TaskListState
    
    private func bind(with category: Category) {
        Publishers.CombineLatest(
            repository.$categories.compactMap { categories in
                categories.first { $0.id == category.id }
            },
            repository.$error
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] updatedCategory, error in
            self?.state = TaskListState(category: updatedCategory, error: error)
        }
        .store(in: &cancellables)
    }
    
    func send(_ intent: TaskListIntent) {
        reduce(intent)
    }
    
    private func reduce(_ intent: TaskListIntent) {
        switch intent {
        case .renameCategory(let input):
            repository.rename(category: state.category, to: input)
        case .toggleTaskDone(let task):
            repository.toggleTaskDone(task: task)
        case .toggleTaskImportant(let task):
            repository.toggleTaskImportant(task: task)
        case .deleteTask(task: let task):
            repository.deleteTask(task)
        case .sendTaskInfo(task: let task):
            state.setTask(task)
        }
    }
}
