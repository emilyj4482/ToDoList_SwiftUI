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
                
                Text("Important")
                    .font(.system(.largeTitle, weight: .black))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
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
                .padding([.leading, .bottom], 5)
            }
            .navigationBarBackButtonHidden()
            .padding([.leading, .trailing], 20)
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
