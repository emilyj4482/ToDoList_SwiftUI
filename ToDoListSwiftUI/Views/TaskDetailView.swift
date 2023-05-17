//
//  TaskDetailView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/10.
//

import SwiftUI

struct TaskDetailView: View {
    var body: some View {
        VStack {
            HStack {
                Button {
                    print("check btn tapped")
                } label: {
                    Image(systemName: "circle")
                }
                Text("to study iOS")
                Spacer()
                Button {
                    print("important btn tapped")
                } label: {
                    Image(systemName: "star")
                        .tint(.yellow)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 15)
            HStack {
                Image(systemName: "star.fill")
                Text("Important")
                Spacer()
            }
            .padding(.leading, 30)
            Spacer()
            Button {
                print("Delete btn tapped")
            } label: {
                Image(systemName: "trash")
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 30)
            .padding(.bottom, 5)

        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top, 20)
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskDetailView()
        }
    }
}
