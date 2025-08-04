//
//  AddCategoryView.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/05/10.
//  Refactored by EMILY on 2025/08/05.

import SwiftUI

struct AddCategoryView: View {
    
    @StateObject var viewModel: AddCategoryViewModel
    
    init(repository: TodoRepository) {
        _viewModel = StateObject(wrappedValue: AddCategoryViewModel(repository: repository))
    }
    
    var body: some View {
        VStack {
            
        }
    }
}
