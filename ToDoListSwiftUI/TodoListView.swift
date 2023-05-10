//
//  TodoListView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/10.
//

import SwiftUI

struct TodoListView: View {
    var body: some View {
        NavigationStack {
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
                .padding(15)
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
                .padding(.leading, 30)
                .padding(.bottom, 5)

            }
            .navigationTitle(Text("Important"))
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
