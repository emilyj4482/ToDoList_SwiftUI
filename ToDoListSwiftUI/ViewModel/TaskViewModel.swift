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
    
    // 선택된 group 저장용 프로퍼티
    @Published var selectedGroup: Group?
    // 선택된 group index 저장용 프로퍼티
    @Published var selectedGroupIndex: Int?
    // navigation destination isPresented
    @Published var navLinkPresented: Bool = false
    
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
    
    // Task 내용은 중복 허용(검사 X), 입력값에 대해 앞뒤 공백을 제거해준 뒤 생성한다.
    func createTask(groupId: Int, _ title: String) -> Task {
        let nextId = lastTaskId + 1
        lastTaskId = nextId
        return Task(id: nextId, groupId: groupId, title: title.trim(), isDone: false, isImportant: false)
    }
    
    func addTask(groupId: Int, _ task: Task) {
        if let index = groups.firstIndex(where: { $0.id == groupId }) {
            groups[index].tasks.append(task)
        }
    }
    
    // important task인 경우 Important list와 속한 list 양쪽에서 업데이트 필요
    func updateTaskComplete(_ task: Task) {
        if task.isImportant {
            updateSingleTask(groupId: 1, taskId: task.id, task: task)
        }
        updateSingleTask(groupId: task.groupId, taskId: task.id, task: task)
    }
    
    private func updateSingleTask(groupId: Int, taskId: Int, task: Task) {
        if let index1 = groups.firstIndex(where: { $0.id == groupId }) {
            if let index2 = groups[index1].tasks.firstIndex(where: { $0.id == taskId }) {
                groups[index1].tasks[index2].update(title: task.title, isDone: task.isDone, isImportant: task.isImportant)
            }
        }
    }
    
    // isImportant update : Important list로의 추가/삭제 함께 동작 필요
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
    
    // important task인 경우 Important list와 속한 list 양쪽에서 삭제 처리 필요
    func deleteTaskComplete(_ task: Task) {
        if task.isImportant {
            deleteSingleTask(groupId: 1, taskId: task.id)
        }
        deleteSingleTask(groupId: task.groupId, taskId: task.id)
    }
    
    private func deleteSingleTask(groupId: Int, taskId: Int) {
        if let index1 = groups.firstIndex(where: { $0.id == groupId }) {
            if let index2 = groups[index1].tasks.firstIndex(where: { $0.id == taskId }) {
                groups[index1].tasks.remove(at: index2)
            }
        }
    }
    
    func deleteGroup(groupId: Int) {
        if let index = groups.firstIndex(where: { $0.id == groupId }) {
            groups.remove(at: index)
        }
    }
    
    func updateGroup(groupId: Int, _ name: String) {
        if let index = groups.firstIndex(where: { $0.id == groupId }) {
            groups[index].update(name: name)
        }
    }
    
    // task.isDone 여부에 따라 section 분리
    func unDoneTasks(groupIndex: Int) -> [Task] {
        return groups[groupIndex].tasks.filter({ $0.isDone == false })
    }
    
    func isDoneTasks(groupIndex: Int) -> [Task] {
        return groups[groupIndex].tasks.filter({ $0.isDone == true })
    }
    
}

// 문자열 앞뒤 공백 삭제 메소드 정의
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
