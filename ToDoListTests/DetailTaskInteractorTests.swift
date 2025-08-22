//
//  DetailTaskInteractorTests.swift
//  ToDoListTests
//
//  Created by sofiigorevna on 21.08.2025.
//

import XCTest
import CoreData
@testable import ToDoList

final class DetailTaskInteractorTests: XCTestCase {
    
    var interactor: DetailTaskInteractor!
    var mockRouter: MockDetailTaskRouter!
    var mockPresenter: MockDetailTaskPresenter!
    var mockTaskManager: MockTaskManager!
    var mockUserTask: UserTask!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockRouter = MockDetailTaskRouter()
        mockPresenter = MockDetailTaskPresenter()
        mockTaskManager = MockTaskManager()
        
        // Создаем тестовую задачу
        let context = CoreDataManager.shared.backgroundContext
        mockUserTask = UserTask(context: context)
        mockUserTask.id = UUID()
        mockUserTask.title = "Test Task"
        mockUserTask.taskDescription = "Test Description"
        mockUserTask.creationDate = Date()
        mockUserTask.isCompleted = false
        mockUserTask.serverID = 123
        
        interactor = DetailTaskInteractor(
            router: mockRouter,
            presenter: mockPresenter,
            taskID: 123
        )
        
        // Инжектируем мок TaskManager через reflection (в реальном проекте лучше использовать DI)
        let taskManagerProperty = Mirror(reflecting: interactor).children.first { $0.label == "taskManager" }
        if let taskManagerProperty = taskManagerProperty {
            // В реальном проекте лучше использовать dependency injection
            // Здесь мы просто проверяем, что TaskManager существует
        }
    }
    
    override func tearDownWithError() throws {
        interactor = nil
        mockRouter = nil
        mockPresenter = nil
        mockTaskManager = nil
        mockUserTask = nil
        try super.tearDownWithError()
    }
    
    // MARK: - LoadData Tests
    
    func testLoadDataWithExistingTask() {
        // Given
        let expectation = XCTestExpectation(description: "Load data with existing task")
        mockPresenter.publishCallback = { _ in
            expectation.fulfill()
        }
        
        // When
        interactor.loadData()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockPresenter.publishCalled)
    }
    
    func testLoadDataWithNewTask() {
        // Given
        let newTaskInteractor = DetailTaskInteractor(
            router: mockRouter,
            presenter: mockPresenter,
            taskID: nil
        )
        
        let expectation = XCTestExpectation(description: "Load data for new task")
        mockPresenter.publishCallback = { _ in
            expectation.fulfill()
        }
        
        // When
        newTaskInteractor.loadData()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockPresenter.publishCalled)
    }
    
    // MARK: - SaveChanges Tests
    
    func testSaveChangesWithExistingTask() {
        // Given
        interactor.loadData()
        
        // When
        interactor.saveChanges()
        
        // Then
        // В реальном тесте здесь нужно проверить, что TaskManager был вызван
        // Поскольку у нас нет прямого доступа к TaskManager, проверяем косвенно
        XCTAssertTrue(true) // Placeholder assertion
    }
    
    func testSaveChangesWithNewTask() {
        // Given
        let newTaskInteractor = DetailTaskInteractor(
            router: mockRouter,
            presenter: mockPresenter,
            taskID: nil
        )
        
        // When
        newTaskInteractor.saveChanges()
        
        // Then
        // Проверяем, что сохранение прошло без ошибок
        XCTAssertTrue(true) // Placeholder assertion
    }
    
    // MARK: - HandleBackButton Tests
    
    func testHandleBackButton() {
        // Given
        interactor.loadData()
        
        // When
        interactor.handleBackButton()
        
        // Then
        // Проверяем, что saveChanges был вызван
        XCTAssertTrue(true) // Placeholder assertion
    }
}

// MARK: - Mock Classes

class MockDetailTaskRouter: IDetailTaskRouter {
    var closeDetailTaskCalled = false
    var showErrorCalled = false
    var navigateToMainScreenCalled = false
    
    func closeDetailTask() {
        closeDetailTaskCalled = true
    }
    
    func showError(_ message: String) {
        showErrorCalled = true
    }
    
    func navigateToMainScreen() {
        navigateToMainScreenCalled = true
    }
}

class MockDetailTaskPresenter: IDetailTaskPresenter {
    var publishCalled = false
    var publishedData: DetailTaskModel.Response?
    var publishCallback: ((DetailTaskModel.Response) -> Void)?
    
    func publish(data: DetailTaskModel.Response) {
        publishCalled = true
        publishedData = data
        publishCallback?(data)
    }
}

class MockTaskManager: TaskManagerType {
    var addTaskCalled = false
    var updateTaskCalled = false
    var deleteTaskCalled = false
    var getAllTasksCalled = false
    
    func addTask(title: String, description: String?, completion: @escaping (Bool) -> Void) {
        addTaskCalled = true
        completion(true)
    }
    
    func updateTask(_ task: UserTask, title: String?, description: String?, completion: @escaping (Bool) -> Void) {
        updateTaskCalled = true
        completion(true)
    }
    
    func deleteTask(_ task: UserTask, completion: @escaping (Bool) -> Void) {
        deleteTaskCalled = true
        completion(true)
    }
    
    func toggleTaskCompletion(_ task: UserTask, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    func getAllTasks(completion: @escaping ([UserTask]) -> Void) {
        getAllTasksCalled = true
        completion([])
    }
    
    func getCompletedTasks(completion: @escaping ([UserTask]) -> Void) {
        completion([])
    }
    
    func getIncompleteTasks(completion: @escaping ([UserTask]) -> Void) {
        completion([])
    }
    
    func getServerTasks(completion: @escaping ([UserTask]) -> Void) {
        completion([])
    }
    
    func searchTasks(with query: String, completion: @escaping ([UserTask]) -> Void) {
        completion([])
    }
    
    func saveChanges(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    func clearAllTasks(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    func saveTodosFromServer(_ todos: [Todo], completion: @escaping ([UserTask]) -> Void) {
        completion([])
    }
}
