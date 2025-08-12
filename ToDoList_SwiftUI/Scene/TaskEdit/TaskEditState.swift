//
//  TaskEditState.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/06.
//

import Foundation

struct TaskEditState {
    var mode: TaskEditMode
    
    var taskToEdit: Task? {
        switch mode {
        case .create:
            return nil
        case .retitle(let task):
            return task
        }
    }
}

enum TaskEditMode {
    case create(categoryID: UUID)
    case retitle(task: Task)
}
