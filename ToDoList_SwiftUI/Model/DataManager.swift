//
//  DataManager.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 2023/09/04.
//  Refactored by EMILY on 2025/08/05.

import Foundation

// disk에 app data를 json 파일로 저장해주는 객체
final class DataManager {
    private let fileManager = FileManager.default
    
    init() {
        createDirectoryIfNeeded()
    }
    
    // json 파일로 todo data를 저장할 "ToDoListAppData" 폴더 생성
    private func createDirectoryIfNeeded() {
        guard let directoryURL = getAppDataDirectoryURL() else { return }
        let path = directoryURL.path(percentEncoded: false)
        
        if !fileManager.fileExists(atPath: path) {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
                print("[DataManager] ToDoListAppData Directory CREATED >>> \(path)")
            } catch {
                print("[DataManager] Failed to create directory: \(error.localizedDescription)")
            }
        }
    }
    
    // "ToDoListAppData" 디렉토리 경로를 반환하는 함수
    private func getAppDataDirectoryURL() -> URL? {
        guard let baseURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return nil }
        let directoryURL = baseURL.appending(path: Keys.dataDirectoryName, directoryHint: .isDirectory)
        
        return directoryURL
    }
    
    // json 파일 경로를 반환하는 함수
    private func getJSONFileURL() -> URL? {
        guard let directoryURL = getAppDataDirectoryURL() else { return nil }
        let fileURL = directoryURL.appending(component: Keys.jsonFileName)
        
        return fileURL
    }
    
    func loadData<T: Decodable>() throws -> [T] {
        guard let url = getJSONFileURL() else {
            throw DataError.invalidURL
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw DataError.fileNotFound
        }
        
        do {
            let decodedData = try JSONDecoder().decode([T].self, from: data)
            return decodedData
        } catch {
            throw DataError.decodingFailed(error)
        }
    }
    
    func saveData<T: Encodable>(_ data: [T]) throws {
        guard let url = getJSONFileURL() else {
            throw DataError.invalidURL
        }
        
        do {
            let encodedData = try JSONEncoder().encode(data)
            try encodedData.write(to: url, options: .atomic)    // 기존 파일이 있으면 덮어씀
        } catch {
            throw DataError.saveFailed(error)
        }
    }
}
