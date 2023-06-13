//
//  MainView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/13.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var taskVM: TaskViewModel = TaskViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach($taskVM.groups) { $group in
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
                                // important list는 삭제 불가
                                if group.id != 1 {
                                    Button {
                                        taskVM.deleteGroup(groupId: group.id)
                                        print(taskVM.groups)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
                
                Text(
                    taskVM.groups.count < 3 ? "You have \(taskVM.groups.count - 1) custom list." : "You have \(taskVM.groups.count - 1) custom lists."
                )
                .font(.system(size: 13))
                .foregroundColor(.pink)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)
                .padding(.bottom, 5)
                
                NavigationLink {
                    AddNewListView()
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
            .navigationDestination(for: Group.self, destination: { group in
                TodoListView(selectedGroup: group, selectedGroupIndex: taskVM.groups.firstIndex(where: { $0.id == group.id })!)
            })
        }
        .environmentObject(taskVM)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
