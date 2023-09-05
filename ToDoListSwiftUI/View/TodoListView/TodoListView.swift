//
//  TodoListView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/16.
//

import SwiftUI

struct TodoListView: View {
    
    @EnvironmentObject var vm: TodoViewModel
    
    // main view에서 선택되어 넘어 온 group
    @State var group: Group
    
    // group name 수정 textfield alert 변수
    @State var showFieldAlert: Bool = false
    @State var newGroupName: String = ""
    
    /* add New Task Mode : Add a Task 버튼을 눌러 새로운 task를 입력하는 모드 */
    // Add a Task btn tap(addNewTaskMode ON) : 1) Add a Task Button hidden 2) TaskField show 3) Done Button show
    // Cancel btn tap(addNewTaskMode OFF) : 1) TaskField hidden 2) Add a Task Button show 3) Done Button hidden
    @State var addNewTaskMode: Bool = false
    @FocusState var taskFieldInFocus: Bool
    @State var newTaskTitle: String = ""
    
    // task 추가 시 입력값 없을 때 alert 변수
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            List {
                /* task.isDone 여부에 따른 section 분리 작업 보류
                Section {
                    ForEach(taskVM.undoneTasks) { task in
                        TaskHStack(task: task, groupIndex: $selectedGroupIndex)
                    }
                }
                // done task가 하나라도 있어야 Done header 노출
                Section((taskVM.doneTasks).count != 0 ? "Tasks done!" : "") {
                    ForEach(taskVM.doneTasks) { task in
                        TaskHStack(task: task, groupIndex: $selectedGroupIndex)
                    }
                }
                */
                
                ForEach(vm.groups.first(where: { $0.id == group.id })?.tasks ?? []) { task in
                    TaskHStack(task: task)
                        .swipeActions(allowsFullSwipe: false) {
                            Button {
                                vm.deleteTaskComplete(task)
                            } label: {
                                Image(systemName: "trash")
                            }
                            
                            Button {
                                print("swiped")
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .tint(.cyan)
                        }
                }
            }
            .listStyle(.plain)
            
            // Important list의 경우, star button을 통해서만 task를 추가할 수 있도록 구현 >> Add a Task 기능 비활성화
            if group.id != 1 {
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

                        Button {
                            // textfield 입력값이 공백인 경우 입력모드를 종료하지 않고 alert 표시
                            if newTaskTitle.trim().isEmpty {
                                showAlert = true
                            } else {
                                // Task 추가
                                vm.addTask(groupId: group.id, vm.createTask(groupId: group.id, newTaskTitle))
                                // done section view 적용
                                // taskVM.reloadTasks(selectedGroupIndex)
                                hideTextfield()
                            }
                        } label: {
                            Text("Done")
                        }
                        .alert("You must type at least 1 letter.", isPresented: $showAlert) {}
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
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if addNewTaskMode {
                        Button {
                            hideTextfield()
                        } label: {
                            Text("Cancel")
                        }
                    } else {
                        // Important list의 경우, rename 불가
                        if group.id != 1 {
                            Button {
                                showFieldAlert = true
                            } label: {
                                Text("Rename")
                            }
                            .alert("Enter a new name for the list.", isPresented: $showFieldAlert) {
                                TextField(group.name, text: $newGroupName)
                                Button("Confirm") {
                                    // 입력값이 아예 없거나 공백만 입력했을 경우 완료되지 않도록 처리
                                    if !newGroupName.trim().isEmpty {
                                        vm.updateGroup(group: group, newGroupName)
                                        // 현재 화면에도 적용
                                        group.name = newGroupName
                                    }
                                }
                                Button("Cancel", role: .cancel, action: {})
                            }
                        }
                    }
            }
        }
        .onAppear {
            // taskVM.reloadTasks(selectedGroupIndex)
        }
    }
    
    // keyboard가 사라질 때 textfield 영역도 숨김 되고, textfield 입력값이 초기화된다.
    func hideTextfield() {
        addNewTaskMode = false
        newTaskTitle = ""
    }
}
