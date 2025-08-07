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
        Publishers.CombineLatest(
            repository.$categories,
            repository.$error
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] categories, error in
            self?.state = MainState(categories: categories, error: error)
        }
        .store(in: &cancellables)
    }
    
    func send(_ intent: MainIntent) {
        reduce(intent)
    }
    
    private func reduce(_ intent: MainIntent) {
        switch intent {
        case .deleteCategory(let id):
            repository.deleteCategory(with: id)
        }
    }
}
