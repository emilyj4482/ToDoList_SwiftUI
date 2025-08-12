//
//  TaskListState.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/06.
//

import Foundation

struct TaskListState {
    var category: Category
    
    var isImportantCategory: Bool {
        category.name == "Important"
    }
    
    var doneTasks: [Task] {
        return category.tasks.filter({ $0.isDone })
    }
    
    var undoneTasks: [Task] {
        return category.tasks.filter({ !$0.isDone })
    }
    
    var taskToRetitle: Task?
    
    var error: DataError?
    
    var hasError: Bool {
        error != nil
    }
    
    mutating func setTask(_ task: Task) {
        self.taskToRetitle = task
    }
}
