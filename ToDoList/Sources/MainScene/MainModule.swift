//
//  MainModule.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

enum MainModule {
    static func build() -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter()
        let router = MainRouter()

        let interactor = MainInteractor(
            router: router,
            presenter: presenter
        )
        
        view.interactor = interactor
        presenter.viewController = view
        router.transitionHandler = view
        
        return view
    }
}
