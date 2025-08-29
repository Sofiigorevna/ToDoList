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
    /// Быстрая загрузка локальных данных + фоновая синхронизация с сервером
    func loadDataWithBackgroundSync()
    /// Поиск задач по тексту (по всем задачам - локальным и серверным)
    func searchTasks(with query: String, completion: @escaping(_ tasksCount: Int) -> ())
    /// Поиск только по локальным задачам
    func searchLocalTasks(with query: String, completion: @escaping(_ tasksCount: Int) -> ())
    /// Сброс поиска и отображение всех задач
    func clearSearch(completion: @escaping(_ tasksCount: Int) -> ())
    /// переход на страницу
    ///
    /// - Parameter task: задача для перехода
    func openDetailTask(with task: UserTask)
    /// создание новой задачи
    func createNewTask()
    /// фильтр по статусу (все/выполненные/не выполненные)
    func newLoadView(typeFilter: FilterTypes)
    /// сортировка (не выполненные сначала, затем по дате создания)
    func newLoadView(typeSort: SortTypes)
    func pushToAlertFilterType()
    func pushToAlertSortType()
}

final class MainInteractor {
    private let router: IMainRouter
    private let presenter: IMainPresenter
    private let dataSource = NetworkManager.shared
    private let taskManager: TaskManagerType = TaskManager()
    
    private var tasks: [UserTask] = []
    private var sections = [MainModel.Response.MainSection]()
    
    // Состояние фильтрации и сортировки
    private var currentFilter: FilterTypes = .all
    private var currentSort: SortTypes = .defaultSort
    private var originalTasks: [UserTask] = [] // Сохраняем оригинальные задачи для сброса фильтров
    
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
        
        // Если запрос пустой, применяем текущие фильтры и сортировку
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            applyFiltersAndSort()
            completion(tasks.count)
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
            self.presenter.publish(data: MainModel.Response(data: self.sections), tasksCont: tasks.count)
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
                self.presenter.publish(data: MainModel.Response(data: self.sections), tasksCont: tasks.count)
                completion(localFilteredTasks.count)
            }
        }
    }
    
    func clearSearch(completion: @escaping(_ tasksCount: Int) -> ()) {
        // Сбрасываем поиск и применяем текущие фильтры и сортировку
        applyFiltersAndSort()
        completion(tasks.count)
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
                self.presenter.publish(data: MainModel.Response(data: self.sections), tasksCont: tasks.count)
                completion(allTasks.count)
            }
        }
    }
    
    func openDetailTask(with task: UserTask) {
        // Передаем serverID для серверных задач или nil для локальных
        let serverID: Int? = task.serverID > 0 ? Int(task.serverID) : nil
        router.openDetailTask(with: serverID)
    }
    
    func createNewTask() {
        // Передаем nil для создания новой задачи
        router.openDetailTask(with: nil)
    }
    
    func loadLocalData(completion: @escaping(_ tasksCont: Int) -> ()) {
        sections.removeAll()
        
        // Загружаем только локальные данные
        taskManager.getAllTasks { [weak self] tasks in
            guard let self = self else { return }
            
            self.tasks = tasks
            self.originalTasks = tasks // Сохраняем оригинальные задачи
            for task in tasks {
                self.sections.append(self.createCardSection(task: task))
            }
            self.presenter.publish(data: MainModel.Response(data: self.sections), tasksCont: tasks.count)
            completion(tasks.count)
        }
    }
    
    func loadDataWithBackgroundSync() {
        // Сначала быстро загружаем локальные данные
        loadLocalData { [weak self] localTasksCount in
            guard let self = self else { return }
            
            // Затем в фоне синхронизируем с сервером
            self.getTodosData { [weak self] serverTasks in
                guard let self = self else { return }
                
                // После синхронизации с сервером обновляем данные
                self.taskManager.getAllTasks { [weak self] allTasks in
                    guard let self = self else { return }
                    
                    self.tasks = allTasks
                    self.originalTasks = allTasks // Сохраняем оригинальные задачи
                    self.sections.removeAll()
                    
                    for task in allTasks {
                        self.sections.append(self.createCardSection(task: task))
                    }
                    
                    // Обновляем UI с новыми данными (включая серверные) без скрытия индикатора
                    self.presenter.updateDataSilently(data: MainModel.Response(data: self.sections), tasksCont: tasks.count)
                }
            }
        }
    }
    
    /// Открывает Alert для выбора категории filter
    func pushToAlertFilterType() {
        presenter.updateFilterData(FilterTypes.types)
    }
    
    func pushToAlertSortType() {
        presenter.updateSortData(SortTypes.types)
    }
    
    func newLoadView(typeFilter: FilterTypes) {
        currentFilter = typeFilter
        
        // Если выбран фильтр "Все" и текущая сортировка "По умолчанию", загружаем как при первой загрузке
        if typeFilter == .all && currentSort == .defaultSort {
            loadLocalData { _ in
                // Данные уже загружены и отображены
            }
        } else {
            applyFiltersAndSort()
        }
    }
    
    func newLoadView(typeSort: SortTypes) {
        currentSort = typeSort
        
        // Если выбрана сортировка "По умолчанию" и текущий фильтр "Все", загружаем как при первой загрузке
        if typeSort == .defaultSort && currentFilter == .all {
            loadLocalData { _ in
                // Данные уже загружены и отображены
            }
        } else {
            applyFiltersAndSort()
        }
    }
}
// MARK: - Creating Sections
private extension MainInteractor {
    func createCardSection(task: UserTask) -> MainModel.Response.MainSection {
        let items: [MainModel.Response.Item] = [
            .taskCard(task: task,
                      goToDetailTask: { [weak self] in
                          self?.openDetailTask(with: task)
                      },
                      deleteTask: { [weak self] in
                          self?.deleteTask(task)
                      },
                      toShareTask: { [weak self] in
                          self?.toShareTask(task)
                      },
                      toggleIsDone: { [weak self] in
                          self?.toggleCheckmark(task)
                      }
                     )
        ]
        
        return MainModel.Response.MainSection(section: .title(title: MainTitleSection.taskCard.rawValue), items: items)
    }
}

