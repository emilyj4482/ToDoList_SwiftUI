//
//  RootView.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/05.
//

import SwiftUI

// NavigationStack 책임 분리
struct RootView: View {
    
    let repository: TodoRepository
    
    var body: some View {
        NavigationStack {
            MainView(repository: repository)
        }
    }
}
