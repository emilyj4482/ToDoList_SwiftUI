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
    
    @State private var showRenameAlert: Bool = false
    @State private var textFieldInput: String = ""
    
    @State private var showEditView: Bool = false
    
    var body: some View {
        VStack {
            // Tasks List
            List {
                ForEach(store.state.category.tasks) { task in
                    HStack {
                        Button {
                            store.send(.toggleTaskDone(task: task))
                        } label: {
                            TaskDoneToggleImage(isDone: task.isDone)
                        }

                        Text(task.title)
                        
                        Spacer()
                        
                        Button {
                            store.send(.toggleTaskImportant(task: task))
                        } label: {
                            TaskImportantToggleImage(isImportant: task.isImportant)
                        }

                    }
                    .padding(.vertical, 5)
                }
            }
            .listStyle(.plain)
            
            // Add a Task Button
            if !store.state.isImportantCategory {
                Button {
                    showEditView.toggle()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add a Task")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !store.state.isImportantCategory {
                    Button {
                        showRenameAlert.toggle()
                    } label: {
                        Text("Rename")
                    }
                    .alert("Enter a new name for the category", isPresented: $showRenameAlert) {
                        TextField(store.state.category.name, text: $textFieldInput)
                        Button("Confirm") {
                            if !textFieldInput.trim.isEmpty {
                                store.send(.renameCategory(input: textFieldInput))
                            }
                        }
                        Button("Cancel", role: .cancel, action: {})
                    }
                }
            }
        }
        .sheet(isPresented: $showEditView, content: {
            NavigationStack {
                TaskEditView(repository: repository, mode: .create(categoryID: store.state.category.id))
            }
            .presentationDetents([.height(50)])
        })
        .navigationTitle(store.state.category.name)
    }
}

fileprivate struct TaskDoneToggleImage: View {
    let isDone: Bool
    
    var body: some View {
        Image(systemName: isDone ? "checkmark.circle" : "circle")
            .foregroundStyle(isDone ? .green : .red)
    }
}

fileprivate struct TaskImportantToggleImage: View {
    let isImportant: Bool
    
    var body: some View {
        Image(systemName: isImportant ? "star.fill" : "star")
            .foregroundStyle(.yellow)
    }
}
