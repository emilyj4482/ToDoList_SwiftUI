//
//  TodoRepository.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/08/29.
//  Refactored by EMILY on 2025/08/05.

import Foundation

final class TodoRepository: ObservableObject {
    @Published private(set) var categories: [Category] = []
}
