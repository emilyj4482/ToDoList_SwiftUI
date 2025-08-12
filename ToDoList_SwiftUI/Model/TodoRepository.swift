//
//  TodoRepository.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/08/29.
//  Refactored by EMILY on 2025/08/05.

import Foundation

final class TodoRepository {
    
    private let dataManager = DataManager()
    
    @Published private(set) var categories: [Category] = []
    @Published private(set) var error: DataError?
    
    init() {
        loadCategories()
    }
    
    private func save() {
        do {
            try dataManager.saveData(categories)
            self.error = nil
            print("[TodoRepository] categories are saved successfully.")
        } catch let dataError as DataError {
            self.error = dataError
            print("[TodoRepository] Save failed: \(dataError)")
        } catch {
            self.error = DataError.etc(error)
            print("[TodoRepository] Save failed: \(error)")
        }
    }
    
    private func loadCategories() {
        do {
            let loadedCategories: [Category] = try dataManager.loadData()
            self.categories = loadedCategories.isEmpty ? [Category.defaultImportantCategory] : loadedCategories
            self.error = nil
            print("[TodoRepository] \(loadedCategories.count) categories loaded successfully.")
        } catch DataError.fileNotFound {
            // 앱 최초 실행 시 json file이 없는 것이 정상이므로 error 아닌 것으로 취급
            let isFirstLaunch = !UserDefaults.standard.bool(forKey: Keys.userDefaultsKeyIfLaunchedBefore)
            
            if isFirstLaunch {
                UserDefaults.standard.set(true, forKey: Keys.userDefaultsKeyIfLaunchedBefore)
                self.categories = [Category.defaultImportantCategory]
                print("[TodoRepository] First launch >>> default category is created.")
                self.error = nil
                save()
            } else {
                self.error = DataError.fileNotFound
                self.categories = [Category.defaultImportantCategory]
            }
            
        } catch let dataError as DataError {
            self.error = dataError
            self.categories = [Category.defaultImportantCategory]
        } catch {
            self.error = DataError.etc(error)
            self.categories = [Category.defaultImportantCategory]
        }
    }
    
    func createCategory(with input: String) {
        // name 검사 후 category 생성하여 source에 추가
        let processedName = processCategoryName(input)
        let category = Category(name: processedName, tasks: [])
        categories.append(category)
        save()
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
    
    private func getImportantCategoryIndex() -> Int? {
        return categories.firstIndex { $0.name == "Important" }
    }
    
    func deleteCategory(with id: UUID) {
        // important category가 갖고 있는 해당 카테고리 task 모두 삭제
        if let importantCategoryIndex = getImportantCategoryIndex() {
            categories[importantCategoryIndex].tasks.removeAll { $0.categoryID == id }
        }
        categories.removeAll { $0.id == id }
        save()
    }
    
    func rename(category: Category, to input: String) {
        let processedName = processCategoryName(input)
        
        guard let index = categories.firstIndex(of: category) else { return }
        
        categories[index].rename(to: processedName)
        save()
    }
}

extension TodoRepository {
    func createTask(input: String, to categoryID: UUID) {
        let task = Task(categoryID: categoryID, title: input.trim)
        
        guard let index = categories.firstIndex(where: { $0.id == categoryID }) else { return }
        
        categories[index].tasks.append(task)
        save()
    }
    
    func toggleTaskDone(task: Task) {
        guard let categoryIndex = categories.firstIndex(where: { $0.id == task.categoryID }),
              let taskIndex = categories[categoryIndex].tasks.firstIndex(of: task) else { return }
        
        categories[categoryIndex].tasks[taskIndex].toggleDone()
        
        // important category에서도 toggle 적용
        if task.isImportant,
           let importantCategoryIndex = getImportantCategoryIndex(),
           let taskIndex = categories[importantCategoryIndex].tasks.firstIndex(of: task) {
            categories[importantCategoryIndex].tasks[taskIndex].toggleDone()
        }
        
        save()
    }
    
    func toggleTaskImportant(task: Task) {
        guard let categoryIndex = categories.firstIndex(where: { $0.id == task.categoryID }),
              let taskIndex = categories[categoryIndex].tasks.firstIndex(of: task),
              let importantCategoryIndex = getImportantCategoryIndex()
        else { return }
        
        categories[categoryIndex].tasks[taskIndex].toggleImportant()
        
        // important category에 추가/삭제
        let updatedTask = categories[categoryIndex].tasks[taskIndex]
        
        if updatedTask.isImportant {
            categories[importantCategoryIndex].tasks.append(updatedTask)
        } else {
            categories[importantCategoryIndex].tasks.removeAll { $0.id == updatedTask.id }
        }
    }
}
