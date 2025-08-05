//
//  AddCategoryView.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/05/10.
//  Refactored by EMILY on 2025/08/05.

import SwiftUI

struct AddCategoryView: View {
    
    @StateObject var store: AddCategoryStore
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
        _store = StateObject(wrappedValue: AddCategoryStore(repository: repository))
    }
    
    @Environment(\.dismiss) private var dismiss
    @State private var input: String = ""
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack {
            TextField("Untitled Category", text: $input)
                .focused($focused)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading, 20)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(.addCategory(input: input))
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
        .onAppear {
            focused = true
        }
    }
}
