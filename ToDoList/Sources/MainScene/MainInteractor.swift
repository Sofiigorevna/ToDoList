//
//  MainInteractor.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

enum MainTitleSection: String {
    case taskCard
}

/// Протокол для работы с tasks
protocol IMainInteractor {
    /// Загрузить данные с сервера и локальной базы
    func loadData(completion: @escaping(_ tasksCont: Int) -> ())
    /// Загрузить только локальные данные
    func loadLocalData(completion: @escaping(_ tasksCont: Int) -> ())
    /// Быстрая загрузка локальных данных + фоновая синхронизация с сервером
    func loadDataWithBackgroundSync(completion: @escaping(_ tasksCont: Int) -> ())
    /// Поиск задач по тексту (по всем задачам - локальным и серверным)
    func searchTasks(with query: String, completion: @escaping(_ tasksCount: Int) -> ())
    /// Поиск только по локальным задачам
    func searchLocalTasks(with query: String, completion: @escaping(_ tasksCount: Int) -> ())
    /// Сброс поиска и отображение всех задач
    func clearSearch(completion: @escaping(_ tasksCount: Int) -> ())
    /// переход на страницу
    ///
    /// - Parameter id: id task
    func openDetailTask(with id: Int?)
}

final class MainInteractor {
    
    private let router: IMainRouter
    private let presenter: IMainPresenter
    private let dataSource = NetworkManager.shared
    private let taskManager: TaskManagerType = TaskManager()
    
    private var tasks: [UserTask] = []
    private var sections = [MainModel.Response.MainSection]()
    
    init(
        router: IMainRouter,
        presenter: IMainPresenter
    ) {
        self.router = router
        self.presenter = presenter
    }
}
// MARK: - IMainInteractor
extension MainInteractor: IMainInteractor {
    func searchTasks(with query: String, completion: @escaping(_ tasksCount: Int) -> ()) {
        sections.removeAll()
        
        // Если запрос пустой, показываем все задачи
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            loadLocalData(completion: completion)
            return
        }
        
        // Выполняем поиск через TaskManager (по всем задачам - локальным и серверным)
        taskManager.searchTasks(with: query) { [weak self] filteredTasks in
            guard let self = self else { return }
            
            self.tasks = filteredTasks
            
            // Создаем секции для найденных задач
            for task in filteredTasks {
                self.sections.append(self.createCardSection(task: task))
            }
            
            // Обновляем UI
            self.presenter.publish(data: MainModel.Response(data: self.sections))
            completion(filteredTasks.count)
        }
    }
    
    func searchLocalTasks(with query: String, completion: @escaping(_ tasksCount: Int) -> ()) {
        sections.removeAll()
        
        // Если запрос пустой, показываем только локальные задачи
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            loadLocalData(completion: completion)
            return
        }
        
        // Сначала загружаем только локальные задачи
        taskManager.getAllTasks { [weak self] allTasks in
            guard let self = self else { return }
            
            // Фильтруем только локальные задачи (serverID = 0)
            let localTasks = allTasks.filter { $0.serverID == 0 }
            
            // Выполняем поиск по локальным задачам
            self.taskManager.searchTasks(with: query) { [weak self] filteredTasks in
                guard let self = self else { return }
                
                // Фильтруем результаты поиска, оставляя только локальные задачи
                let localFilteredTasks = filteredTasks.filter { $0.serverID == 0 }
                
                self.tasks = localFilteredTasks
                
                // Создаем секции для найденных задач
                for task in localFilteredTasks {
                    self.sections.append(self.createCardSection(task: task))
                }
                
                // Обновляем UI
                self.presenter.publish(data: MainModel.Response(data: self.sections))
                completion(localFilteredTasks.count)
            }
        }
    }
    
    func clearSearch(completion: @escaping(_ tasksCount: Int) -> ()) {
        // Сбрасываем поиск и показываем все задачи (включая серверные)
        loadDataWithBackgroundSync(completion: completion)
    }
    
    func loadData(completion: @escaping(_ tasksCont: Int) -> ()) {
        sections.removeAll()
        
        // Загружаем данные с сервера и обновляем локальную базу
        getTodosData { [weak self] serverTasks in
            guard let self = self else { return }
            
            // После загрузки с сервера, получаем все задачи (локальные + серверные)
            self.taskManager.getAllTasks { [weak self] allTasks in
                guard let self = self else { return }
                
                self.tasks = allTasks
                for task in allTasks {
                    self.sections.append(self.createCardSection(task: task))
                }
                self.presenter.publish(data: MainModel.Response(data: self.sections))
                completion(allTasks.count)
            }
        }
    }
    
    func openDetailTask(with id: Int?) {
        router.openDetailTask(with: id)
    }
    
    func loadLocalData(completion: @escaping(_ tasksCont: Int) -> ()) {
        sections.removeAll()
        
        // Загружаем только локальные данные
        taskManager.getAllTasks { [weak self] tasks in
            guard let self = self else { return }
            
            self.tasks = tasks
            for task in tasks {
                self.sections.append(self.createCardSection(task: task))
            }
            self.presenter.publish(data: MainModel.Response(data: self.sections))
            completion(tasks.count)
        }
    }
    
    func loadDataWithBackgroundSync(completion: @escaping(_ tasksCont: Int) -> ()) {
        // Сначала быстро загружаем локальные данные
        loadLocalData { [weak self] localTasksCount in
            guard let self = self else { return }
            
            // Вызываем completion сразу с локальными данными
            completion(localTasksCount)
            
            // Затем в фоне синхронизируем с сервером
            self.getTodosData { [weak self] serverTasks in
                guard let self = self else { return }
                
                // После синхронизации с сервером обновляем данные
                self.taskManager.getAllTasks { [weak self] allTasks in
                    guard let self = self else { return }
                    
                    self.tasks = allTasks
                    self.sections.removeAll()
                    
                    for task in allTasks {
                        self.sections.append(self.createCardSection(task: task))
                    }
                    
                    // Обновляем UI с новыми данными (включая серверные) без скрытия индикатора
                    self.presenter.updateDataSilently(data: MainModel.Response(data: self.sections))
                }
            }
        }
    }
}
// MARK: - Creating Sections
private extension MainInteractor {
    func createCardSection(task: UserTask) -> MainModel.Response.MainSection {
        let items: [MainModel.Response.Item] = [
            .taskCard(task: task,
                      goToDetailTask: {},
                      deleteTask: deleteTask,
                      toShareTask: toShareTask,
                      toggleIsDone: toggleCheckmark
                     )
        ]
        
        return MainModel.Response.MainSection(section: .title(title: MainTitleSection.taskCard.rawValue), items: items)
    }
}

// MARK: - private methods
private extension MainInteractor {
    func toggleCheckmark() {
    
    }
    
    func toShareTask() {
        
    }
    
    func deleteTask() {
        
    }
}
// MARK: - Network
private extension MainInteractor {
    func getTodosData(completion: @escaping([UserTask]) -> ()) {
        dataSource.getTodosList { [weak self] result in
            switch result {
                case .success(let success):
                    guard let todos = success.todos else {
                        completion([])
                        return
                    }
                    
                    // Маппим Todo в UserTask и сохраняем в Core Data
                    self?.taskManager.saveTodosFromServer(todos) { userTasks in
                        completion(userTasks)
                    }
                    
                case .failure(let failure):
                    print("\(#file.components(separatedBy: "/").last ?? "") \(#function) \(#line)\nERROR - \(failure)\n")
                    completion([])
            }
        }
    }
}
