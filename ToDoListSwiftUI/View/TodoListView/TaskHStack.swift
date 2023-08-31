//
//  TaskHStack.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/19.
//

import SwiftUI

struct TaskHStack: View {
    
    @EnvironmentObject var vm: TodoViewModel
    @State var task: Task
    
    var body: some View {
        HStack {
            Image(systemName: task.isDone ? "checkmark.circle" : "circle")
                .foregroundColor(task.isDone ? .green : .red)
                .onTapGesture {
                    task.isDone.toggle()
                    vm.updateTaskComplete(task)
                }
            Text(task.title)
            Spacer()
            Image(systemName: task.isImportant ? "star.fill": "star")
                .foregroundColor(.yellow)
                .onTapGesture {
                    task.isImportant.toggle()
                    vm.updateImportant(task)
                }
        }
        .padding([.top, .bottom], 5)
    }
}
