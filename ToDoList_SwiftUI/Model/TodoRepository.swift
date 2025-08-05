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
    
    // TODO: handle file not found
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
    
    func createCategory(with input: String) {
        // name 검사 후 category 생성하여 source에 추가
        let processedName = processCategoryName(input)
        let category = Category(name: processedName, tasks: [])
        categories.append(category)
    }
    
    private func processCategoryName(_ input: String) -> String {
        // 1. 공백 제거
        let trimmedInput = input.trim
        // 2. 완전 공백일 시 default name 부여
        let baseName = trimmedInput.isEmpty ? "Untitled Category" : trimmedInput
        // 3. 기존 이름들
        let existingNames = categories.compactMap { $0.name }
        // 4. 중복 검사 : 중복 시 (n) 붙이고 반환
        var count = 1
        var finalName = baseName
        
        while existingNames.contains(finalName) {
            finalName = "\(baseName) (\(count))"
            count += 1
        }
        
        return finalName
    }
}
