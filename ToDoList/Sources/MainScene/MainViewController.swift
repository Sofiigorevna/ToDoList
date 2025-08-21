//
//  MainViewController.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

protocol IMainView: IModuleTableView {
    func update(sections: [SectionViewModel])
}

final class MainViewController: ModuleTableViewController, IActivityIndicatorView {
    var interactor: IMainInteractor?
    
    private let toolbar = UIToolbar()
    internal var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var taskCount: Int = 0 {
        didSet {
            updateToolbarTaskCount(taskCount)
        }
    }
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        let searchBarScopeOsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty || searchBarScopeOsFiltering)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoader()
        interactor?.loadData()
        //  tasks =
    }
}
// MARK: - IMainView
extension MainViewController: IMainView {
    func update(sections: [SectionViewModel]) {
        self.sections = sections
        tableView.reloadData()
        hideLoader()
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        interactor?.handlingInteractionWithSearchField()
    }
}
// MARK: - private methods
private extension MainViewController {
    func setupView() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSearchController()
        self.definesPresentationContext = true
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        setupToolbar()
    }
    
    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.searchTextField.backgroundColor = Colors.secondaryBackground.color
    }
    
    func setupToolbar() {
        navigationController?.isToolbarHidden = false
        toolbar.tAMIC()
        view.addSubview(toolbar)
        
        NSLayoutConstraint.activate([
            toolbar.leftAnchor.constraint(equalTo: view.leftAnchor),
            toolbar.rightAnchor.constraint(equalTo: view.rightAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Формируем текст с правильным склонением
        let taskWord = TasksWord.wordTask(forCount: taskCount)
        let countText = "\(taskCount) \(taskWord)"
        
        let countItem = UIBarButtonItem(title: countText, style: .plain, target: nil, action: nil)
        countItem.isEnabled = false
        
        let flexibleLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexibleRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let addItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil")?
                .withConfiguration(
                    UIImage.SymbolConfiguration(
                        pointSize: 24,
                        weight: .medium,
                        scale: .default
                    )
                ),
            style: .plain,
            target: self,
            action: #selector(addNote)
        )
        
        addItem.tintColor = Colors.accent.color
        
        toolbar.items = [flexibleLeft, countItem, flexibleRight, addItem]
    }
    
    @objc private func addNote() {
        print("Новая заметка")
    }
    
    func updateToolbarTaskCount(_ count: Int) {
        let taskWord = TasksWord.wordTask(forCount: count)
        let countText = "\(count) \(taskWord)"
        
        // Ищем countItem в toolbar
        if let items = toolbar.items,
           let countItemIndex = items.firstIndex(where: { $0.title?.contains("зада") == true }) {
            
            toolbar.items?[countItemIndex].title = countText
        }
    }
}
