//
//  TodoListView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/16.
//

import SwiftUI

struct TodoListView: View {

    var group: Group
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    print("check btn tapped")
                } label: {
                    Image(systemName: "circle")
                }
                NavigationLink {
                    TaskDetailView()
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
            .padding([.top, .leading, .bottom], 5)
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.large)
        .padding([.leading, .trailing], 20)
    }
}