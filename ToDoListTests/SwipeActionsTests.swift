//
//  SwipeActionsTests.swift
//  ToDoListTests
//
//  Created by Assistant on 29.08.2025.
//

import XCTest
import CoreData
@testable import ToDoList

class SwipeActionsTests: XCTestCase {
    
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
    
    private func createTestTask() -> UserTask {
        let task = UserTask(context: context)
        task.id = UUID()
        task.title = "Test Task"
        task.taskDescription = "Test Description"
        task.isCompleted = false
        task.creationDate = Date()
        return task
    }
    
    // MARK: - Swipe Actions Tests
    
    func testSwipeActionsConfiguration() {
        let task = createTestTask()
        let taskViewModel = TaskCardViewModel(
            task: task,
            goToDetailTask: {},
            deleteTask: {},
            toShareTask: {},
            toggleIsDone: {}
        )
        
        // Тестируем, что TaskCardViewModel правильно создается
        XCTAssertNotNil(taskViewModel)
        XCTAssertEqual(taskViewModel.task.title, "Test Task")
        XCTAssertFalse(taskViewModel.task.isCompleted)
    }
    
    func testSwipeActionsForCompletedTask() {
        let task = createTestTask()
        task.isCompleted = true
        
        // Тестируем, что для выполненной задачи правильно определяется статус
        XCTAssertTrue(task.isCompleted)
        XCTAssertEqual(task.statusText, "Выполнено")
    }
    
    func testSwipeActionsForIncompleteTask() {
        let task = createTestTask()
        task.isCompleted = false
        
        // Тестируем, что для не выполненной задачи правильно определяется статус
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.statusText, "Не выполнено")
    }
    
    func testTaskToggleCompletion() {
        let task = createTestTask()
        
        // Изначально задача не выполнена
        XCTAssertFalse(task.isCompleted)
        
        // Переключаем статус
        task.toggleCompletion()
        XCTAssertTrue(task.isCompleted)
        
        // Переключаем обратно
        task.toggleCompletion()
        XCTAssertFalse(task.isCompleted)
    }
    
    func testTaskMarkAsCompleted() {
        let task = createTestTask()
        
        // Изначально задача не выполнена
        XCTAssertFalse(task.isCompleted)
        
        // Отмечаем как выполненную
        task.markAsCompleted()
        XCTAssertTrue(task.isCompleted)
    }
    
    func testTaskMarkAsIncomplete() {
        let task = createTestTask()
        task.isCompleted = true
        
        // Изначально задача выполнена
        XCTAssertTrue(task.isCompleted)
        
        // Отмечаем как не выполненную
        task.markAsIncomplete()
        XCTAssertFalse(task.isCompleted)
    }
    
    func testTaskShareText() {
        let task = createTestTask()
        task.title = "Test Task"
        task.taskDescription = "Test Description"
        task.isCompleted = false
        task.creationDate = Date()
        
        // Проверяем, что текст для шаринга формируется корректно
        let shareText = """
        Задача: \(task.displayTitle)
        
        \(task.displayDescription)
        
        Статус: \(task.statusText)
        Дата создания: \(task.formattedCreationDate)
        """
        
        XCTAssertTrue(shareText.contains("Test Task"))
        XCTAssertTrue(shareText.contains("Test Description"))
        XCTAssertTrue(shareText.contains("Не выполнено"))
    }
    
    func testTaskValidation() {
        let task = createTestTask()
        
        // Задача с валидным названием
        task.title = "Valid Task"
        XCTAssertTrue(task.isValid)
        
        // Задача с пустым названием
        task.title = ""
        XCTAssertFalse(task.isValid)
        
        // Задача с названием только из пробелов
        task.title = "   "
        XCTAssertFalse(task.isValid)
        
        // Задача с nil названием
        task.title = nil
        XCTAssertFalse(task.isValid)
    }
    
    func testTaskSearchMatching() {
        let task = createTestTask()
        task.title = "Important Meeting"
        task.taskDescription = "Discuss project timeline"
        
        // Тестируем поиск по названию
        XCTAssertTrue(task.matches(searchText: "Important"))
        XCTAssertTrue(task.matches(searchText: "meeting"))
        XCTAssertTrue(task.matches(searchText: "IMPORTANT"))
        
        // Тестируем поиск по описанию
        XCTAssertTrue(task.matches(searchText: "project"))
        XCTAssertTrue(task.matches(searchText: "timeline"))
        
        // Тестируем поиск несуществующего текста
        XCTAssertFalse(task.matches(searchText: "nonexistent"))
    }
}
