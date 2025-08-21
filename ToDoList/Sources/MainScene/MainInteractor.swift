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
    /// Загрузить данные
    func loadData(completion: @escaping(_ tasksCont: Int) -> ())
    /// переход на страницу
    ///
    /// - Parameter id: id task
    func openDetailTask(with id: Int)
    func handlingInteractionWithSearchField()
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
    func handlingInteractionWithSearchField() {
        print("tapped SearchField")
    }
    
    func loadData(completion: @escaping(_ tasksCont: Int) -> ()) {
        sections.removeAll()
        taskManager.getAllTasks { [weak self] tasks in
            guard let self = self else { return }
            self.tasks = tasks
            for task in tasks {
                self.sections.append(self.createCardSection(task: task))
            }
            presenter.publish(data: MainModel.Response(data: self.sections))
            completion(tasks.count)
        }
    }
    
    func openDetailTask(with id: Int) {
        router.openDetailTask(with: id)
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
    func getTodosData(completion: @escaping([Todo]) -> ()) {
        dataSource.getTodosList { result in
            switch result {
                case .success(let success):
                    completion(success.todos ?? [])
                case .failure(let failure):
                    print("\(#file.components(separatedBy: "/").last ?? "") \(#function) \(#line)\nERROR - \(failure)\n")
            }
        }
    }
}
