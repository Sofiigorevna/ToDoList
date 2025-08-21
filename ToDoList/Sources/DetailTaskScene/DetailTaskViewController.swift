//
//  DetailTaskViewController.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

protocol IDetailTaskView: IModuleTableView {
    func update(sections: [SectionViewModel])
}

final class DetailTaskViewController: ModuleTableViewController, IActivityIndicatorView {
    var interactor: IMainInteractor?
    internal var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoader()
        interactor?.loadData()
    }
}
// MARK: - IDetailTaskView
extension DetailTaskViewController: IDetailTaskView {
    func update(sections: [SectionViewModel]) {
        self.sections = sections
        tableView.reloadData()
        hideLoader()
    }
}
