//
//  MainView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/13.
//

import SwiftUI

struct MainView: View {
    // 임시 값
    var listCount: Int = 0
    var todoCount: Int = 1
    
    var groups: [Group] = [
        .init(id: 1, name: "Important", tasks: [Task(id: 1, groupId: 1, title: "to stduy iOS", isDone: false, isImportant: true)]),
        .init(id: 2, name: "to study", tasks: [Task(id: 1, groupId: 2, title: "iOS", isDone: false, isImportant: false)]),
    ]
    
    @State private var path: [Group] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                List {
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
                /*NavigationStack {*/
                    VStack {
                        /*
                        Button {
                            print("Back btn tapped")
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 11, height: 19)
                                Text("Lists")
                            }
                        }
                        .frame(maxWidth: .infinity ,alignment: .leading)
                        .padding(.leading, -10)
                        .padding(.top, 6)
                        */
                        Text(group.name)
                            .font(.system(.largeTitle, weight: .black))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Button {
                                print("check btn tapped")
                            } label: {
                                Image(systemName: "circle")
                            }
                            NavigationLink {
                                // TaskDetailView()
                            } label: {
                                Text("to study iOS")
                                    .tint(.black)
                            }
                            Spacer()
                            Button {
                                print("important btn tapped")
                            } label: {
                                Image(systemName: "star")
                                    .tint(.yellow)
                            }
                        }
                        .padding([.top, .bottom], 1)
                        
                        Spacer()
                        
                        Button {
                            print("Add a Task")
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add a Task")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .bottom], 5)
                    }
                    // .navigationBarBackButtonHidden()
                    .padding([.leading, .trailing], 20)
               /* } */
            }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
