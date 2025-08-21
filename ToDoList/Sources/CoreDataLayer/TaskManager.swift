//
//  TaskManager.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation
import CoreData

protocol TaskManagerType {
    // MARK: - Task Operations
    func addTask(
        title: String,
        description: String?,
        completion: @escaping (Bool) -> Void)
    
    func updateTask(
        _ task: UserTask,
        title: String?,
        description: String?,
        completion: @escaping (Bool) -> Void)
    
    func deleteTask(
        _ task: UserTask,
        completion: @escaping (Bool) -> Void)
    
    func toggleTaskCompletion(
        _ task: UserTask,
        completion: @escaping (Bool) -> Void)
    
    // MARK: - Task Retrieval
    func getAllTasks(completion: @escaping ([UserTask]) -> Void)
    func getCompletedTasks(completion: @escaping ([UserTask]) -> Void)
    func getIncompleteTasks(completion: @escaping ([UserTask]) -> Void)
    func searchTasks(
        with query: String,
        completion: @escaping ([UserTask]) -> Void)
    
    // MARK: - Data Management
    func saveChanges(completion: @escaping (Bool) -> Void)
    func clearAllTasks(completion: @escaping (Bool) -> Void)
}

final class TaskManager: TaskManagerType {
    
    // MARK: - Properties
    
    private let coreDataManager: CoreDataManagerType
    private let backgroundQueue = DispatchQueue(label: "com.todolist.taskmanager", qos: .userInitiated)
    
    // MARK: - Initialization
    
    init(coreDataManager: CoreDataManagerType = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Task Operations
    
    func addTask(title: String, description: String? = nil, completion: @escaping (Bool) -> Void) {
        backgroundQueue.async {
            guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedDescription = description?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            self.coreDataManager.createTask(title: trimmedTitle, description: trimmedDescription) { task in
                DispatchQueue.main.async {
                    completion(task != nil)
                }
            }
        }
    }
    
    func updateTask(_ task: UserTask, title: String? = nil, description: String? = nil, completion: @escaping (Bool) -> Void) {
        backgroundQueue.async {
            let trimmedTitle = title?.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedDescription = description?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let title = trimmedTitle, title.isEmpty {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            self.coreDataManager.updateTask(task, title: trimmedTitle, description: trimmedDescription, isCompleted: nil) { success in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
    
    func deleteTask(_ task: UserTask, completion: @escaping (Bool) -> Void) {
        backgroundQueue.async {
            self.coreDataManager.deleteTask(task) { success in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
    
    func toggleTaskCompletion(_ task: UserTask, completion: @escaping (Bool) -> Void) {
        backgroundQueue.async {
            self.coreDataManager.toggleTaskCompletion(task) { success in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
    
    // MARK: - Task Retrieval
    
    func getAllTasks(completion: @escaping ([UserTask]) -> Void) {
        backgroundQueue.async {
            self.coreDataManager.fetchAllTasks(sortedBy: nil) { tasks in
                DispatchQueue.main.async {
                    completion(tasks)
                }
            }
        }
    }
    
    func getCompletedTasks(completion: @escaping ([UserTask]) -> Void) {
        backgroundQueue.async {
            self.coreDataManager.fetchCompletedTasks { tasks in
                DispatchQueue.main.async {
                    completion(tasks)
                }
            }
        }
    }
    
    func getIncompleteTasks(completion: @escaping ([UserTask]) -> Void) {
        backgroundQueue.async {
            self.coreDataManager.fetchIncompleteTasks { tasks in
                DispatchQueue.main.async {
                    completion(tasks)
                }
            }
        }
    }
    
    func searchTasks(with query: String, completion: @escaping ([UserTask]) -> Void) {
        backgroundQueue.async {
            self.coreDataManager.fetchAllTasks(sortedBy: nil) { allTasks in
                let searchResults: [UserTask]
                
                if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    searchResults = allTasks
                } else {
                    searchResults = allTasks.filter { task in
                        task.matches(searchText: query)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(searchResults)
                }
            }
        }
    }
    
    // MARK: - Data Management
    
    func saveChanges(completion: @escaping (Bool) -> Void) {
        backgroundQueue.async {
            self.coreDataManager.saveContext { success in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
    
    func clearAllTasks(completion: @escaping (Bool) -> Void) {
        backgroundQueue.async {
            self.coreDataManager.deleteAllTasks { success in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
}
