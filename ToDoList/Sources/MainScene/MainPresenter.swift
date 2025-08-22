//
//  MainPresenter.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

protocol IMainPresenter {
    /// Обновляет UI-контроллер на основе данных.
    /// - Parameter data: Ответ модели.
    func publish(
        data: MainModel.Response,
        tasksCont: Int
    )
    /// Обновляет данные без скрытия индикатора загрузки (для фоновой синхронизации)
    func updateDataSilently(
        data: MainModel.Response,
        tasksCont: Int
    )
    /// Обновляет конкретную ячейку задачи
    func updateTaskCell(task: UserTask, animated: Bool)
    /// поделиться задачей
    func checkToShareView(id: Int, shareText: String)
}

final class MainPresenter {
    weak var viewController: IMainView?
}
// MARK: - IMainPresenter
extension MainPresenter: IMainPresenter {
    func publish(
        data: MainModel.Response,
        tasksCont: Int
    ) {
        let sectionViewModel = data.data.map(mapData)
        viewController?.update(sections: sectionViewModel, tasksCont: tasksCont)
    }
    
    func updateDataSilently(
        data: MainModel.Response,
        tasksCont: Int
    ) {
        let sectionViewModel = data.data.map(mapData)
        viewController?.updateSilently(sections: sectionViewModel, tasksCont: tasksCont)
    }
    
    func updateTaskCell(task: UserTask, animated: Bool) {
        viewController?.updateTaskCell(task: task, animated: animated)
    }
    
    func checkToShareView(id: Int, shareText: String) {
        viewController?.checkToShareView(id: id, shareText: shareText)
    }
}

private extension MainPresenter {
    func mapData(_ section: MainModel.Response.MainSection) -> SectionViewModel {
        SectionViewModel(title: section.section.text,
                         viewModels: section.items.map(mapData))
    }
    
    func mapData(item: MainModel.Response.Item) -> ICellViewModel {
        switch item {
            case .taskCard(
                let task,
                let goToDetailTask,
                let deleteTask,
                let toShareTask,
                let toggleIsDone
            ):
                return TaskCardViewModel(
                    task: task,
                    goToDetailTask: goToDetailTask,
                    deleteTask: deleteTask,
                    toShareTask: toShareTask,
                    toggleIsDone: toggleIsDone)
        }
    }
}
