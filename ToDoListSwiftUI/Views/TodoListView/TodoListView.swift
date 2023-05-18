//
//  TodoListView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/16.
//

import SwiftUI

struct TodoListView: View {

    var group: Group
    
    @State var newTaskTitle: String = ""
    @State var taskFieldHidden: Bool = true
    @FocusState var taskFieldInFocus: Bool
    
    var body: some View {
        VStack {
            ForEach(group.tasks) { task in
                TaskHStack(task: task)
            }
            
            Spacer()
            
            taskFieldHidden ? nil :
            TaskField(newTaskTitle: $newTaskTitle)
            
            taskFieldHidden ?
            AddTaskButton(taskFieldHidden: $taskFieldHidden)
            : nil
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.large)
        .padding([.leading, .trailing], 15)
    }
}

struct AddTaskButton: View {
    
    @Binding var taskFieldHidden: Bool
    @FocusState var taskFieldInFocus: Bool
    
    var body: some View {
        Button {
            taskFieldHidden.toggle()
            taskFieldInFocus = true
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
}

struct TaskField: View {
    
    @Binding var newTaskTitle: String
    @FocusState var taskFieldInFocus: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "circle")
                .foregroundColor(.red)
            TextField("Add a Task", text: $newTaskTitle)
                .focused($taskFieldInFocus)
            Spacer()
            Image(systemName: "star")
                .foregroundColor(.yellow)
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
