//
//  MainView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/13.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var vm: TodoViewModel
    
    @State private var showAddView: Bool = false
    
    /* group delete */
    // swipe action으로 delete button tap 시 확인하는 action sheet 호출
    @State private var showActionSheet: Bool = false
    // 잘못된 group 삭제 방지를 위해 실제 삭제 될 group을 담기 위한 빈 값
    @State private var itemToDelete: Group? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(vm.groups) { group in
                        NavigationLink(value: group) {
                            HStack {
                                Image(systemName: group.id == 1 ? "star.fill" : "checklist.checked")
                                Text(group.name)
                                Spacer()
                            
                                Text("\(group.tasks.count)")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                              
                            }
                            .padding([.top, .bottom], 5)
                            .swipeActions(allowsFullSwipe: false) {
                                // important list는 삭제 불가, 삭제 여부를 확인하는 action sheet 호출
                                if group.id != 1 {
                                    Button {
                                        itemToDelete = group
                                        showActionSheet = true
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }
                .confirmationDialog("Are you sure deleting the list?", isPresented: $showActionSheet, titleVisibility: .visible) {
                    Button("Delete", role: .destructive) {
                        if let item = itemToDelete {
                            // 삭제 대상 group이 important task를 포함하고 있을 때, group에 속했던 important task들이 Important group에서도 삭제되어야 한다.
                            if item.tasks.contains(where: { $0.isImportant }) {
                                vm.groups[0].tasks.removeAll(where: { $0.groupId == item.id && $0.isImportant })
                            }
                            vm.deleteGroup(item)
                        }
                        itemToDelete = nil
                    }
                    
                    Button("Cancel", role: .cancel) {}
                }
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
                
                Text(
                    vm.groups.count < 3 ? "You have \(vm.groups.count - 1) custom list." : "You have \(vm.groups.count - 1) custom lists."
                )
                .font(.system(size: 13))
                .foregroundColor(.pink)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)
                .padding(.bottom, 5)
                
                Button {
                    showAddView.toggle()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("New List")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)
                    .padding(.bottom, 5)
                }
            }
            .navigationTitle("ToDoList")
            .sheet(isPresented: $showAddView) {
                NavigationStack {
                    AddNewListView()
                }
            }
            .navigationDestination(for: Group.self, destination: { group in
                TodoListView(group: group)
            })
        }
        .onAppear {
            // disk에 저장돼있는 data 불러오기
            vm.retrieveGroups()
        }
    }
}
