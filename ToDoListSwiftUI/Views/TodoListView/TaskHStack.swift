//
//  TaskHStack.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/19.
//

import SwiftUI

struct TaskHStack: View {
    
    var task: Task
    @State var isDone: Bool = false
    
    var body: some View {
        HStack {
            Button {
                isDone.toggle()
            } label: {
                Image(systemName: isDone ? "checkmark.circle" : "circle")
                    .tint(isDone ? .green : .red)
                // Image(systemName: task.isDone ? "checkmark.circle" : "circle")
                    // .tint(task.isDone ? .green : .red)
            }
            
            Text(task.title)
            
            Spacer()
            
            Button {

            } label: {
                Image(systemName: task.isImportant ? "star.fill": "star")
                    .tint(.yellow)
            }
        }
        .padding([.top, .bottom], 10)
    }
}
