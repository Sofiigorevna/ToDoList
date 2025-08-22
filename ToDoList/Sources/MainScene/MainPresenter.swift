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
        data: MainModel.Response
    )
    /// Обновляет данные без скрытия индикатора загрузки (для фоновой синхронизации)
    func updateDataSilently(
        data: MainModel.Response
    )
}

final class MainPresenter {
    weak var viewController: IMainView?
}
// MARK: - IMainPresenter
extension MainPresenter: IMainPresenter {
    func publish(
        data: MainModel.Response
    ) {
        let sectionViewModel = data.data.map(mapData)
        viewController?.update(sections: sectionViewModel)
    }
    
    func updateDataSilently(
        data: MainModel.Response
    ) {
        let sectionViewModel = data.data.map(mapData)
        viewController?.updateSilently(sections: sectionViewModel)
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
