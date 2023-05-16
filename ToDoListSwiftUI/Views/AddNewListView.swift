//
//  AddNewListView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/10.
//

import SwiftUI

struct AddNewListView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var listName: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    print("Cencel btn tapped")
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                Spacer()
                NavigationLink("Done") {
                    // 임시 값
                    let group = Group(id: 32, name: listName, tasks: [Task(id: 1, groupId: 1, title: "to stduy iOS", isDone: false, isImportant: true)])
                    TodoListView(group: group)
                }
            }
            .padding(20)
            TextField("Untitled List", text: $listName)
                .font(.system(.largeTitle, weight: .black))
                .padding(.leading, 20)
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

struct AddNewListView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewListView()
    }
}
