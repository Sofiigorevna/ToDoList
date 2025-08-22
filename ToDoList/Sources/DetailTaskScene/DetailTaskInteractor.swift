//
//  DetailTaskInteractor.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

enum DetailTaskTitleSection: String {
    case title
    case date
    case description
}

/// Протокол для работы с tasks
protocol IDetailTaskInteractor {
    /// Загрузить данные
    func loadData()
    /// Сохранить изменения
    func saveChanges()
    /// Обработка нажатия кнопки back
    func handleBackButton()
}

final class DetailTaskInteractor {
    private let router: IDetailTaskRouter
    private let presenter: IDetailTaskPresenter
    private let taskManager: TaskManagerType = TaskManager()
    private let taskID: Int?
    
    private var sections = [DetailTaskModel.Response.DetailTaskSection]()
    private var currentTask: UserTask?
    
    // Временные данные для редактирования
    private var tempTitle: String = ""
    private var tempDescription: String = ""
    private var hasChanges: Bool = false
    
    init(
        router: IDetailTaskRouter,
        presenter: IDetailTaskPresenter,
        taskID: Int? = nil
    ) {
        self.router = router
        self.presenter = presenter
        self.taskID = taskID
    }
}
// MARK: - Creating Sections
private extension DetailTaskInteractor {
    func createTaskSections(with task: UserTask? = nil) {
        sections = [
            createTitleSection(with: task),
            createDateSection(with: task),
            createDescriptionSection(with: task)
        ]
        self.presenter.publish(data: DetailTaskModel.Response(data: self.sections))
    }
    
    func createTitleSection(with task: UserTask? = nil) -> DetailTaskModel.Response.DetailTaskSection {
        let items: [DetailTaskModel.Response.Item] = [
            .textView(
                text: tempTitle.isEmpty ? (task?.displayTitle ?? "") : tempTitle,
                placeholder: "Название задачи...",
                fontSize: 30,
                textAction: textForTitle)
        ]
        return DetailTaskModel.Response.DetailTaskSection(section: .title(title: DetailTaskTitleSection.title.rawValue), items: items)
    }
    
    func createDateSection(with task: UserTask? = nil) -> DetailTaskModel.Response.DetailTaskSection {
        let items: [DetailTaskModel.Response.Item] = [
            .date(date: task?.formattedCreationDate ?? formatCurrentDate())
        ]
        return DetailTaskModel.Response.DetailTaskSection(section: .title(title: DetailTaskTitleSection.date.rawValue), items: items)
    }
    
    private func formatCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        
        return formatter.string(from: Date())
    }
    
    func createDescriptionSection(with task: UserTask? = nil) -> DetailTaskModel.Response.DetailTaskSection {
        let items: [DetailTaskModel.Response.Item] = [
            .textView(
                text: tempDescription.isEmpty ? (task?.displayDescription ?? "") : tempDescription,
                placeholder: "Описание задачи...",
                fontSize: 15,
                textAction: textForDescription),
        ]
        return DetailTaskModel.Response.DetailTaskSection(section: .title(title: DetailTaskTitleSection.description.rawValue), items: items)
    }
}
// MARK: - IDetailTaskInteractor
extension DetailTaskInteractor: IDetailTaskInteractor {
    func loadData() {
        sections.removeAll()
        
        if let taskID = taskID {
            // Загружаем задачу по serverID
            loadTaskByServerID(taskID)
        } else {
            // Создаем новую задачу или показываем пустую форму
            createNewTask()
        }
    }
    
    func saveChanges() {
        // Проверяем, есть ли изменения
        guard hasChanges else { return }
        
        if let currentTask = currentTask {
            // Обновляем существующую задачу
            let finalTitle = tempTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Без названия" : tempTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            let finalDescription = tempDescription.trimmingCharacters(in: .whitespacesAndNewlines)
            
            taskManager.updateTask(currentTask, title: finalTitle, description: finalDescription.isEmpty ? nil : finalDescription) { [weak self] success in
                if success {
                    self?.hasChanges = false
                    print("Задача успешно обновлена")
                } else {
                    print("Ошибка при обновлении задачи")
                }
            }
        } else {
            // Создаем новую задачу
            let finalTitle = tempTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Без названия" : tempTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            let finalDescription = tempDescription.trimmingCharacters(in: .whitespacesAndNewlines)
            
            taskManager.addTask(title: finalTitle, description: finalDescription.isEmpty ? nil : finalDescription) { [weak self] success in
                if success {
                    self?.hasChanges = false
                    print("Новая задача успешно создана")
                } else {
                    print("Ошибка при создании задачи")
                }
            }
        }
    }
    
    func handleBackButton() {
        // Сохраняем изменения при нажатии кнопки back
        saveChanges()
    }
}

// MARK: - private methods
private extension DetailTaskInteractor {
    func loadTaskByServerID(_ serverID: Int) {
        self.taskManager.getAllTasks { [weak self] tasks in
            guard let self = self else { return }
            
            // Ищем задачу по serverID
            if let task = tasks.first(where: { $0.serverID == Int64(serverID) }) {
                self.currentTask = task
                self.tempTitle = task.displayTitle
                self.tempDescription = task.displayDescription
                self.createTaskSections(with: task)
            } else {
                // Задача не найдена, показываем ошибку или создаем новую
                self.createNewTask()
            }
        }
    }
    
    func createNewTask() {
        // Создаем пустую секцию для новой задачи
        self.tempTitle = ""
        self.tempDescription = ""
        createTaskSections(with: nil)
    }
    
    /// В модель сохраняются введённые пользователем текстовые данные для титла
    func textForTitle(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if tempTitle != trimmedText {
            tempTitle = trimmedText
            hasChanges = true
        }
    }
    
    /// В модель сохраняются введённые пользователем текстовые данные для описания
    func textForDescription(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if tempDescription != trimmedText {
            tempDescription = trimmedText
            hasChanges = true
        }
    }
}
