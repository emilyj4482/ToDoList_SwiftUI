//
//  TodoListView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/16.
//

import SwiftUI

struct TodoListView: View {

    var group: Group
    
    var body: some View {
        VStack {
            ForEach(group.tasks) { task in
                TaskHStack(task: task)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Add a Task")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
            .padding(.bottom, 5)
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.large)
        .padding([.leading, .trailing], 15)
    }
}

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

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        let group: Group = Group(id: 2, name: "to study", tasks: [
            Task(id: 1, groupId: 2, title: "iOS", isDone: true, isImportant: false),
            Task(id: 2, groupId: 2, title: "Swift", isDone: false, isImportant: true),
            Task(id: 3, groupId: 2, title: "UIKit", isDone: false, isImportant: false),
            Task(id: 4, groupId: 2, title: "SwiftUI", isDone: false, isImportant: false)
        ])
        NavigationView {
            TodoListView(group: group)
        }
    }
}
