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
                Text("to study iOS")
                    .tint(.black)
                Spacer()
                Button {
                    print("important btn tapped")
                } label: {
                    Image(systemName: "star")
                        .tint(.yellow)
                }
            }
            .padding([.top, .bottom], 10)
            
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
            .padding(.leading, 15)
            .padding(.bottom, 5)
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.large)
        .padding([.leading, .trailing], 15)
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        let group: Group = Group(id: 2, name: "to study", tasks: [Task(id: 1, groupId: 2, title: "iOS", isDone: false, isImportant: false)])
        NavigationView {
            TodoListView(group: group)
        }
    }
}
