//
//  MainListView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/01.
//

import SwiftUI

struct MainListView: View {

    // 임시 값
    var listCount: Int = 0
    var todoCount: Int = 1
    
    var groups: [Group] = [
        Group(id: 1, name: "Important", tasks: [Task(id: 1, groupId: 1, title: "to stduy iOS", isDone: false, isImportant: true)]),
        Group(id: 2, name: "to study", tasks: [Task(id: 1, groupId: 2, title: "iOS", isDone: false, isImportant: false)]),
    ]
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                List {
                    /*
                    NavigationLink {
                        TodoListView()
                    } label: {
                        HStack {
                            Image(systemName: "star.fill")
                            Text("Important")
                            Spacer()
                            Text("\(todoCount)")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                    }
                     */
                    ForEach(groups, id: \.self) { group in
                        NavigationLink(value: group) {
                            HStack {
                                Image(systemName: "star.fill")
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
                Text("You have \(listCount) custom list.")
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
                // TodoListView()
                Text(group.name)
            }
        }
    }
}

struct MainListView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
