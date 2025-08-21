//
//  ModuleTableViewController.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

protocol IModuleTableView: AnyObject {
    func update(sections: [SectionViewModel])
}

class ModuleTableViewController: UIViewController {
    public var sections = [SectionViewModel]()
    public var tableView = UITableView()
    private var keyboardWillShowObserver: NSObjectProtocol?
    private var keyboardWillHideObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotificationServices()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { }
    
    @objc private func keyboardWillShow(notification: Notification) {
        notification.userInfo
            .flatMap { $0[UIResponder.keyboardFrameEndUserInfoKey] }
            .flatMap { $0 as? NSValue }
            .map(\.cgRectValue.height)
            .map { UIEdgeInsets(top: 0, left: 0, bottom: $0, right: 0) }
            .map { insets in
                tableView.contentInset = insets
                tableView.scrollIndicatorInsets = insets
            }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }
    
    func cellViewModel(for indexPath: IndexPath) -> ICellViewModel? {
        guard indexPath.item < sections[indexPath.section].viewModels.count else { return nil }
        return sections[indexPath.section].viewModels[indexPath.item]
    }
    
    deinit {
        if let observer = keyboardWillShowObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = keyboardWillHideObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

private extension ModuleTableViewController {
    func setupNotificationServices() {
        keyboardWillShowObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main,
            using: keyboardWillShow
        )

        keyboardWillHideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main,
            using: keyboardWillHide
        )
    }
    
    func setupTableView() {
        tableView.backgroundColor = Colors.background.color
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none

        tableView.registeringCellsInTable(
            TaskCardCell.self,
            TextViewCell.self,
            DateCell.self
        )
        view.subviewsOnView(tableView)
        tableView.fullScreen()
    }
}

extension ModuleTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {  }
}
