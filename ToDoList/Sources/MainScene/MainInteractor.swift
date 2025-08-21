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
    func loadData()
    /// переход на страницу
    ///
    /// - Parameter id: id task
    func openDetailTask(with id: Int)
    func handlingInteractionWithSearchField()
}

final class MainInteractor {
    
    private let router: IMainRouter
    private let presenter: IMainPresenter
  
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
        
    }
    
    func loadData() {
        sections.removeAll()
        sections.append(createCardSection())
        presenter.publish(data: MainModel.Response(data: self.sections))
    }
    
    func openDetailTask(with id: Int) {
    //    router.openArtPage(slug)
    }
}
// MARK: - Creating Sections
private extension MainInteractor {
    func createCardSection() -> MainModel.Response.MainSection {
        let items: [MainModel.Response.Item] = [
           
        ]
        return MainModel.Response.MainSection(section: .title(title: MainTitleSection.taskCard.rawValue), items: items)
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
        
        presenter.publish(data: MainModel.Response(data: self.sections))
    }
}

