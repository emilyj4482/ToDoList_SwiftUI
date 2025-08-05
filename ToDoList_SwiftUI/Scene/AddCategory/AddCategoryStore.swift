//
//  AddCategoryViewModel.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/05.
//

import Foundation

final class AddCategoryStore: ObservableObject {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func send(_ intent: AddCategoryIntent) {
        reduce(intent)
    }
    
    private func reduce(_ intent: AddCategoryIntent) {
        switch intent {
        case .addCategory(let input):
            repository.createCategory(with: input)
        }
    }
}
