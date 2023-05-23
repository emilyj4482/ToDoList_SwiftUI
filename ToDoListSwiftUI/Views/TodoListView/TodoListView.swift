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
    var groupIndex: Int
    
    /* add New Task Mode : Add a Task 버튼을 눌러 새로운 task를 입력하는 모드 */
    // Add a Task btn tap(addNewTaskMode ON) : 1) Add a Task Button hidden 2) TaskField show 3) Done Button show
    // on Tap Gestrue(addNewTaskMode OFF) : 1) TaskField hidden 2) Add a Task Button show 3) Done Button hidden
    @State var addNewTaskMode: Bool = false
    @FocusState var taskFieldInFocus: Bool
    @State var newTaskTitle: String = ""
    
    // alert 공통 to bind 변수
    @State var showAlert: Bool = false
    
    // List 이름 영역 : tap 시 수정 모드
    @State var updateListNameMode: Bool = false
    @FocusState var listNameInFocus: Bool
    @State var newListName: String = ""
    
    var body: some View {
        
        VStack {
            // List name 영역을 tap 하면 Text view가 Textfield view로 대체된다. (이 때, textfield text는 기존 list name으로 지정한다.)
            if !updateListNameMode {
                Text(group.name)
                    .font(.largeTitle)
                    .bold()
                    .padding([.leading, .trailing], 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        newListName = taskVM.groups[groupIndex].name
                        updateListNameMode = true
                        listNameInFocus = true
                    }
            } else {
                TextField(text: $newListName) {
                    Text(group.name)
                        .foregroundColor(listNameInFocus ? .gray .opacity(0.5) : .black)
                }
                .focused($listNameInFocus)
                .font(.largeTitle)
                .bold()
                .padding([.leading, .trailing], 15)
            }
            
            List {
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
            }
            .listStyle(.plain)
            // 화면을 tap 하면 textfield 영역 숨기고 입력값이 있다면 비운다.
            .onTapGesture {
                updateListNameMode = false
                listNameInFocus = false
                newListName = taskVM.groups[groupIndex].name
                addNewTaskMode = false
                newTaskTitle = ""
            }
            
            // Important list의 경우, star button을 통해서만 task를 추가할 수 있도록 구현 >> Add a Task 기능 비활성화
            if groupIndex != 0 {
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
                    .padding(20)
                } else if updateListNameMode {
                    /* list name 수정 모드 시 Add a Task Button 숨김 */
                }
                else {
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
        // .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if addNewTaskMode {
                        Button {
                            // textfield 입력값이 공백인 경우 입력모드를 종료하지 않고 alert 표시
                            if newTaskTitle.trim().isEmpty {
                                showAlert = true
                            } else {
                                addNewTask()
                            }
                        } label: {
                            Text("Done")
                        }
                        .alert("You must type at least 1 letter.", isPresented: $showAlert) {}
                    } else if updateListNameMode {
                        Button {
                            // textfield 입력값이 공백인 경우 입력모드를 종료하지 않고 alert 표시
                            if newListName.trim().isEmpty {
                                showAlert = true
                            } else {
                                updateListName(newListName)
                            }
                        } label: {
                            Text("Done")
                        }
                        .alert("You must type at least 1 letter.", isPresented: $showAlert) {}
                    }
            }
        }
    }
    
    func addNewTask() {
        addNewTaskMode = false
        // Task 추가
        taskVM.addTask(groupId: group.id, taskVM.createTask(groupId: group.id, newTaskTitle))
        // textfield 비움
        newTaskTitle = ""
    }
    
    func updateListName(_ newListName: String) {
        updateListNameMode = false
        // List 이름 update
        taskVM.updateGroup(groupId: group.id, newListName)
    }
}
