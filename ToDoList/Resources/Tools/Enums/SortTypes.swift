//
//  SortTypes.swift
//  ToDoList
//
//  Created by sofiigorevna on 29.08.2025.
//

import Foundation

/// Перечисление возможных типов сортировки
enum SortTypes: String {
    case completed = "Сначала выполненные"
    case noCompleted = "Сначала невыполненные"
    case defaultSort = "По умолчанию"
    
    static let types: [SortTypes] = [.completed, .noCompleted, .defaultSort]
}
