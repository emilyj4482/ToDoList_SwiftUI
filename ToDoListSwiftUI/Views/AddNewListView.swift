//
//  AddNewListView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/10.
//

import SwiftUI

struct AddNewListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var taskVM: TaskViewModel
    
    @State var listName: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            TextField("Untitled List", text: $listName)
                .font(.system(.largeTitle, weight: .bold))
                .padding(.leading, 20)
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    taskVM.addGroup(taskVM.createGroup(getListName(listName)))
                    showAlert = true
                    dismiss()
                } label: {
                    Text("Done")
                }
                .alert("A new list has been added successfully.", isPresented: $showAlert) {}
            }
        }
    }
    
    // textfield 입력값 공백 시 "Untitled list" 부여
    func getListName(_ listName: String) -> String {
        if listName.trim().isEmpty {
            return "Untitled list"
        }
        return listName.trim()
    }
}

struct AddNewListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddNewListView()
        }
    }
}
