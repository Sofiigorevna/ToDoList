//
//  MainRouter.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

protocol IMainRouter {
    func openDetailTask(with id: Int)
}

final class MainRouter {
    weak var transitionHandler: UIViewController?
}
// MARK: - IMainRouter
extension MainRouter: IMainRouter {
    func openDetailTask(with id: Int) {
        let vc = DetailTaskModule.build(with: id)
        if let navVC = transitionHandler?.navigationController {
            navVC.pushViewController(vc, animated: true)
        }
    }
}
