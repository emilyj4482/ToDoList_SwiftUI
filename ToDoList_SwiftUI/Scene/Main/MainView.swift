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
    
    @State private var showAddView: Bool = false
    @State private var showActionSheet: Bool = false
    @State private var categoryIDToDelete: UUID?
    
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
                        .swipeActions(allowsFullSwipe: false) {
                            // Important category는 삭제 불가
                            if category.name != "Important" {
                                Button {
                                    categoryIDToDelete = category.id
                                    showActionSheet.toggle()
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .confirmationDialog("Are you sure you want to delete this category?", isPresented: $showActionSheet, titleVisibility: .visible) {
                Button("Yes", role: .destructive) {
                    if let categoryID = categoryIDToDelete {
                        store.send(.deleteCategory(id: categoryID))
                    }
                    categoryIDToDelete = nil
                }
                
                Button("Cancel", role: .cancel) {
                    categoryIDToDelete = nil
                }
            }
            
            VStack(spacing: 15) {
                // Category count Label
                Text(countLabel(for: store.state.categories.count))
                    .font(.system(size: 13))
                    .foregroundStyle(.tint)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // + New Category Button
                Button {
                    showAddView.toggle()
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
        .alert("Error", isPresented: .constant(store.state.hasError), actions: {
            Button("OK") {
                if let error = store.state.error {
                    print(error.errorDescription)
                }
            }
        }, message: {
            Text("Data could not be loaded. Please try again later.")
        })
        .sheet(isPresented: $showAddView, content: {
            NavigationStack {
                AddCategoryView(repository: repository)
            }
        })
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
