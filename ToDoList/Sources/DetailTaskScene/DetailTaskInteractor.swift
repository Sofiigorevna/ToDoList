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
  
    private var sections = [DetailTaskModel.Response.DetailTaskSection]()
    
    init(
        router: IDetailTaskRouter,
        presenter: IDetailTaskPresenter
    ) {
        self.router = router
        self.presenter = presenter
    }
}
// MARK: - IDetailTaskInteractor
extension DetailTaskInteractor: IDetailTaskInteractor {
    func loadData() {
        sections.removeAll()
        sections.append(createCardSection())
        presenter.publish(data: DetailTaskModel.Response(data: self.sections))
    }
}
// MARK: - Creating Sections
private extension DetailTaskInteractor {
    func createCardSection() -> DetailTaskModel.Response.DetailTaskSection {
        let items: [DetailTaskModel.Response.Item] = [
           
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

