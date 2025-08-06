//
//  TaskListState.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/06.
//

import Foundation

struct TaskListState {
    var category: Category
    var error: DataError?
    
    var hasError: Bool {
        error != nil
    }
}
