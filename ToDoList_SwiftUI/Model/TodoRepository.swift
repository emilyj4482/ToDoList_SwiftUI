//
//  TodoRepository.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/08/29.
//  Refactored by EMILY on 2025/08/05.

import Foundation
import Combine

final class TodoRepository {
    
    private let dataManager = DataManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var categories: [Category] = []
    @Published private(set) var error: DataError?
    
    init() {
        loadCategories()
        save()
    }
    
    // 변경사항이 발생할 때마다 데이터를 저장
    private func save() {
        $categories
            .dropFirst()    // 기본값인 빈 배열이 이벤트로 방출돼도 무시
            .sink { [weak self] categories in
                do {
                    try self?.dataManager.saveData(categories)
                    self?.error = nil
                    print("[TodoRepository] data change saved.")
                } catch let dataError as DataError {
                    self?.error = dataError
                } catch {
                    self?.error = DataError.etc(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadCategories() {
        do {
            let loadedCategories: [Category] = try dataManager.loadData()
            self.categories = loadedCategories.isEmpty ? [Category.defaultImportantCategory] : loadedCategories
            self.error = nil
        } catch let dataError as DataError {
            self.error = dataError
            self.categories = [Category.defaultImportantCategory]
        } catch {
            self.error = DataError.etc(error)
        }
    }
}
