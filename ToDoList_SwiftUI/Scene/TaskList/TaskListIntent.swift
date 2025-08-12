//
//  TaskListIntent.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/06.
//

import Foundation

enum TaskListIntent {
    case renameCategory(input: String)
    case toggleTaskDone(task: Task)
    case toggleTaskImportant(task: Task)
    case deleteTask(task: Task)
    case sendTaskInfo(task: Task)
}