// MARK: - private methods
private extension MainInteractor {
    func toggleCheckmark(_ task: UserTask) {
        taskManager.toggleTaskCompletion(task) { [weak self] success in
            if success {
                // Обновляем только конкретную ячейку с анимацией
                DispatchQueue.main.async {
                    self?.updateTaskCell(task: task, animated: true)
                }
            } else {
                print("\(#file.components(separatedBy: "/").last ?? "") \(#function) \(#line)\nERROR - Failed to toggle task completion \n")
            }
        }
    }
    
    func toShareTask(_ task: UserTask) {
        // Создаем текст для шаринга
        let shareText = """
        Задача: \(task.displayTitle)
        
        \(task.displayDescription)
        
        Статус: \(task.statusText)
        Дата создания: \(task.formattedCreationDate)
        """
        presenter.checkToShareView(id: Int(task.serverID), shareText: shareText)
    }
    
    func deleteTask(_ task: UserTask) {
        taskManager.deleteTask(task) { [weak self] success in
            if success {
                // Обновляем UI после успешного удаления
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self?.refreshData()
                }
            } else {
                print("\(#file.components(separatedBy: "/").last ?? "") \(#function) \(#line)\nERROR - Failed to delete task \n")
            }
        }
    }
    
    private func updateTaskCell(task: UserTask, animated: Bool) {
        presenter.updateTaskCell(task: task, animated: animated)
    }
    
    private func refreshData() {
        // Обновляем данные после изменений
        taskManager.getAllTasks { [weak self] tasks in
            guard let self = self else { return }
            
            self.tasks = tasks
            self.originalTasks = tasks // Сохраняем оригинальные задачи
            self.sections.removeAll()
            
            for task in tasks {
                self.sections.append(self.createCardSection(task: task))
            }
            
            DispatchQueue.main.async {
                self.presenter.publish(data: MainModel.Response(data: self.sections), tasksCont: tasks.count)
            }
        }
    }
    
    // MARK: - Filter and Sort Methods
    
    private func applyFiltersAndSort() {
        // Если выбраны фильтр "Все" и сортировка "По умолчанию", загружаем данные как при первой загрузке
        if currentFilter == .all && currentSort == .defaultSort {
            loadLocalData { _ in
                // Данные уже загружены и отображены в loadLocalData
            }
            return
        }
        
        guard !originalTasks.isEmpty else {
            // Если оригинальные задачи пусты, загружаем их
            taskManager.getAllTasks { [weak self] tasks in
                guard let self = self else { return }
                self.originalTasks = tasks
                self.applyFiltersAndSortToTasks(tasks)
            }
            return
        }
        
        applyFiltersAndSortToTasks(originalTasks)
    }
    
    private func applyFiltersAndSortToTasks(_ tasks: [UserTask]) {
        // Применяем фильтр
        let filteredTasks = filterTasks(tasks)
        
        // Применяем сортировку
        let sortedTasks = sortTasks(filteredTasks)
        
        // Обновляем UI
        self.tasks = sortedTasks
        self.sections.removeAll()
        
        for task in sortedTasks {
            self.sections.append(self.createCardSection(task: task))
        }
        
        DispatchQueue.main.async {
            self.presenter.publish(data: MainModel.Response(data: self.sections), tasksCont: sortedTasks.count)
        }
    }
    
    private func filterTasks(_ tasks: [UserTask]) -> [UserTask] {
        switch currentFilter {
            case .all:
                // Возвращаем все задачи без фильтрации (как при первой загрузке)
                return tasks
            case .completed:
                return tasks.filter { $0.isCompleted }
            case .notCompleted:
                return tasks.filter { !$0.isCompleted }
        }
    }
    
    private func sortTasks(_ tasks: [UserTask]) -> [UserTask] {
        switch currentSort {
            case .defaultSort:
                // По умолчанию: сортировка как при первой загрузке (только по дате создания, новые сначала)
                return tasks.sorted { task1, task2 in
                    let date1 = task1.creationDate ?? Date.distantPast
                    let date2 = task2.creationDate ?? Date.distantPast
                    return date1 > date2
                }
                
            case .completed:
                // Сначала выполненные, затем по дате создания (новые сначала)
                return tasks.sorted { task1, task2 in
                    if task1.isCompleted != task2.isCompleted {
                        return task1.isCompleted // Выполненные сначала
                    }
                    // Если статус одинаковый, сортируем по дате создания (новые сначала)
                    let date1 = task1.creationDate ?? Date.distantPast
                    let date2 = task2.creationDate ?? Date.distantPast
                    return date1 > date2
                }
                
            case .noCompleted:
                // Сначала не выполненные, затем по дате создания (новые сначала)
                return tasks.sorted { task1, task2 in
                    if task1.isCompleted != task2.isCompleted {
                        return !task1.isCompleted // Не выполненные сначала
                    }
                    // Если статус одинаковый, сортируем по дате создания (новые сначала)
                    let date1 = task1.creationDate ?? Date.distantPast
                    let date2 = task2.creationDate ?? Date.distantPast
                    return date1 > date2
                }
        }
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
