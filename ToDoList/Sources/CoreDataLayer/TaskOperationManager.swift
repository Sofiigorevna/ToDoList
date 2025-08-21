//
//  TaskOperationManager.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

protocol TaskOperationManagerType {
    func performTaskOperation<T>(
        operation: @escaping (@escaping (Result<T, Error>) -> Void) -> Void,
        onSuccess: @escaping (T) -> Void,
        onError: @escaping (Error) -> Void,
        showLoading: Bool
    )
}

final class TaskOperationManager: TaskOperationManagerType {
    
    // MARK: - Properties
    
    private let taskManager: TaskManagerType
    private weak var viewController: UIViewController?
    
    // MARK: - Initialization
    
    init(taskManager: TaskManagerType = TaskManager(), viewController: UIViewController?) {
        self.taskManager = taskManager
        self.viewController = viewController
    }
    
    // MARK: - Task Operation Management
    
    func performTaskOperation<T>(
        operation: @escaping (@escaping (Result<T, Error>) -> Void) -> Void,
        onSuccess: @escaping (T) -> Void,
        onError: @escaping (Error) -> Void,
        showLoading: Bool = false
    ) {
        if showLoading {
            showLoadingIndicator()
        }
        
        operation { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLoadingIndicator()
                
                switch result {
                case .success(let value):
                    onSuccess(value)
                case .failure(let error):
                    onError(error)
                }
            }
        }
    }
    
    // MARK: - Convenience Methods
    
    func addTask(
        title: String,
        description: String?,
        onSuccess: @escaping () -> Void,
        onError: @escaping (String) -> Void,
        showLoading: Bool = true
    ) {
        performTaskOperation(
            operation: { completion in
                self.taskManager.addTask(title: title, description: description) { success in
                    if success {
                        completion(.success(()))
                    } else {
                        completion(.failure(TaskError.creationFailed))
                    }
                }
            },
            onSuccess: { _ in onSuccess() },
            onError: { error in onError(error.localizedDescription) },
            showLoading: showLoading
        )
    }
    
    func updateTask(
        _ task: UserTask,
        title: String?,
        description: String?,
        onSuccess: @escaping () -> Void,
        onError: @escaping (String) -> Void,
        showLoading: Bool = true
    ) {
        performTaskOperation(
            operation: { completion in
                self.taskManager.updateTask(task, title: title, description: description) { success in
                    if success {
                        completion(.success(()))
                    } else {
                        completion(.failure(TaskError.updateFailed))
                    }
                }
            },
            onSuccess: { _ in onSuccess() },
            onError: { error in onError(error.localizedDescription) },
            showLoading: showLoading
        )
    }
    
    func deleteTask(
        _ task: UserTask,
        onSuccess: @escaping () -> Void,
        onError: @escaping (String) -> Void,
        showLoading: Bool = true
    ) {
        performTaskOperation(
            operation: { completion in
                self.taskManager.deleteTask(task) { success in
                    if success {
                        completion(.success(()))
                    } else {
                        completion(.failure(TaskError.deletionFailed))
                    }
                }
            },
            onSuccess: { _ in onSuccess() },
            onError: { error in onError(error.localizedDescription) },
            showLoading: showLoading
        )
    }
    
    func toggleTaskCompletion(
        _ task: UserTask,
        onSuccess: @escaping () -> Void,
        onError: @escaping (String) -> Void,
        showLoading: Bool = false
    ) {
        performTaskOperation(
            operation: { completion in
                self.taskManager.toggleTaskCompletion(task) { success in
                    if success {
                        completion(.success(()))
                    } else {
                        completion(.failure(TaskError.toggleFailed))
                    }
                }
            },
            onSuccess: { _ in onSuccess() },
            onError: { error in onError(error.localizedDescription) },
            showLoading: showLoading
        )
    }
    
    func loadTasks(
        onSuccess: @escaping ([UserTask]) -> Void,
        onError: @escaping (String) -> Void,
        showLoading: Bool = true
    ) {
        performTaskOperation(
            operation: { completion in
                self.taskManager.getAllTasks { tasks in
                    completion(.success(tasks))
                }
            },
            onSuccess: onSuccess,
            onError: { error in onError(error.localizedDescription) },
            showLoading: showLoading
        )
    }
    
    func searchTasks(
        query: String,
        onSuccess: @escaping ([UserTask]) -> Void,
        onError: @escaping (String) -> Void,
        showLoading: Bool = false
    ) {
        performTaskOperation(
            operation: { completion in
                self.taskManager.searchTasks(with: query) { tasks in
                    completion(.success(tasks))
                }
            },
            onSuccess: onSuccess,
            onError: { error in onError(error.localizedDescription) },
            showLoading: showLoading
        )
    }
    
    // MARK: - Loading Indicators
    
    private func showLoadingIndicator() {
        DispatchQueue.main.async {
            // You can implement a custom loading indicator here
            // For now, we'll use the system activity indicator
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

// MARK: - Task Errors

enum TaskError: LocalizedError {
    case creationFailed
    case updateFailed
    case deletionFailed
    case toggleFailed
    case fetchFailed
    
    var errorDescription: String? {
        switch self {
        case .creationFailed:
            return "Не удалось создать задачу"
        case .updateFailed:
            return "Не удалось обновить задачу"
        case .deletionFailed:
            return "Не удалось удалить задачу"
        case .toggleFailed:
            return "Не удалось изменить статус задачи"
        case .fetchFailed:
            return "Не удалось загрузить задачи"
        }
    }
}

