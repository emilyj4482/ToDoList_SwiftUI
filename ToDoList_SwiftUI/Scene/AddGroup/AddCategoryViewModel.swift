//
//  AddCategoryViewModel.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/05.
//

import Foundation

final class AddCategoryViewModel: ObservableObject {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
}
