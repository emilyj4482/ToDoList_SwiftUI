//
//  TaskHStack.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/19.
//

import SwiftUI

struct TaskHStack: View {
    
    @EnvironmentObject var taskVM: TaskViewModel
    @State var task: Task
    
    var body: some View {
        HStack {
            Button {
                task.isDone.toggle()
                taskVM.updateTaskComplete(task)
                print(taskVM.groups)
            } label: {
                Image(systemName: task.isDone ? "checkmark.circle" : "circle")
                    .tint(task.isDone ? .green : .red)
            }
            
            Text(task.title)
            
            Spacer()
            
            Button {
                task.isImportant.toggle()
                taskVM.updateImportant(task)
                print(taskVM.groups)
            } label: {
                Image(systemName: task.isImportant ? "star.fill": "star")
                    .tint(.yellow)
            }
        }
        .padding([.top, .bottom], 10)
    }
}
