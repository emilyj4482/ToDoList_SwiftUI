//
//  GroupViewModel.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/08/29.
//

import Foundation

final class GroupViewModel: ObservableObject {
    // Group.id 저장용 프로퍼티
    private var lastGroupId: Int = 1
    // Group 이름 중복 쵯수 저장용 딕셔너리 [Group 이름: 중복 횟수]
    private var noOverlap: [String: Int] = [:]
    
    // Group Array
    @Published var groups: [Group] = [
        Group(id: 1, name: "Important")
    ]
    // Group : [Task] 딕셔너리
    @Published var todoDic: [Group: [Task]] = [
        Group(id: 1, name: "Important"): []
    ]
    
    func createGroup(_ groupName: String) -> Group {
        let nextId = lastGroupId + 1
        lastGroupId = nextId
        
        // Group 이름 중복 검사
        if todoDic.keys.firstIndex(where: { $0.name == groupName.trim() }) != nil && noOverlap[groupName] == nil {
            noOverlap[groupName] = 1
            if let count = noOverlap[groupName] {
                return Group(id: nextId, name: "\(groupName.trim()) (\(count))")
            }
        } else if todoDic.keys.firstIndex(where: { $0.name == groupName.trim() }) != nil && noOverlap[groupName] != nil {
            noOverlap[groupName]! += 1
            if let count = noOverlap[groupName] {
                return Group(id: nextId, name: "\(groupName.trim()) (\(count))")
            }
        }
        return Group(id: nextId, name: groupName.trim())
    }
    
    func addGroup(_ group: Group) {
        groups.append(group)
        todoDic[group] = []
    }
    
    func deleteGroup(_ group: Group) {
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups.remove(at: index)
        }
        todoDic.removeValue(forKey: group)
    }

    func updateGroup(group: Group, _ name: String) {
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups[index].update(name: name)
        }
        todoDic[Group(id: group.id, name: name)] = todoDic[group]
        todoDic.removeValue(forKey: group)
    }
    
}

// 문자열 앞뒤 공백 삭제 메소드 정의
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
