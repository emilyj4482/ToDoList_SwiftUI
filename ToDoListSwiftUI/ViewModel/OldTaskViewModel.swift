//
//  OldTaskViewModel.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/17.
//

import SwiftUI

final class OldTaskViewModel: ObservableObject {
    
    // 선택된 group 전달 받을 프로퍼티
    @Published var group: Group
    // Task Array
    @Published var tasks: [Task]

    // GroupViewModel에 있는 딕셔너리 참조 data
    @Published var todoDic: Binding<[Group: [Task]]>
    
    init(group: Group, tasks: [Task], todoDic: Binding<[Group : [Task]]>) {
        self.group = group
        self.tasks = tasks
        self.todoDic = todoDic
    }
    
    private let important: Group = Group(id: 1, name: "Important")
    
    // Task 내용은 중복 허용(검사 X), 입력값에 대해 앞뒤 공백을 제거해준 뒤 생성한다.
    func createTask(_ title: String) -> Task {
        return Task(title: title.trim(), isDone: false, isImportant: false)
    }
    
    func addTask(_ task: Task) {
        /* if let index = groups.firstIndex(where: { $0.id == groupId }) {
            groups[index].tasks.append(task)
        } */
        todoDic[group].wrappedValue?.append(task)
    }
    
    // important task인 경우 Important list와 속한 list 양쪽에서 업데이트 필요
    func updateTaskComplete(_ task: Task) {
        if task.isImportant {
            // updateSingleTask(groupId: 1, taskId: task.id, task: task)
            updateSingleTask(group: important, taskId: task.id, task: task)
        }
        updateSingleTask(group: group, taskId: task.id, task: task)
    }
    
    private func updateSingleTask(group: Group, taskId: UUID, task: Task) {
        /*
        if let index1 = groups.firstIndex(where: { $0.id == groupId }) {
            if let index2 = groups[index1].tasks.firstIndex(where: { $0.id == taskId }) {
                groups[index1].tasks[index2].update(title: task.title, isDone: task.isDone, isImportant: task.isImportant)
            }
        }
        */
        if let index = todoDic.wrappedValue[group]?.firstIndex(where: { $0.id == taskId }) {
            todoDic.wrappedValue[group]?[index].update(title: task.title, isDone: task.isDone, isImportant: task.isImportant)
        }
    }
    
    // isImportant update : Important list로의 추가/삭제 함께 동작 필요
    func updateImportant(_ task: Task) {
        if task.isImportant {
            // groups[0].tasks.append(task)
            todoDic.wrappedValue[important]?.append(task)
        } else {
            if let index = todoDic.wrappedValue[important]?.firstIndex(where: { $0.id == task.id }) {
                todoDic.wrappedValue[important]?.remove(at: index)
            }
        }
        // updateSingleTask(groupId: task.groupId, taskId: task.id, task: task)
        updateSingleTask(group: group, taskId: task.id, task: task)
    }
    
    // important task인 경우 Important list와 속한 list 양쪽에서 삭제 처리 필요
    func deleteTaskComplete(_ task: Task) {
        if task.isImportant {
            deleteSingleTask(group: important, taskId: task.id)
        }
        deleteSingleTask(group: group, taskId: task.id)
    }
    
    private func deleteSingleTask(group: Group, taskId: UUID) {
        /*
        if let index1 = groups.firstIndex(where: { $0.id == groupId }) {
            if let index2 = groups[index1].tasks.firstIndex(where: { $0.id == taskId }) {
                groups[index1].tasks.remove(at: index2)
            }
        }
        */
        if let index = todoDic.wrappedValue[group]?.firstIndex(where: { $0.id == taskId }) {
            todoDic.wrappedValue[group]?.remove(at: index)
        }
        
    }
    
    

    /* list에 속한 task들을 isDone 여부에 따라 구분
    func reloadTasks(_ groupIndex: Int) {
        undoneTasks = groups[groupIndex].tasks.filter({ $0.isDone == false })
        doneTasks = groups[groupIndex].tasks.filter({ $0.isDone == true })
    }
    */
    
}


