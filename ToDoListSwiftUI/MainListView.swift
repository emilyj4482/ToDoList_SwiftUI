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
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
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
        }
    }
}

struct MainListView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
