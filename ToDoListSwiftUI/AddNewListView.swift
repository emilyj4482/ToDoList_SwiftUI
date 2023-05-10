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
                    TodoListView()
                }
            }
            .padding(20)
            TextField("Untitled List", text: $listName)
                .font(.system(.largeTitle, weight: .black))
                .padding(.leading, 20)
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
            print("onDisappear")
        }
    }
}

struct AddNewListView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewListView()
    }
}
