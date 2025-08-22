//
//  UserTask+Extensions.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation
import CoreData

extension UserTask {
    
    // MARK: - Computed Properties
    
    var displayTitle: String {
        return title ?? "Без названия"
    }
    
    var displayDescription: String {
        return taskDescription ?? "Нет описания"
    }
    
    var formattedCreationDate: String {
        guard let creationDate = creationDate else {
            return "Дата неизвестна"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        
        return formatter.string(from: creationDate)
    }
    
    var statusText: String {
        return isCompleted ? "Выполнено" : "Не выполнено"
    }
    
    var statusIcon: String {
        return isCompleted ? Images.checkmark.rawValue : Images.circle.rawValue
    }
    
    // MARK: - Validation
    
    var isValid: Bool {
        return !(title?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    }
    
    // MARK: - Convenience Methods
    
    func toggleCompletion() {
        isCompleted.toggle()
    }
    
    func markAsCompleted() {
        isCompleted = true
    }
    
    func markAsIncomplete() {
        isCompleted = false
    }
    
    // MARK: - Search
    
    func matches(searchText: String) -> Bool {
        let searchLower = searchText.lowercased()
        let titleLower = title?.lowercased() ?? ""
        let descriptionLower = taskDescription?.lowercased() ?? ""
        
        return titleLower.contains(searchLower) || descriptionLower.contains(searchLower)
    }
    
    // MARK: - Mapping from DTO
    
    static func createFromTodo(_ todo: Todo, in context: NSManagedObjectContext) -> UserTask {
        let userTask = UserTask(context: context)
        userTask.id = UUID()
        userTask.serverID = Int64(todo.id ?? 0)
        userTask.title = todo.todo
        userTask.taskDescription = nil // У Todo нет описания, можно оставить nil или добавить дефолтное значение
        userTask.isCompleted = todo.completed ?? false
        userTask.creationDate = Date() // Используем текущую дату, так как в Todo нет даты создания
        
        return userTask
    }
    
    static func createFromTodos(_ todos: [Todo], in context: NSManagedObjectContext) -> [UserTask] {
        return todos.map { createFromTodo($0, in: context) }
    }
}
