//
//  TaskListView.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/05/16.
//  Refactored by EMILY on 2025/08/05.

import SwiftUI

struct TaskListView: View {
    
    @StateObject var viewModel: TaskListViewModel
    private let repository: TodoRepository
    
    init(repository: TodoRepository, categoryID: Int) {
        _viewModel = StateObject(wrappedValue: TaskListViewModel(repository: repository, categoryID: categoryID))
    }
    
    var body: some View {
        VStack {
            
        }
    }
}
