//
//  TaskEditView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/09/05.
//

import SwiftUI

struct TaskEditView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: TodoViewModel
    
    // task가 속한 groupId를 전달 받을 변수
    var groupId: Int = 0
    
    // create mode인지 edit mode인지 구분
    var isCreating: Bool = true
    
    @FocusState var focused: Bool
    @State var taskTitle: String = ""
    @Binding var taskToEdit: Task?
        
    var body: some View {
        HStack {
            Image(systemName: "circle")
                .foregroundColor(.red)
            TextField("Enter a task.", text: $taskTitle)
                .focused($focused)
                .onSubmit {
                    dismiss()
                }
            Spacer()
            Button {
                if isCreating {
                    vm.addTask(groupId: groupId, vm.createTask(groupId: groupId, taskTitle))
                } else {
                    guard var task = taskToEdit else { return }
                    task.title = taskTitle
                    vm.updateTaskComplete(task)
                }
                dismiss()
            } label: {
                Text("Done")
            }
        }
        .padding(20)
        .frame(height: 50)
        .onAppear {
            focused = true
            if !isCreating {
                guard let task = taskToEdit else { return }
                taskTitle = task.title
            }
        }
    }
}
