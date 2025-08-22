//
//  MainViewController.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

protocol IMainView: IModuleTableView {
    func update(sections: [SectionViewModel], tasksCont: Int)
    func updateSilently(sections: [SectionViewModel], tasksCont: Int)
    func updateTaskCell(task: UserTask, animated: Bool)
    func checkToShareView(id: Int, shareText: String)
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
        interactor?.loadDataWithBackgroundSync()
    }
    
    @objc private func addNote() {
        interactor?.createNewTask()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        updateTableViewBottomInset(to: toolbar.frame.height)
    }
}
// MARK: - IMainView
extension MainViewController: IMainView {
    func update(sections: [SectionViewModel]) {
        self.sections = sections
        tableView.reloadData()
        hideLoader()
    }
    
    func update(sections: [SectionViewModel], tasksCont: Int) {
        self.sections = sections
        self.taskCount = tasksCont
        tableView.reloadData()
        hideLoader()
    }
    
    func updateSilently(sections: [SectionViewModel], tasksCont: Int) {
        self.sections = sections
        self.taskCount = tasksCont
        tableView.reloadData()
    }
    
    func updateTaskCell(task: UserTask, animated: Bool) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.viewModels.firstIndex(where: {
                guard let taskViewModel = $0 as? TaskCardViewModel else { return false }
                return taskViewModel.task.id == task.id
            }) {
                // Обновляем модель в секции
                if let taskViewModel = section.viewModels[rowIndex] as? TaskCardViewModel {
                    // Создаем новый TaskCardViewModel с обновленной задачей
                    let updatedViewModel = TaskCardViewModel(
                        task: task,
                        goToDetailTask: taskViewModel.goToDetailTask,
                        deleteTask: taskViewModel.deleteTask,
                        toShareTask: taskViewModel.toShareTask,
                        toggleIsDone: taskViewModel.toggleIsDone
                    )
                    
                    // Обновляем модель в секции
                    sections[sectionIndex].viewModels[rowIndex] = updatedViewModel
                    
                    let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                    
                    DispatchQueue.main.async {
                        if let cell = self.tableView.cellForRow(at: indexPath) as? TaskCardCell {
                            cell.updateTaskAppearance(task: task, animated: animated)
                        } else {
                            debugPrint("ячейка не обработана")
                        }
                    }
                    return
                }
            }
        }
    }
    
    func checkToShareView(id: Int, shareText: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Если текст очищен (встроенной кнопкой X), сбрасываем поиск
        if searchText.isEmpty {
            clearSearch()
            return
        }
        
        // Поиск при вводе текста (с небольшой задержкой для оптимизации)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch), object: nil) // ОТМЕНЯЕМ предыдущий запрос
        perform(#selector(performSearch), with: searchText, afterDelay: 0.5)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Поиск при нажатии кнопки поиска
        searchBar.resignFirstResponder()
        performSearch(with: searchBar.text ?? "")
    }

    @objc private func performSearch(with searchText: String) {
        showLoader()
        interactor?.searchTasks(with: searchText) { [weak self] tasksCount in
            guard let self = self else { return }
            self.taskCount = tasksCount
            hideLoader()
        }
    }
    
    private func clearSearch() {
        showLoader()
        interactor?.clearSearch { [weak self] tasksCount in
            guard let self = self else { return }
            self.taskCount = tasksCount
            hideLoader()
        }
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
        searchController.searchBar.placeholder = "Поиск задач..."
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
            image: Images.squarePencil.image?
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
    
    func updateToolbarTaskCount(_ count: Int) {
        let taskWord = TasksWord.wordTask(forCount: count)
        let countText = "\(count) \(taskWord)"
        
        // Ищем countItem в toolbar
        if let items = toolbar.items,
           let countItemIndex = items.firstIndex(where: { $0.title?.contains("зада") == true }) {
            DispatchQueue.main.async {
                self.toolbar.items?[countItemIndex].title = countText
            }
        }
    }
    
    /// Обновляет нижний отступ таблицы для учёта видимости , чтобы`Toolbar` не перекрывала контент.
    /// - Parameter inset: Новый нижний отступ таблицы.
     func updateTableViewBottomInset(to inset: CGFloat) {
        // Обновляем нижний инсет таблицы
        var contentInset = tableView.contentInset
        contentInset.bottom = inset
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = contentInset
    }
}
