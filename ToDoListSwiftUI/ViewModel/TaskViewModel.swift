//
//  TaskViewModel.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/08/30.
//

import SwiftUI

final class TaskViewModel: ObservableObject {
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
    
    func createTask(_ title: String) -> Task {
        return Task(title: title.trim(), isDone: false, isImportant: false)
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        updateDic()
    }
    
    // important task인 경우 Important value도 update 필요
    func updateTaskComplete(_ task: Task) {
        if task.isImportant, let index = todoDic.wrappedValue[important]?.firstIndex(where: { $0.id == task.id }) {
            todoDic.wrappedValue[important]?[index].update(title: task.title, isDone: task.isDone, isImportant: task.isImportant)
        }
        updateSingleTask(taskId: task.id, task: task)
        updateDic()
    }
    
    private func updateSingleTask(taskId: UUID, task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks[index].update(title: task.title, isDone: task.isDone, isImportant: task.isImportant)
        }
    }
    
    // isImportant update : Important value로의 추가/삭제 동작 함께 필요
    func updateImportant(_ task: Task) {
        if task.isImportant {
            todoDic.wrappedValue[important]?.append(task)
        } else {
            if let index = todoDic.wrappedValue[important]?.firstIndex(where: { $0.id == task.id }) {
                todoDic.wrappedValue[important]?.remove(at: index)
            }
        }
        updateSingleTask(taskId: task.id, task: task)
        updateDic()
    }
    
    // important task인 경우 Important value도 삭제 필요
    func deleteTaskComplete(_ task: Task) {
        if
            task.isImportant,
            let index = todoDic.wrappedValue[important]?.firstIndex(where: { $0.id == task.id })
        {
            todoDic.wrappedValue[important]?.remove(at: index)
        }
        deleteSingleTask(taskId: task.id)
        updateDic()
    }
    
    private func deleteSingleTask(taskId: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks.remove(at: index)
        }
    }
    
    private func updateDic() {
        if todoDic.wrappedValue.index(forKey: group) != nil {
            todoDic.wrappedValue.updateValue(tasks, forKey: group)
        }
    }
}
