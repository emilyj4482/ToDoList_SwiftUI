//
//  TaskHStack.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/19.
//

import SwiftUI

struct TaskHStack: View {
    
    @State var task: Task
    
    var body: some View {
        HStack {
            Button {
                task.isDone.toggle()
                print(task)
            } label: {
                Image(systemName: task.isDone ? "checkmark.circle" : "circle")
                    .tint(task.isDone ? .green : .red)
            }
            
            Text(task.title)
            
            Spacer()
            
            Button {
                task.isImportant.toggle()
                print(task)
            } label: {
                Image(systemName: task.isImportant ? "star.fill": "star")
                    .tint(.yellow)
            }
        }
        .padding([.top, .bottom], 10)
    }
}
