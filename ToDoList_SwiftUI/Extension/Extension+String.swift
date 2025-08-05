//
//  Extension+String.swift
//  ToDoList_SwiftUI
//
//  Created by EMILY on 05/08/2025.
//

import Foundation

extension String {
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
