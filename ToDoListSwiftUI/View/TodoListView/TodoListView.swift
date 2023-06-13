//
//  TodoListView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/16.
//

import SwiftUI

struct TodoListView: View {
    
    @EnvironmentObject var taskVM: TaskViewModel
    
    /* add New Task Mode : Add a Task 버튼을 눌러 새로운 task를 입력하는 모드 */
    // Add a Task btn tap(addNewTaskMode ON) : 1) Add a Task Button hidden 2) TaskField show 3) Done Button show
    // on Tap Gestrue(addNewTaskMode OFF) : 1) TaskField hidden 2) Add a Task Button show 3) Done Button hidden
    @State var addNewTaskMode: Bool = false
    @FocusState var taskFieldInFocus: Bool
    @State var newTaskTitle: String = ""
    
    // task 추가 시 입력값 없을 때 alert 변수
    @State var showAlert: Bool = false
    
    // task 수정 textfield alert 변수
    @State var showFieldAlert: Bool = false
    @State var newListName: String = ""
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(taskVM.unDoneTasks(groupIndex: taskVM.selectedGroupIndex!)) { task in
                        TaskHStack(task: task)
                    }
                }
                // done task가 하나라도 있어야 Done header 노출
                Section(taskVM.isDoneTasks(groupIndex: taskVM.selectedGroupIndex!).count != 0 ? "Done" : "") {
                        ForEach(taskVM.isDoneTasks(groupIndex: taskVM.selectedGroupIndex!)) { task in
                            TaskHStack(task: task)
                        }
                    }
                /*
                ForEach(taskVM.groups[groupIndex].tasks) { task in
                    TaskHStack(task: task)
                        .swipeActions(allowsFullSwipe: false) {
                            Button {
                                //taskVM.deleteTaskComplete(task)
                                print("swiped")
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                }
                */
            }
            .listStyle(.plain)
            // 화면을 tap 하면 textfield 영역 숨김
            .onTapGesture {
                hideTextfield()
            }
            
            // Important list의 경우, star button을 통해서만 task를 추가할 수 있도록 구현 >> Add a Task 기능 비활성화
            if taskVM.selectedGroupIndex != 0 {
                if addNewTaskMode {
                    HStack {
                        Image(systemName: "circle")
                            .foregroundColor(.red)
                        TextField("Add a Task", text: $newTaskTitle)
                            .focused($taskFieldInFocus)
                            .onSubmit {
                                hideTextfield()
                            }
                        Spacer()
                        Image(systemName: "star")
                            .foregroundColor(.yellow)
                    }
                    .padding(20)
                } else if showFieldAlert {
                    // list name upate mode 시 모든 view 숨김
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
        }
        .navigationTitle(taskVM.selectedGroup!.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if addNewTaskMode {
                        Button {
                            // textfield 입력값이 공백인 경우 입력모드를 종료하지 않고 alert 표시
                            if newTaskTitle.trim().isEmpty {
                                showAlert = true
                            } else {
                                // Task 추가
                                taskVM.addTask(groupId: taskVM.selectedGroup!.id, taskVM.createTask(groupId: taskVM.selectedGroup!.id, newTaskTitle))
                                hideTextfield()
                            }
                        } label: {
                            Text("Done")
                        }
                        .alert("You must type at least 1 letter.", isPresented: $showAlert) {}
                    } else {
                        // Important list의 경우, rename 불가
                        if taskVM.selectedGroupIndex != 0 {
                            Button {
                                showFieldAlert = true
                            } label: {
                                Text("Rename")
                            }
                            .alert("Enter a new name for the list.", isPresented: $showFieldAlert) {
                                TextField(taskVM.groups[taskVM.selectedGroupIndex!].name, text: $newListName)
                                Button("Confirm") {
                                    // 입력값이 아예 없거나 공백만 입력했을 경우 완료되지 않도록 처리
                                    if !newListName.trim().isEmpty {
                                        taskVM.updateGroup(groupId: taskVM.selectedGroup!.id, newListName)
                                    }
                                }
                                Button("Cancel", role: .cancel, action: {})
                            }
                        }
                    }
            }
        }
    }
    
    // keyboard가 사라질 때 textfield 영역도 숨김 되고, textfield 입력값이 초기화된다.
    func hideTextfield() {
        addNewTaskMode = false
        newTaskTitle = ""
    }
}
