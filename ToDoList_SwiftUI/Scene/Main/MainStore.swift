//
//  MainViewModel.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2025/08/05.
//

import Foundation
import Combine

final class MainStore: ObservableObject {
    private let repository: TodoRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: TodoRepository) {
        self.repository = repository
        bind()
    }
    
    @Published private(set) var state = MainState()
    
    private func bind() {
        repository.$categories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                self?.state.categories = categories
            }
            .store(in: &cancellables)
        
        repository.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.state.error = error
            }
            .store(in: &cancellables)
    }
    
    func send(_ intent: MainIntent) {
        reduce(intent)
    }
    
    private func reduce(_ intent: MainIntent) {
        switch intent {
        case .deleteCategory(let id):
            print(id)
        }
    }
}
