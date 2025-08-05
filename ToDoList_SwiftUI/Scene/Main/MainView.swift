//
//  MainView.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/05/13.
//  Refactored by EMILY on 2025/08/05.

import SwiftUI

struct MainView: View {
    
    @StateObject private var store: MainStore
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
        _store = StateObject(wrappedValue: MainStore(repository: repository))
    }
    
    var body: some View {
        VStack {
            // Categories List
            List {
                ForEach(store.state.categories) { category in
                    NavigationLink(value: category) {
                        HStack {
                            Image(systemName: iconName(for: category))
                            Text(category.name)
                            Spacer()
                            Text("\(category.tasks.count)")
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .listStyle(.plain)
            
            VStack(spacing: 15) {
                // Category count Label
                Text(countLabel(for: store.state.categories.count))
                    .font(.system(size: 13))
                    .foregroundStyle(.tint)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // + New Category Button
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("New Category")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .navigationTitle("ToDoList")
        .navigationDestination(for: Category.self) { category in
            TaskListView(repository: repository, category: category)
        }
    }
}

extension MainView {
    private func iconName(for category: Category) -> String {
        category.name == "Important" ? "star.fill" : "checklist.checked"
    }
    
    private func countLabel(for count: Int) -> String {
        if count < 3 {
            return "You have \(count - 1) custom category."
        } else {
            return "You have \(count - 1) custom categories."
        }
    }
}
