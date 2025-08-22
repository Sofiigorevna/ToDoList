//
//  MainInteractorTests.swift
//  ToDoListTests
//
//  Created by sofiigorevna on 21.08.2025.
//

import XCTest
import CoreData
@testable import ToDoList

final class MainInteractorTests: XCTestCase {
    
    var interactor: MainInteractor!
    var mockRouter: MockMainRouter!
    var mockPresenter: MockMainPresenter!
    var mockTaskManager: MockTaskManager!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockRouter = MockMainRouter()
        mockPresenter = MockMainPresenter()
        mockTaskManager = MockTaskManager()
        mockNetworkManager = MockNetworkManager()
        
        interactor = MainInteractor(
            router: mockRouter,
            presenter: mockPresenter
        )
    }
    
    override func tearDownWithError() throws {
        interactor = nil
        mockRouter = nil
        mockPresenter = nil
        mockTaskManager = nil
        mockNetworkManager = nil
        try super.tearDownWithError()
    }
    
    // MARK: - LoadDataWithBackgroundSync Tests
    
    func testLoadDataWithBackgroundSync() {
        // Given
        let expectation = XCTestExpectation(description: "Load data with background sync")
        mockPresenter.publishCallback = { _, _ in
            expectation.fulfill()
        }
        
        // When
        interactor.loadDataWithBackgroundSync()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(mockPresenter.publishCalled)
    }
    
    // MARK: - Search Tests
    
    func testSearchTasksWithValidQuery() {
        // Given
        let query = "test"
        let expectation = XCTestExpectation(description: "Search tasks")
        mockPresenter.publishCallback = { _, _ in
            expectation.fulfill()
        }
        
        // When
        interactor.searchTasks(with: query) { tasksCount in
            // completion вызывается после обновления данных
        }
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(mockPresenter.publishCalled)
    }
    
    func testSearchTasksWithEmptyQuery() {
        // Given
        let query = ""
        let expectation = XCTestExpectation(description: "Search tasks with empty query")
        mockPresenter.publishCallback = { _, _ in
            expectation.fulfill()
        }
        
        // When
        interactor.searchTasks(with: query) { tasksCount in
            // completion вызывается после обновления данных
        }
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(mockPresenter.publishCalled)
    }
    
    func testSearchLocalTasksWithValidQuery() {
        // Given
        let query = "local test"
        let expectation = XCTestExpectation(description: "Search local tasks")
        mockPresenter.publishCallback = { _, _ in
            expectation.fulfill()
        }
        
        // When
        interactor.searchLocalTasks(with: query) { tasksCount in
            // completion вызывается после обновления данных
        }
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(mockPresenter.publishCalled)
    }
    
    // MARK: - ClearSearch Tests
    
    func testClearSearch() {
        // Given
        let expectation = XCTestExpectation(description: "Clear search")
        mockPresenter.updateDataSilentlyCallback = { _, _ in
            expectation.fulfill()
        }
        
        // When
        interactor.clearSearch { tasksCount in
            // completion может не вызываться, так как clearSearch вызывает loadDataWithBackgroundSync
            // который использует updateDataSilently
        }
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(mockPresenter.updateDataSilentlyCalled)
    }
    
    // MARK: - Navigation Tests
    
    func testOpenDetailTaskWithExistingTask() {
        // Given
        let testTask = createTestTask()
        
        // When
        interactor.openDetailTask(with: testTask)
        
        // Then
        XCTAssertTrue(mockRouter.openDetailTaskCalled)
        XCTAssertEqual(mockRouter.lastTaskID, Int(testTask.serverID))
    }
    
    func testOpenDetailTaskWithLocalTask() {
        // Given
        let testTask = createTestTask()
        testTask.serverID = 0 // Локальная задача
        
        // When
        interactor.openDetailTask(with: testTask)
        
        // Then
        XCTAssertTrue(mockRouter.openDetailTaskCalled)
        XCTAssertNil(mockRouter.lastTaskID) // Для локальных задач передается nil
    }
    
    func testCreateNewTask() {
        // When
        interactor.createNewTask()
        
        // Then
        XCTAssertTrue(mockRouter.openDetailTaskCalled)
        XCTAssertNil(mockRouter.lastTaskID) // Для новой задачи передается nil
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
}

// MARK: - Mock Classes

class MockMainRouter: IMainRouter {
    var openDetailTaskCalled = false
    var lastTaskID: Int?
    
    func openDetailTask(with id: Int?) {
        openDetailTaskCalled = true
        lastTaskID = id
    }
}

class MockMainPresenter: IMainPresenter {
    var publishCalled = false
    var updateDataSilentlyCalled = false
    var updateTaskCellCalled = false
    var checkToShareViewCalled = false
    var publishCallback: ((MainModel.Response, Int) -> Void)?
    var updateDataSilentlyCallback: ((MainModel.Response, Int) -> Void)?
    
    func publish(data: MainModel.Response, tasksCont: Int) {
        publishCalled = true
        publishCallback?(data, tasksCont)
    }
    
    func updateDataSilently(data: MainModel.Response, tasksCont: Int) {
        updateDataSilentlyCalled = true
        updateDataSilentlyCallback?(data, tasksCont)
    }
    
    func updateTaskCell(task: UserTask, animated: Bool) {
        updateTaskCellCalled = true
    }
    
    func checkToShareView(id: Int, shareText: String) {
        checkToShareViewCalled = true
    }
}

class MockNetworkManager {
    var fetchTodosCalled = false
    var mockTodos: [Todo] = []
    
    func fetchTodos(completion: @escaping ([Todo]) -> Void) {
        fetchTodosCalled = true
        completion(mockTodos)
    }
}
