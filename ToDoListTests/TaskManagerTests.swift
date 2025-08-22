//
//  TaskManagerTests.swift
//  ToDoListTests
//
//  Created by sofiigorevna on 21.08.2025.
//

import XCTest
import CoreData
@testable import ToDoList

final class TaskManagerTests: XCTestCase {
    
    var taskManager: TaskManager!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockCoreDataManager = MockCoreDataManager()
        taskManager = TaskManager()
        
        // В реальном проекте нужно использовать dependency injection
        // Здесь мы просто тестируем публичные методы TaskManager
    }
    
    override func tearDownWithError() throws {
        taskManager = nil
        mockCoreDataManager = nil
        try super.tearDownWithError()
    }
    
    // MARK: - AddTask Tests
    
    func testAddTaskWithValidData() {
        // Given
        let title = "Test Task"
        let description = "Test Description"
        let expectation = XCTestExpectation(description: "Add task")
        
        // When
        taskManager.addTask(title: title, description: description) { success in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddTaskWithEmptyTitle() {
        // Given
        let title = ""
        let description = "Test Description"
        let expectation = XCTestExpectation(description: "Add task with empty title")
        
        // When
        taskManager.addTask(title: title, description: description) { success in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddTaskWithWhitespaceOnlyTitle() {
        // Given
        let title = "   "
        let description = "Test Description"
        let expectation = XCTestExpectation(description: "Add task with whitespace title")
        
        // When
        taskManager.addTask(title: title, description: description) { success in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddTaskWithNilDescription() {
        // Given
        let title = "Test Task"
        let description: String? = nil
        let expectation = XCTestExpectation(description: "Add task with nil description")
        
        // When
        taskManager.addTask(title: title, description: description) { success in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - UpdateTask Tests
    
    func testUpdateTaskWithValidData() {
        // Given
        let task = createTestTask()
        let newTitle = "Updated Title"
        let newDescription = "Updated Description"
        let expectation = XCTestExpectation(description: "Update task")
        
        // When
        taskManager.updateTask(task, title: newTitle, description: newDescription) { success in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateTaskWithEmptyTitle() {
        // Given
        let task = createTestTask()
        let newTitle = ""
        let newDescription = "Updated Description"
        let expectation = XCTestExpectation(description: "Update task with empty title")
        
        // When
        taskManager.updateTask(task, title: newTitle, description: newDescription) { success in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateTaskWithNilValues() {
        // Given
        let task = createTestTask()
        let expectation = XCTestExpectation(description: "Update task with nil values")
        
        // When
        taskManager.updateTask(task, title: nil, description: nil) { success in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - DeleteTask Tests
    
    func testDeleteTask() {
        // Given
        let task = createTestTask()
        let expectation = XCTestExpectation(description: "Delete task")
        
        // When
        taskManager.deleteTask(task) { success in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - ToggleTaskCompletion Tests
    
    func testToggleTaskCompletion() {
        // Given
        let task = createTestTask()
        let expectation = XCTestExpectation(description: "Toggle task completion")
        
        // When
        taskManager.toggleTaskCompletion(task) { success in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - GetAllTasks Tests
    
    func testGetAllTasks() {
        // Given
        let expectation = XCTestExpectation(description: "Get all tasks")
        
        // When
        taskManager.getAllTasks { tasks in
            // Then
            XCTAssertNotNil(tasks)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - GetCompletedTasks Tests
    
    func testGetCompletedTasks() {
        // Given
        let expectation = XCTestExpectation(description: "Get completed tasks")
        
        // When
        taskManager.getCompletedTasks { tasks in
            // Then
            XCTAssertNotNil(tasks)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - GetIncompleteTasks Tests
    
    func testGetIncompleteTasks() {
        // Given
        let expectation = XCTestExpectation(description: "Get incomplete tasks")
        
        // When
        taskManager.getIncompleteTasks { tasks in
            // Then
            XCTAssertNotNil(tasks)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - SearchTasks Tests
    
    func testSearchTasksWithValidQuery() {
        // Given
        let query = "test"
        let expectation = XCTestExpectation(description: "Search tasks")
        
        // When
        taskManager.searchTasks(with: query) { tasks in
            // Then
            XCTAssertNotNil(tasks)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchTasksWithEmptyQuery() {
        // Given
        let query = ""
        let expectation = XCTestExpectation(description: "Search tasks with empty query")
        
        // When
        taskManager.searchTasks(with: query) { tasks in
            // Then
            XCTAssertNotNil(tasks)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - SaveChanges Tests
    
    func testSaveChanges() {
        // Given
        let expectation = XCTestExpectation(description: "Save changes")
        
        // When
        taskManager.saveChanges { success in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - ClearAllTasks Tests
    
    func testClearAllTasks() {
        // Given
        let expectation = XCTestExpectation(description: "Clear all tasks")
        
        // When
        taskManager.clearAllTasks { success in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - SaveTodosFromServer Tests
    
    func testSaveTodosFromServer() {
        // Given
        let todos = createTestTodos()
        let expectation = XCTestExpectation(description: "Save todos from server")
        
        // When
        taskManager.saveTodosFromServer(todos) { userTasks in
            // Then
            XCTAssertNotNil(userTasks)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Helper Methods
    
    private func createTestTask() -> UserTask {
        let context = CoreDataManager.shared.backgroundContext
        let task = UserTask(context: context)
        task.id = UUID()
        task.title = "Test Task"
        task.taskDescription = "Test Description"
        task.creationDate = Date()
        task.isCompleted = false
        task.serverID = 123
        return task
    }
    
    private func createTestTodos() -> [Todo] {
        let todo1 = Todo(
            id: 1,
            todo: "Todo 1",
            completed: false,
            userId: 1
        )
        
        let todo2 = Todo(
            id: 2,
            todo: "Todo 2",
            completed: true,
            userId: 1
        )
        
        return [todo1, todo2]
    }
}

// MARK: - Mock Classes

class MockCoreDataManager: CoreDataManagerType {
    var createTaskCalled = false
    var fetchAllTasksCalled = false
    var updateTaskCalled = false
    var deleteTaskCalled = false
    var toggleTaskCompletionCalled = false
    var saveContextCalled = false
    
    func createTask(title: String, description: String?, completion: @escaping (UserTask?) -> Void) {
        createTaskCalled = true
        let context = CoreDataManager.shared.backgroundContext
        let task = UserTask(context: context)
        task.id = UUID()
        task.title = title
        task.taskDescription = description
        task.creationDate = Date()
        task.isCompleted = false
        completion(task)
    }
    
    func fetchAllTasks(sortedBy sortDescriptors: [NSSortDescriptor]?, completion: @escaping ([UserTask]) -> Void) {
        fetchAllTasksCalled = true
        completion([])
    }
    
    func fetchCompletedTasks(completion: @escaping ([UserTask]) -> Void) {
        completion([])
    }
    
    func fetchIncompleteTasks(completion: @escaping ([UserTask]) -> Void) {
        completion([])
    }
    
    func updateTask(_ task: UserTask, title: String?, description: String?, isCompleted: Bool?, completion: @escaping (Bool) -> Void) {
        updateTaskCalled = true
        completion(true)
    }
    
    func deleteTask(_ task: UserTask, completion: @escaping (Bool) -> Void) {
        deleteTaskCalled = true
        completion(true)
    }
    
    func toggleTaskCompletion(_ task: UserTask, completion: @escaping (Bool) -> Void) {
        toggleTaskCompletionCalled = true
        completion(true)
    }
    
    func deleteAllTasks(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    func saveContext(completion: @escaping (Bool) -> Void) {
        saveContextCalled = true
        completion(true)
    }
    
    func saveBackgroundContext(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    func rollbackContext() {
        // Mock implementation
    }
    
    var backgroundContext: NSManagedObjectContext {
        return CoreDataManager.shared.backgroundContext
    }
}
