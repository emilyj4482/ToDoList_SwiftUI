//
//  ToDoList_SwiftUIApp.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/05/01.
//

import SwiftUI

@main
struct ToDoList_SwiftUIApp: App {
    
    private let repository = TodoRepository()
    
    var body: some Scene {
        WindowGroup {
            RootView(repository: repository)
                .tint(.pink)
        }
    }
}
