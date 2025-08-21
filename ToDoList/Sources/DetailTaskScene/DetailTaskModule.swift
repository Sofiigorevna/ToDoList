//
//  DetailTaskModule.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

enum DetailTaskModule {
    static func build(with id: Int) -> UIViewController {
        let view = DetailTaskViewController()
        let presenter = DetailTaskPresenter()
        let router = DetailTaskRouter()

        let interactor = DetailTaskInteractor(
            router: router,
            presenter: presenter
        )
        
        view.interactor = interactor
        presenter.viewController = view
        router.transitionHandler = view
        
        return view
    }
}
