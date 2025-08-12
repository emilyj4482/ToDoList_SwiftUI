//
//  TaskEditView.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/09/05.
//  Refactored by EMILY on 2025/08/06.

import SwiftUI

struct TaskEditView: View {
    
    @StateObject var store: TaskEditStore
    private let repository: TodoRepository
    
    init(repository: TodoRepository, mode: TaskEditMode) {
        self.repository = repository
        _store = StateObject(wrappedValue: TaskEditStore(repository: repository, mode: mode))
    }
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focused: Bool
    @State private var textFieldInput: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: iconName(for: store.state.mode))
                .foregroundStyle(iconColor(for: store.state.mode))
            
            TextField("", text: $textFieldInput)
                .focused($focused)
                .onSubmit {
                    dismiss()
                }
            
            Spacer()
            
            Button {
                if !textFieldInput.trim.isEmpty {
                    switch store.state.mode {
                    case .create(let categoryID):
                        store.send(.createTask(categoryID: categoryID, input: textFieldInput))
                    case .retitle(let task):
                        store.send(.retitleTask(task: task, input: textFieldInput))
                    }
                    dismiss()
                }
            } label: {
                Text("Done")
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 50)
        .onAppear {
            textFieldInput = store.state.taskToEdit?.title ?? ""
            focused = true
        }
    }
}

extension TaskEditView {
    private func iconName(for mode: TaskEditMode) -> String {
        switch mode {
        case .create:
            return "circle"
        case .retitle(let task):
            return task.isDone ? "checkmark.circle" : "circle"
        }
    }
    
    private func iconColor(for mode: TaskEditMode) -> Color {
        switch mode {
        case .create:
            return .red
        case .retitle(let task):
            return task.isDone ? .green : .red
        }
    }
}
