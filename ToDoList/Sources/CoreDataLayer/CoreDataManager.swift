//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import CoreData

protocol CoreDataManagerType {
    // MARK: - Task Management
    func createTask(title: String, description: String?, completion: @escaping (UserTask?) -> Void)
    func fetchAllTasks(sortedBy sortDescriptors: [NSSortDescriptor]?, completion: @escaping ([UserTask]) -> Void)
    func fetchCompletedTasks(completion: @escaping ([UserTask]) -> Void)
    func fetchIncompleteTasks(completion: @escaping ([UserTask]) -> Void)
    func updateTask(_ task: UserTask, title: String?, description: String?, isCompleted: Bool?, completion: @escaping (Bool) -> Void)
    func deleteTask(_ task: UserTask, completion: @escaping (Bool) -> Void)
    func toggleTaskCompletion(_ task: UserTask, completion: @escaping (Bool) -> Void)
    func deleteAllTasks(completion: @escaping (Bool) -> Void)
    
    // MARK: - Context Management
    func saveContext(completion: @escaping (Bool) -> Void)
    func saveBackgroundContext(completion: @escaping (Bool) -> Void)
    func rollbackContext()
    
    // MARK: - Context Access
    var backgroundContext: NSManagedObjectContext { get }
}

final class CoreDataManager: CoreDataManagerType {
    
    // MARK: - Properties
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var context: NSManagedObjectContext = persistentContainer.viewContext
    
    // Background context for heavy operations
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Task Management
    
    func createTask(title: String, description: String? = nil, completion: @escaping (UserTask?) -> Void) {
        backgroundContext.perform {
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "UserTask", in: self.backgroundContext) else {
                DispatchQueue.main.async {
                    print("Failed to get entity description for UserTask")
                    completion(nil)
                }
                return
            }
            
            let newTask = UserTask(entity: entityDescription, insertInto: self.backgroundContext)
            newTask.id = UUID()
            newTask.title = title
            newTask.taskDescription = description
            newTask.creationDate = Date()
            newTask.isCompleted = false
            newTask.serverID = 0
            
            self.saveBackgroundContext { success in
                DispatchQueue.main.async {
                    completion(success ? newTask : nil)
                }
            }
        }
    }
    
    func fetchAllTasks(sortedBy sortDescriptors: [NSSortDescriptor]? = nil, completion: @escaping ([UserTask]) -> Void) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<UserTask> = UserTask.fetchRequest()
            
            if let sortDescriptors = sortDescriptors {
                fetchRequest.sortDescriptors = sortDescriptors
            } else {
                // Default sorting: incomplete tasks first, then by creation date (newest first)
                fetchRequest.sortDescriptors = [
                    NSSortDescriptor(key: "isCompleted", ascending: true),
                    NSSortDescriptor(key: "creationDate", ascending: false)
                ]
            }
            
            do {
                let tasks = try self.backgroundContext.fetch(fetchRequest)
                DispatchQueue.main.async {
                    completion(tasks)
                }
            } catch {
                print("Error fetching tasks: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func fetchCompletedTasks(completion: @escaping ([UserTask]) -> Void) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<UserTask> = UserTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isCompleted == YES")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            do {
                let tasks = try self.backgroundContext.fetch(fetchRequest)
                DispatchQueue.main.async {
                    completion(tasks)
                }
            } catch {
                print("Error fetching completed tasks: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func fetchIncompleteTasks(completion: @escaping ([UserTask]) -> Void) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<UserTask> = UserTask.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isCompleted == NO")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            do {
                let tasks = try self.backgroundContext.fetch(fetchRequest)
                DispatchQueue.main.async {
                    completion(tasks)
                }
            } catch {
                print("Error fetching incomplete tasks: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func updateTask(_ task: UserTask, title: String? = nil, description: String? = nil, isCompleted: Bool? = nil, completion: @escaping (Bool) -> Void) {
        backgroundContext.perform {
            // Get the task in background context
            let backgroundTask = self.backgroundContext.object(with: task.objectID) as! UserTask
            
            if let title = title {
                backgroundTask.title = title
            }
            if let description = description {
                backgroundTask.taskDescription = description
            }
            if let isCompleted = isCompleted {
                backgroundTask.isCompleted = isCompleted
            }
            
            self.saveBackgroundContext { success in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
    
    func toggleTaskCompletion(_ task: UserTask, completion: @escaping (Bool) -> Void) {
        backgroundContext.perform {
            let backgroundTask = self.backgroundContext.object(with: task.objectID) as! UserTask
            backgroundTask.isCompleted.toggle()
            
            self.saveBackgroundContext { success in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
    
    func deleteTask(_ task: UserTask, completion: @escaping (Bool) -> Void) {
        backgroundContext.perform {
            let backgroundTask = self.backgroundContext.object(with: task.objectID) as! UserTask
            self.backgroundContext.delete(backgroundTask)
            
            self.saveBackgroundContext { success in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
    
    func deleteAllTasks(completion: @escaping (Bool) -> Void) {
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserTask.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try self.backgroundContext.execute(deleteRequest)
                self.saveBackgroundContext { success in
                    DispatchQueue.main.async {
                        completion(success)
                    }
                }
            } catch {
                print("Error deleting all tasks: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Context Management
    
    func saveContext(completion: @escaping (Bool) -> Void) {
        backgroundContext.perform {
            self.saveBackgroundContext { success in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        }
    }
    
    func saveBackgroundContext(completion: @escaping (Bool) -> Void) {
        guard backgroundContext.hasChanges else {
            completion(true)
            return
        }
        
        do {
            try backgroundContext.save()
            completion(true)
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            completion(false)
        }
    }
    
    func rollbackContext() {
        backgroundContext.perform {
            self.backgroundContext.rollback()
        }
    }
    
    // MARK: - Legacy Methods (for backward compatibility)
    
    func saveTask(with title: String) {
        createTask(title: title) { _ in }
    }
    
    func fetchAllTasks() -> [UserTask]? {
        // This method is deprecated, use the async version instead
        return nil
    }
    
    func deleteTask(task: UserTask) {
        deleteTask(task) { _ in }
    }
    
    func updateTask(task: UserTask,
                    title: String?,
                    taskDescription: String?,
                    creationDate: Date?,
                    isCompleted: Bool?) {
        updateTask(task, title: title, description: taskDescription, isCompleted: isCompleted) { _ in }
    }
}
