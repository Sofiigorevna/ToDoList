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
    var interactor: IDetailTaskInteractor?
    internal var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoader()
        interactor?.loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Сохраняем изменения при уходе с экрана
        interactor?.handleBackButton()
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

// MARK: - private methods
private extension DetailTaskViewController {
    func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = Colors.accent.color
    }
}
