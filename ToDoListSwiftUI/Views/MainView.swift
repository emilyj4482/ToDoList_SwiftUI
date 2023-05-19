//
//  MainView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/13.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var taskVM: TaskViewModel = TaskViewModel()
    @State var path: [Group] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                
                List {
                    ForEach(taskVM.groups) { group in
                        NavigationLink(value: group) {
                            HStack {
                                Image(systemName: group.id == 1 ? "star.fill" : "checklist.checked")
                                Text(group.name)
                                Spacer()
                                Text("\(group.tasks.count)")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
                
                Text(
                    taskVM.groups.count < 2 ? "You have \(taskVM.groups.count) custom list." : "You have \(taskVM.groups.count) custom lists."
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
            .navigationDestination(for: Group.self) { group in
                TodoListView(group: group)
            }
        }
        .environmentObject(taskVM)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

