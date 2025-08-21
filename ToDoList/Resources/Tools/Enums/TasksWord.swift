//
//  TasksWord.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation

enum TasksWord: String {
    case oneTask = "задача"
    case fewTasks = "задачи"
    case manyTasks = "задач"
    
    /// Возвращает правильное слово для количества задач.
    /// - Parameter count: Количество задач.
    /// - Returns: Правильное слово для количества задач.
    static func wordTask(forCount count: Int) -> String {
        let absCount = abs(count)
        let lastTwoDigits = absCount % 100
        let lastDigit = absCount % 10
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
            return TasksWord.manyTasks.rawValue
        }
        
        switch lastDigit {
        case 1: return TasksWord.oneTask.rawValue
        case 2, 3, 4: return TasksWord.fewTasks.rawValue
        default: return TasksWord.manyTasks.rawValue
        }
    }
}
