//
//  MainView.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/05/13.
//  Refactored by EMILY on 2025/08/05.

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel: MainViewModel
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        _viewModel = StateObject(wrappedValue: MainViewModel(repository: repository))
    }
    
    var body: some View {
        List {
            
        }
        .navigationDestination(for: Category.self) { category in
            TaskListView(repository: repository, categoryID: category.id)
        }
    }
}

#Preview {
    MainView(repository: .init())
}
