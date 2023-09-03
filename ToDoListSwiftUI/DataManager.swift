//
//  DataManager.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/09/04.
//

import SwiftUI

class DataManager {
    
    // singleton
    static let instance = DataManager()
    
    // FileManager
    private let fm = FileManager.default
    
    init() {
        createDir()
    }
    
    // data를 저장할 "TodoListApp" 폴더 생성
    private func createDir() {
        // 디렉토리 경로
        guard let path = fm.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoListApp", conformingTo: .directory).path else { return }
        
        // 경로에 디렉토리가 없을 경우에만 생성
        if !fm.fileExists(atPath: path) {
            do {
                try fm.createDirectory(atPath: path, withIntermediateDirectories: true)
                print("TodoListApp Directory CREATED")
            } catch {
                print("ERROR Creating Directory >>> \(error)")
            }
        }
    }
    
    // JSON 경로를 반환하는 함수
    private func getPathForJSON() -> URL? {
        guard
            let path = fm.urls(for: .documentDirectory, in: .userDomainMask).first?
                .appendingPathComponent("TodoListApp", conformingTo: .directory)
                .appending(component: "todo.json")
        else {
            print("ERROR Getting Path")
            return nil
        }
        return path
    }
    
    // data 저장
    func saveData(_ groups: [Group]) {
        guard let path = getPathForJSON() else { return }
        
        // Array > JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(groups)
            if fm.fileExists(atPath: path.path) {
                try fm.removeItem(at: path)
            }
            fm.createFile(atPath: path.path, contents: data)
        } catch {
            print("ERROR Saving Data >>> \(error)")
        }
    }
    
    // data 불러오기
    func getData() -> [Group] {
        guard
            let path = getPathForJSON(),
            fm.fileExists(atPath: path.path),
            let data = fm.contents(atPath: path.path)
        else {
            // App 최초 실행 시에도 Important group이 기본적으로 있도록 함.
            return [Group(id: 1, name: "Important", tasks: [])]
        }
        
        // JSON > Array
        let decoder = JSONDecoder()
        
        do {
            let groups = try decoder.decode([Group].self, from: data)
            return groups
        } catch {
            print("ERROR Getting Data >>> \(error)")
            return []
        }
    }
}
