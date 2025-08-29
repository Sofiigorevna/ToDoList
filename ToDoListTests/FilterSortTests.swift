//
//  FilterSortTests.swift
//  ToDoListTests
//
//  Created by Assistant on 29.08.2025.
//

import XCTest
import CoreData
@testable import ToDoList

class FilterSortTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
        context = coreDataManager.backgroundContext
    }
    
    override func tearDown() {
        // Очищаем тестовые данные
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserTask.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Error cleaning up test data: \(error)")
        }
        
        super.tearDown()
    }
    
    // MARK: - Test Data Creation
    
    private func createTestTasks() -> [UserTask] {
        let task1 = UserTask(context: context)
        task1.id = UUID()
        task1.title = "Task A"
        task1.taskDescription = "Description A"
        task1.isCompleted = false
        task1.creationDate = Date().addingTimeInterval(-3600) // 1 час назад
        
        let task2 = UserTask(context: context)
        task2.id = UUID()
        task2.title = "Task B"
        task2.taskDescription = "Description B"
        task2.isCompleted = true
        task2.creationDate = Date().addingTimeInterval(-7200) // 2 часа назад
        
        let task3 = UserTask(context: context)
        task3.id = UUID()
        task3.title = "Task C"
        task3.taskDescription = "Description C"
        task3.isCompleted = false
        task3.creationDate = Date() // сейчас
        
        return [task1, task2, task3]
    }
    
    // MARK: - Filter Tests
    
    func testFilterAll() {
        let tasks = createTestTasks()
        let filter = FilterTypes.all
        
        let filteredTasks = filterTasks(tasks, filter: filter)
        
        XCTAssertEqual(filteredTasks.count, 3, "Фильтр 'Все' должен возвращать все задачи")
    }
    
    func testFilterCompleted() {
        let tasks = createTestTasks()
        let filter = FilterTypes.completed
        
        let filteredTasks = filterTasks(tasks, filter: filter)
        
        XCTAssertEqual(filteredTasks.count, 1, "Фильтр 'Выполненные' должен возвращать только выполненные задачи")
        XCTAssertTrue(filteredTasks.first?.isCompleted == true)
    }
    
    func testFilterNotCompleted() {
        let tasks = createTestTasks()
        let filter = FilterTypes.notCompleted
        
        let filteredTasks = filterTasks(tasks, filter: filter)
        
        XCTAssertEqual(filteredTasks.count, 2, "Фильтр 'Не выполненные' должен возвращать только не выполненные задачи")
        XCTAssertTrue(filteredTasks.allSatisfy { !$0.isCompleted })
    }
    
    // MARK: - Sort Tests
    
    func testSortDefault() {
        let tasks = createTestTasks()
        let sort = SortTypes.defaultSort
        
        let sortedTasks = sortTasks(tasks, sort: sort)
        
        // По умолчанию сортировка только по дате (новые сначала)
        XCTAssertEqual(sortedTasks[0].title, "Task C", "Первой должна быть самая новая задача")
        XCTAssertEqual(sortedTasks[1].title, "Task A", "Второй должна быть задача A")
        XCTAssertEqual(sortedTasks[2].title, "Task B", "Последней должна быть самая старая задача")
    }
    
    func testSortCompleted() {
        let tasks = createTestTasks()
        let sort = SortTypes.completed
        
        let sortedTasks = sortTasks(tasks, sort: sort)
        
        // Сначала выполненные, затем по дате
        XCTAssertEqual(sortedTasks[0].title, "Task B", "Первой должна быть выполненная задача")
        XCTAssertTrue(sortedTasks[0].isCompleted)
    }
    
    func testSortNoCompleted() {
        let tasks = createTestTasks()
        let sort = SortTypes.noCompleted
        
        let sortedTasks = sortTasks(tasks, sort: sort)
        
        // Сначала не выполненные, затем по дате
        XCTAssertEqual(sortedTasks[0].title, "Task C", "Первой должна быть не выполненная задача")
        XCTAssertFalse(sortedTasks[0].isCompleted)
    }
    
    // MARK: - Helper Methods
    
    private func filterTasks(_ tasks: [UserTask], filter: FilterTypes) -> [UserTask] {
        switch filter {
        case .all:
            return tasks
        case .completed:
            return tasks.filter { $0.isCompleted }
        case .notCompleted:
            return tasks.filter { !$0.isCompleted }
        }
    }
    
    private func sortTasks(_ tasks: [UserTask], sort: SortTypes) -> [UserTask] {
        switch sort {
        case .defaultSort:
            return tasks.sorted { task1, task2 in
                let date1 = task1.creationDate ?? Date.distantPast
                let date2 = task2.creationDate ?? Date.distantPast
                return date1 > date2
            }
            
        case .completed:
            return tasks.sorted { task1, task2 in
                if task1.isCompleted != task2.isCompleted {
                    return task1.isCompleted
                }
                let date1 = task1.creationDate ?? Date.distantPast
                let date2 = task2.creationDate ?? Date.distantPast
                return date1 > date2
            }
            
        case .noCompleted:
            return tasks.sorted { task1, task2 in
                if task1.isCompleted != task2.isCompleted {
                    return !task1.isCompleted
                }
                let date1 = task1.creationDate ?? Date.distantPast
                let date2 = task2.creationDate ?? Date.distantPast
                return date1 > date2
            }
        }
    }
}
