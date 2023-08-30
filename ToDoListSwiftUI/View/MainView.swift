//
//  MainView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/13.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var groupVM: GroupViewModel = GroupViewModel()
    
    @State private var showAddView: Bool = false
    
    /* group delete */
    // swipe action으로 delete button tap 시 확인하는 action sheet 호출
    @State private var showActionSheet: Bool = false
    // 잘못된 group 삭제 방지를 위해 실제 삭제 될 group을 담기 위한 빈 값
    @State private var itemToDelete: Group? = nil
    
    var body: some View {
        
        @State var groups: [Group] = groupVM.todoDic.keys.sorted(by: { $0.id < $1.id })
        
        NavigationStack {
            VStack {
                List {
                    ForEach(groups) { group in
                        NavigationLink(value: group) {
                            HStack {
                                Image(systemName: group.id == 1 ? "star.fill" : "checklist.checked")
                                Text(group.name)
                                Spacer()
                            
                                Text("\(groupVM.todoDic[group]?.count ?? 0)")
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
                            groupVM.deleteGroup(item)
                        }
                        itemToDelete = nil
                    }
                    
                    Button("Cancel", role: .cancel) {}
                }
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
                
                Text(
                    groupVM.groups.count < 3 ? "You have \(groupVM.groups.count - 1) custom list." : "You have \(groupVM.groups.count - 1) custom lists."
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
                TodoListView(taskVM: TaskViewModel(group: group, tasks: groupVM.todoDic[group] ?? [], todoDic: $groupVM.todoDic))
            })
            
        }
        .environmentObject(groupVM)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(groupVM: GroupViewModel())
    }
}
