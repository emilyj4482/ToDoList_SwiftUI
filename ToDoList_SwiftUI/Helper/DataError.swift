//
//  DataError.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 05/08/2025.
//

import Foundation

enum DataError: LocalizedError {
    case invalidURL
    case fileNotFound
    case decodingFailed(Error)
    case saveFailed(Error)
    case etc(Error)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "[DataManager] invalid URL"
        case .fileNotFound:
            return "[DataManager] json file not found"
        case .decodingFailed(let error):
            return "[DataManager] failed to decode data: \(error.localizedDescription)"
        case .saveFailed(let error):
            return "[DataManager] failed to save data: \(error.localizedDescription)"
        case .etc(let error):
            return "[DataManager] some error occured : \(error.localizedDescription)"
        }
    }
}
