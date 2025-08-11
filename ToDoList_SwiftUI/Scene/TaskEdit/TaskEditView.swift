//
//  TaskEditView.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/09/05.
//  Refactored by EMILY on 2025/08/06.

import SwiftUI

struct TaskEditView: View {
    
    @StateObject var store: TaskEditStore
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
        _store = StateObject(wrappedValue: TaskEditStore(repository: repository))
    }
    
    var body: some View {
        VStack {
            
        }
    }
}
