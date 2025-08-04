//
//  MainViewModel.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/05.
//

import Foundation

final class MainViewModel: ObservableObject {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    @Published private(set) var state = MainState()
    
    func send(_ intent: MainIntent) {
        switch intent {
        case .loadGroups:
            
        case .deleteGroup(let id):
            
        }
    }
}
