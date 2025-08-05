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
    
    var body: some View {
        VStack {
            
        }
    }
}
