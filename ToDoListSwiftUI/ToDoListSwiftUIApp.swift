//
//  ToDoListSwiftUIApp.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/01.
//

import SwiftUI

@main
struct ToDoListSwiftUIApp: App {
    
    @StateObject var vm = TodoViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .tint(.pink)
                .environmentObject(vm)
        }
    }
}
