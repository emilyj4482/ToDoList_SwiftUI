//
//  TaskEditIntent.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/06.
//

import Foundation

enum TaskEditIntent {
    case createTask(categoryID: UUID, input: String)
    case retitleTask(taskID: UUID, input: String)
}
