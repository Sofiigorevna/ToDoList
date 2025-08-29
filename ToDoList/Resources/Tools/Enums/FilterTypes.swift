//
//  FilterTypes.swift
//  ToDoList
//
//  Created by sofiigorevna on 29.08.2025.
//

import Foundation

/// Перечисление возможных типов фильрации: все/выполненные/не выполненные
enum FilterTypes: String {
    case all = "Все"
    case completed = "Выполненные"
    case notCompleted = "Не выполненные"
    
    static let types: [FilterTypes] = [.all, .completed, .notCompleted]
}
