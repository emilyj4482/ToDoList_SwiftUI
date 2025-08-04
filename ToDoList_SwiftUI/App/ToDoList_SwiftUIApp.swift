//
//  ToDoList_SwiftUIApp.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/05/01.
//

import SwiftUI

@main
struct ToDoList_SwiftUIApp: App {
    
    @StateObject private var repository = TodoRepository()
    
    var body: some Scene {
        WindowGroup {
            RootView(repository: repository)
        }
    }
}
