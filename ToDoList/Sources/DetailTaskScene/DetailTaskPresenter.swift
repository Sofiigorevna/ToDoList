//
//  DetailTaskPresenter.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

protocol IDetailTaskPresenter {
    /// Обновляет UI-контроллер на основе данных.
    /// - Parameter data: Ответ модели.
    func publish(
        data: DetailTaskModel.Response
    )
}

final class DetailTaskPresenter {
    weak var viewController: IDetailTaskView?
}
// MARK: - IDetailTaskPresenter
extension DetailTaskPresenter: IDetailTaskPresenter {
    func publish(
        data: DetailTaskModel.Response
    ) {
        let sectionViewModel = data.data.map(mapData)
        viewController?.update(sections: sectionViewModel)
    }
}

private extension DetailTaskPresenter {
    func mapData(_ section: DetailTaskModel.Response.DetailTaskSection) -> SectionViewModel {
        SectionViewModel(title: section.section.text,
                         viewModels: section.items.map(mapData))
    }
    
    func mapData(item: DetailTaskModel.Response.Item) -> ICellViewModel {
        switch item {
            case .textView(
                let text,
                let placeholder,
                let fontSize,
                let textAction):
                return TextViewViewModel(
                    text: text,
                    placeholder: placeholder,
                    fontSize: fontSize,
                    textAction: textAction)
                
            case .date(let date):
                return DateViewModel(date: date)
        }
    }
}
