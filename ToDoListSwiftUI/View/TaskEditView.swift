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
    
    // textfield 입력값 없을 때 alert 호출
    @State var showAlert: Bool = false
        
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
                if taskTitle.trim().isEmpty {
                    showAlert = true
                } else if isCreating && !taskTitle.trim().isEmpty {
                    vm.addTask(groupId: groupId, vm.createTask(groupId: groupId, taskTitle))
                    dismiss()
                } else {
                    guard var task = taskToEdit else { return }
                    task.title = taskTitle
                    vm.updateTaskComplete(task)
                    NotificationCenter.default.post(name: .taskEdited, object: task)
                    dismiss()
                }
            } label: {
                Text("Done")
            }
            .alert("There must be at least 1 letter typed.", isPresented: $showAlert) {}
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

extension Notification.Name {
    static let taskEdited = Notification.Name("taskEdited")
}
