//
//  TaskViewModel.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/17.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    
    // Task.id 저장용 프로퍼티
    private var lastTaskId: Int = 0
    // Group.id 저장용 프로퍼티
    private var lastGroupId: Int = 1
    // Group 이름 중복 쵯수 저장용 딕셔너리 [Group 이름: 중복 횟수]
    private var noOverlap: [String: Int] = [:]
    // Important group은 고정값
    @Published var groups: [Group] = [Group(id: 1, name: "Important", tasks: [])]
    
    func createGroup(_ groupName: String) -> Group {
        let nextId = lastGroupId + 1
        lastGroupId = nextId
        
        // Group 이름 중복 검사
        if groups.firstIndex(where: { $0.name == groupName.trim() }) != nil && noOverlap[groupName] == nil {
            noOverlap[groupName] = 1
            if let count = noOverlap[groupName] {
                return Group(id: nextId, name: "\(groupName.trim()) (\(count))", tasks: [])
            }
        } else if groups.firstIndex(where: { $0.name == groupName.trim() }) != nil && noOverlap[groupName] != nil {
            noOverlap[groupName]! += 1
            if let count = noOverlap[groupName] {
                return Group(id: nextId, name: "\(groupName.trim()) (\(count))", tasks: [])
            }
        }
        return Group(id: nextId, name: groupName.trim(), tasks: [])
    }
    
    func addGroup(_ group: Group) {
        groups.append(group)
    }
}

// 문자열 앞뒤 공백 삭제 메소드 정의
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
