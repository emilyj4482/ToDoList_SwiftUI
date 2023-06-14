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
    
    @Binding var groupIndex: Int
    
    var body: some View {
        HStack {
            Image(systemName: task.isDone ? "checkmark.circle" : "circle")
                .foregroundColor(task.isDone ? .green : .red)
                .onTapGesture {
                    task.isDone.toggle()
                    taskVM.updateTaskComplete(task)
                    taskVM.reloadTasks(groupIndex)
                    print(taskVM.groups)
                }
            Text(task.title)
            Spacer()
            Image(systemName: task.isImportant ? "star.fill": "star")
                .foregroundColor(.yellow)
                .onTapGesture {
                    task.isImportant.toggle()
                    taskVM.updateImportant(task)
                    taskVM.reloadTasks(groupIndex)
                    print(taskVM.groups)
                }
        }
        .padding([.top, .bottom], 5)
    }
}
