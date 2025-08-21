//
//  TaskCardViewModel.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation

final class TaskCardViewModel: ICellViewModel {
    let task: UserTask
    var goToDetailTask: (() -> Void)
    var deleteTask: (() -> Void)
    var toShareTask: (() -> Void)
    
    init(
        task: UserTask,
        goToDetailTask: @escaping (() -> Void),
        deleteTask: @escaping (() -> Void),
        toShareTask: @escaping (() -> Void)
    ) {
        self.task = task
        self.goToDetailTask = goToDetailTask
        self.deleteTask = deleteTask
        self.toShareTask = toShareTask
    }
    
    func cellReuseID() -> String {
        TaskCardCell.description()
    }
}
