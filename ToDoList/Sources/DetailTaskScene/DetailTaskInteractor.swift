//
//  DetailTaskInteractor.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

enum DetailTaskTitleSection: String {
    case taskCard
}

/// Протокол для работы с tasks
protocol IDetailTaskInteractor {
    /// Загрузить данные
    func loadData()
}

final class DetailTaskInteractor {
    
    private let router: IDetailTaskRouter
    private let presenter: IDetailTaskPresenter
    private let taskManager: TaskManagerType = TaskManager()
    private let taskID: Int?
  
    private var sections = [DetailTaskModel.Response.DetailTaskSection]()
    private var currentTask: UserTask?
    
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
    
    private func loadTaskByServerID(_ serverID: Int) {
        taskManager.getAllTasks { [weak self] tasks in
            guard let self = self else { return }
            
            // Ищем задачу по serverID
            if let task = tasks.first(where: { $0.serverID == Int64(serverID) }) {
                self.currentTask = task
                self.sections.append(self.createCardSection(with: task))
                self.presenter.publish(data: DetailTaskModel.Response(data: self.sections))
                
                // Устанавливаем заголовок для существующей задачи
                self.presenter.updateTitle(task.displayTitle)
            } else {
                // Задача не найдена, показываем ошибку или создаем новую
                self.createNewTask()
            }
        }
    }
    
    private func createNewTask() {
        // Создаем пустую секцию для новой задачи
        sections.append(createCardSection())
        presenter.publish(data: DetailTaskModel.Response(data: self.sections))
        
        // Устанавливаем заголовок для новой задачи
        presenter.updateTitle("Новая задача")
    }
}
// MARK: - Creating Sections
private extension DetailTaskInteractor {
    func createCardSection(with task: UserTask? = nil) -> DetailTaskModel.Response.DetailTaskSection {
        let items: [DetailTaskModel.Response.Item] = [
            // Здесь будут элементы для редактирования задачи
        ]
        return DetailTaskModel.Response.DetailTaskSection(section: .title(title: DetailTaskTitleSection.taskCard.rawValue), items: items)
    }
    
    func createSections(with arts: [Any]) {
        if arts.isEmpty {
            
//            let emptyImageSection = managerSections.createEmptyImageSection()
//
//            let twoTitlesSection = managerSections.createTwoTitlesSection()
//
//            let buttonSection = managerSections.createButtonSection(action: pressToButton)
//
//            sections = [emptyImageSection, twoTitlesSection, buttonSection]
        } else {
                       
//            // Добавляет art в userDefaults (которые пришли с сервера, допустим добавленные с сайта)
//            arts.forEach { [weak self] art in
//                guard let self else { return }
//                self.userDefaults.saveProductIsFavorite(product.slug ?? "")
//            }
//
//            let artsSection = managerSections.createProductSection(
//                products: products, addToBasket: addToBasket, addToFavorite: addToFavorite(_:_:))
//
//            sections = [productsSection]
        }
        
        presenter.publish(data: DetailTaskModel.Response(data: self.sections))
    }
}

