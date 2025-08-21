////
////  ViewController.swift
////  ToDoList
////
////  Created by sofiigorevna on 21.08.2025.
////
//
//import UIKit
//
//class ViewController: UIViewController {
//    
//    // MARK: - Properties
//    
//    private let taskManager: TaskManagerType = TaskManager()
//    private var tasks: [UserTask] = []
//    private var filteredTasks: [UserTask] = []
//    private var isSearching = false
//    
//    // MARK: - UI Elements
//    
//    private lazy var tableView: UITableView = {
//        let table = UITableView()
//        table.translatesAutoresizingMaskIntoConstraints = false
//        table.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
//        table.delegate = self
//        table.dataSource = self
//        table.separatorStyle = .singleLine
//        table.backgroundColor = .systemBackground
//        return table
//    }()
//    
//    private lazy var searchController: UISearchController = {
//        let controller = UISearchController(searchResultsController: nil)
//        controller.searchResultsUpdater = self
//        controller.obscuresBackgroundDuringPresentation = false
//        controller.searchBar.placeholder = "Поиск задач..."
//        return controller
//    }()
//    
//    private lazy var addButton: UIBarButtonItem = {
//        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
//        return button
//    }()
//    
//    private lazy var filterButton: UIBarButtonItem = {
//        let button = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), 
//                                   style: .plain, 
//                                   target: self, 
//                                   action: #selector(filterButtonTapped))
//        return button
//    }()
//    
//    // MARK: - Lifecycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        loadTasks()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadTasks()
//    }
//    
//    // MARK: - Setup
//    
//    private func setupUI() {
//        view.backgroundColor = .systemBackground
//        title = "Список задач"
//        
//        // Navigation bar setup
//        navigationItem.rightBarButtonItems = [addButton, filterButton]
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
//        definesPresentationContext = true
//        
//        // Table view setup
//        view.addSubview(tableView)
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    // MARK: - Data Loading
//    
//    private func loadTasks() {
//        taskManager.getAllTasks { [weak self] tasks in
//            guard let self = self else { return }
//            self.tasks = tasks
//            self.filteredTasks = tasks
//            self.tableView.reloadData()
//            self.updateEmptyState()
//        }
//    }
//    
//    private func updateEmptyState() {
//        let isEmpty = filteredTasks.isEmpty
//        tableView.backgroundView = isEmpty ? createEmptyStateView() : nil
//    }
//    
//    private func createEmptyStateView() -> UIView {
//        let emptyView = UIView()
//        emptyView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(systemName: "checklist")
//        imageView.tintColor = .systemGray3
//        imageView.contentMode = .scaleAspectFit
//        
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = isSearching ? "Задачи не найдены" : "Нет задач"
//        label.textColor = .systemGray
//        label.textAlignment = .center
//        label.font = .systemFont(ofSize: 16)
//        
//        emptyView.addSubview(imageView)
//        emptyView.addSubview(label)
//        
//        NSLayoutConstraint.activate([
//            imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
//            imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20),
//            imageView.widthAnchor.constraint(equalToConstant: 60),
//            imageView.heightAnchor.constraint(equalToConstant: 60),
//            
//            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
//            label.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20),
//            label.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20)
//        ])
//        
//        return emptyView
//    }
//    
//    // MARK: - Actions
//    
//    @objc private func addButtonTapped() {
//        showAddTaskAlert()
//    }
//    
//    @objc private func filterButtonTapped() {
//        showFilterOptions()
//    }
//    
//    // MARK: - Task Management
//    
//    private func showAddTaskAlert() {
//        let alert = UIAlertController(title: "Новая задача", message: nil, preferredStyle: .alert)
//        
//        alert.addTextField { textField in
//            textField.placeholder = "Название задачи"
//        }
//        
//        alert.addTextField { textField in
//            textField.placeholder = "Описание (необязательно)"
//        }
//        
//        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
//            guard let self = self,
//                  let titleField = alert.textFields?.first,
//                  let title = titleField.text else { return }
//            
//            let description = alert.textFields?.last?.text
//            
//            self.taskManager.addTask(title: title, description: description) { success in
//                if success {
//                    self.loadTasks()
//                } else {
//                    self.showErrorAlert(message: "Не удалось добавить задачу. Проверьте название.")
//                }
//            }
//        }
//        
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
//        
//        alert.addAction(addAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true)
//    }
//    
//    private func showEditTaskAlert(for task: UserTask) {
//        let alert = UIAlertController(title: "Редактировать задачу", message: nil, preferredStyle: .alert)
//        
//        alert.addTextField { textField in
//            textField.text = task.title
//            textField.placeholder = "Название задачи"
//        }
//        
//        alert.addTextField { textField in
//            textField.text = task.taskDescription
//            textField.placeholder = "Описание (необязательно)"
//        }
//        
//        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
//            guard let self = self,
//                  let titleField = alert.textFields?.first,
//                  let title = titleField.text else { return }
//            
//            let description = alert.textFields?.last?.text
//            
//            self.taskManager.updateTask(task, title: title, description: description) { success in
//                if success {
//                    self.loadTasks()
//                } else {
//                    self.showErrorAlert(message: "Не удалось обновить задачу. Проверьте название.")
//                }
//            }
//        }
//        
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true)
//    }
//    
//    private func showDeleteConfirmation(for task: UserTask) {
//        let alert = UIAlertController(title: "Удалить задачу?", 
//                                    message: "Это действие нельзя отменить.", 
//                                    preferredStyle: .alert)
//        
//        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
//            self?.taskManager.deleteTask(task) { success in
//                if success {
//                    self?.loadTasks()
//                } else {
//                    self?.showErrorAlert(message: "Не удалось удалить задачу.")
//                }
//            }
//        }
//        
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
//        
//        alert.addAction(deleteAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true)
//    }
//    
//    private func showFilterOptions() {
//        let alert = UIAlertController(title: "Фильтр задач", message: nil, preferredStyle: .actionSheet)
//        
//        let allTasksAction = UIAlertAction(title: "Все задачи", style: .default) { [weak self] _ in
//            self?.filterTasks(by: .all)
//        }
//        
//        let incompleteTasksAction = UIAlertAction(title: "Не выполненные", style: .default) { [weak self] _ in
//            self?.filterTasks(by: .incomplete)
//        }
//        
//        let completedTasksAction = UIAlertAction(title: "Выполненные", style: .default) { [weak self] _ in
//            self?.filterTasks(by: .completed)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
//        
//        alert.addAction(allTasksAction)
//        alert.addAction(incompleteTasksAction)
//        alert.addAction(completedTasksAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true)
//    }
//    
//    private func filterTasks(by filter: TaskFilter) {
//        switch filter {
//        case .all:
//            filteredTasks = tasks
//            tableView.reloadData()
//            updateEmptyState()
//        case .completed:
//            taskManager.getCompletedTasks { [weak self] tasks in
//                guard let self = self else { return }
//                self.filteredTasks = tasks
//                self.tableView.reloadData()
//                self.updateEmptyState()
//            }
//        case .incomplete:
//            taskManager.getIncompleteTasks { [weak self] tasks in
//                guard let self = self else { return }
//                self.filteredTasks = tasks
//                self.tableView.reloadData()
//                self.updateEmptyState()
//            }
//        }
//    }
//    
//    private func showErrorAlert(message: String) {
//        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default)
//        alert.addAction(okAction)
//        present(alert, animated: true)
//    }
//}
//
//// MARK: - UITableViewDataSource
//
//extension ViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredTasks.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
//        let task = filteredTasks[indexPath.row]
//        cell.configure(with: task)
//        return cell
//    }
//}
//
//// MARK: - UITableViewDelegate
//
//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let task = filteredTasks[indexPath.row]
//        taskManager.toggleTaskCompletion(task) { success in
//            if success {
//                self.loadTasks()
//            } else {
//                self.showErrorAlert(message: "Не удалось изменить статус задачи.")
//            }
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let task = filteredTasks[indexPath.row]
//        
//        let editAction = UIContextualAction(style: .normal, title: "Изменить") { [weak self] _, _, completion in
//            self?.showEditTaskAlert(for: task)
//            completion(true)
//        }
//        editAction.backgroundColor = .systemBlue
//        
//        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
//            self?.showDeleteConfirmation(for: task)
//            completion(true)
//        }
//        
//        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
//    }
//}
//
//// MARK: - UISearchResultsUpdating
//
//extension ViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let searchText = searchController.searchBar.text else { return }
//        
//        isSearching = !searchText.isEmpty
//        taskManager.searchTasks(with: searchText) { [weak self] tasks in
//            guard let self = self else { return }
//            self.filteredTasks = tasks
//            self.tableView.reloadData()
//            self.updateEmptyState()
//        }
//    }
//}
//
//// MARK: - TaskFilter
//
//enum TaskFilter {
//    case all
//    case completed
//    case incomplete
//}
