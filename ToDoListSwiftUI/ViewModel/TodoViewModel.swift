//
//  TodoViewModel.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/08/29.
//

import Foundation

final class TodoViewModel: ObservableObject {
    
    // disk에 app data를 json 파일로 저장해주는 data manager
    private let dm = DataManager.instance
    
    
    // Group.id 저장용 프로퍼티
    private var lastGroupId: Int = 1
    // Group 이름 중복 쵯수 저장용 딕셔너리 [Group 이름: 중복 횟수]
    private var noOverlap: [String: Int] = [:]
    
    // Group Array : Important group은 고정값
    // Array에 변동이 생길 때마다 disk에 저장 : didSet
    @Published var groups: [Group] = [
        Group(id: 1, name: "Important", tasks: [])
    ] {
        didSet {
            dm.saveData(groups)
        }
    }
    
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
    
    func deleteGroup(_ group: Group) {
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups.remove(at: index)
        }
    }

    func updateGroup(group: Group, _ name: String) {
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups[index].update(name: name)
        }
    }
    
    func createTask(groupId: Int, _ title: String) -> Task {
        return Task(groupId: groupId, title: title.trim(), isDone: false, isImportant: false)
    }
    
    func addTask(groupId: Int, _ task: Task) {
        if let index = groups.firstIndex(where: { $0.id == groupId }) {
            groups[index].tasks.append(task)
        }
    }
    
    // important task인 경우 Important group과 task가 속한 group 양쪽에서 삭제 필요
    func deleteTaskComplete(_ task: Task) {
        if task.isImportant {
            deleteSingleTask(groupId: 1, taskID: task.id)
        }
        deleteSingleTask(groupId: task.groupId, taskID: task.id)
    }
    
    private func deleteSingleTask(groupId: Int, taskID: UUID) {
        if let index = groups.firstIndex(where: { $0.id == groupId }) {
            groups[index].tasks.removeAll(where: { $0.id == taskID })
        }
    }
    
    // important task인 경우 Important group과 task가 속한 group 양쪽에서 update 필요
    func updateTaskComplete(_ task: Task) {
        if task.isImportant {
            updateSingleTask(groupId: 1, taskId: task.id, task: task)
        }
        updateSingleTask(groupId: task.groupId, taskId: task.id, task: task)
    }
    
    private func updateSingleTask(groupId: Int, taskId: UUID, task: Task) {
        if let index1 = groups.firstIndex(where: { $0.id == groupId }),
           let index2 = groups[index1].tasks.firstIndex(where: { $0.id == taskId }) {
            groups[index1].tasks[index2].update(title: task.title, isDone: task.isDone, isImportant: task.isImportant)
        }
    }
    
    // isImportant update: Important group으로의 추가/삭제 동작 함께 필요
    func updateImportant(_ task: Task) {
        if task.isImportant {
            groups[0].tasks.append(task)
        } else {
            if let index = groups[0].tasks.firstIndex(where: { $0.id == task.id }) {
                groups[0].tasks.remove(at: index)
            }
        }
        updateSingleTask(groupId: task.groupId, taskId: task.id, task: task)
    }
    
    // disk에서 저장된 data를 불러와 groups 및 lastGroupId 값에 적용
    func retrieveGroups() {
        groups = dm.getData()
        
        let lastId = groups.last?.id
        lastGroupId = lastId ?? 1
    }
}

// 문자열 앞뒤 공백 삭제 메소드 정의
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
