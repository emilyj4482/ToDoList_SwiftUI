//
//  TaskListView.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/05/16.
//  Refactored by EMILY on 2025/08/05.

import SwiftUI

struct TaskListView: View {
    
    @StateObject var store: TaskListStore
    private let repository: TodoRepository
    
    init(repository: TodoRepository, category: Category) {
        self.repository = repository
        _store = StateObject(wrappedValue: TaskListStore(repository: repository, category: category))
    }
    
    var body: some View {
        VStack {
            
        }
    }
}
