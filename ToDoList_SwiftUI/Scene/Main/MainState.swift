//
//  MainState.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/05.
//

import Foundation

struct MainState {
    var categories: [Category] = []
    var error: DataError?
    
    var hasError: Bool {
        error != nil
    }
}
