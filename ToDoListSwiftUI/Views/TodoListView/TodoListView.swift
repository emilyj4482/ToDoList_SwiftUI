//
//  TodoListView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/16.
//

import SwiftUI

struct TodoListView: View {

    @EnvironmentObject var taskVM: TaskViewModel
    var group: Group
    
    @State var newTaskTitle: String = ""
    // add New Task Mode : Add a Task 버튼을 눌러 새로운 task를 입력하는 모드 (Add a Task 버튼은 숨김, textfield 및 Done 버튼은 노출한다. false 시 반대)
    @State var addNewTaskMode: Bool = false
    @FocusState var taskFieldInFocus: Bool
    
    var body: some View {
        VStack {
            VStack {
                ForEach(group.tasks) { task in
                    TaskHStack(task: task)
                }
                Spacer()
                Text("End")
            }
            .background(.gray)
            // 화면을 tap 하면 textfield 영역 숨기고 입력값이 있다면 비운다.
            .onTapGesture {
                addNewTaskMode = false
                newTaskTitle = ""
            }
            
            // Add a Task btn tap : 1) Add a Task Button hidden 2) TaskField show 3) Done Button show
            // on Tap Gestrue : 1) TaskField hidden 2) Add a Task Button show 3) Done Button hidden
            if addNewTaskMode {
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
            } else {
                Button {
                    addNewTaskMode = true
                    self.taskFieldInFocus = true
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
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.large)
        .padding([.leading, .trailing], 15)
        .toolbar {
            //
            addNewTaskMode ?
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // textfield 입력값이 공백인 경우 입력모드를 종료하지 않고 alert 표시
                    if newTaskTitle.trim().isEmpty {
                    } else {
                        addNewTaskMode = false
                        // Task 추가
                        taskVM.addTask(groupId: group.id, taskVM.createTask(groupId: group.id, newTaskTitle))
                        print(taskVM.groups)
                        // textfield 비움
                        newTaskTitle = ""
                    }
                } label: {
                    Text("Done")
                }
            }
            : nil
        }
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
