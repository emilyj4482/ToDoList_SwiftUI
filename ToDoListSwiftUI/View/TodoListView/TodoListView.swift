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
    
    @State var showCreate: Bool = false
    @State var showEdit: Bool = false
    @State var taskToEdit: Task?
    
    var body: some View {
        VStack {
            List {
                ForEach(vm.groups.first(where: { $0.id == group.id })?.tasks ?? []) { task in
                    TaskHStack(task: task)
                        .swipeActions(allowsFullSwipe: false) {
                            Button {
                                vm.deleteTaskComplete(task)
                            } label: {
                                Image(systemName: "trash")
                            }
                            
                            Button {
                                taskToEdit = task
                                showEdit.toggle()
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .tint(.cyan)
                        }
                }
            }
            .listStyle(.plain)
            
            // Important list에서는 task 추가 불가
            if group.id != 1 {
                Button {
                    showCreate.toggle()
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
        .toolbar {
            
        }
        .sheet(isPresented: $showCreate) {
            NavigationStack {
                TaskEditView(groupId: group.id, isCreating: true, taskToEdit: $taskToEdit)
            }
            .presentationDetents([.height(50)])
        }
        .sheet(isPresented: $showEdit) {
            NavigationStack {
                TaskEditView(groupId: group.id, isCreating: false, taskToEdit: $taskToEdit)
            }
            .presentationDetents([.height(50)])
        }
    }
}
