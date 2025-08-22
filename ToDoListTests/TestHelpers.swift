//
//  TestHelpers.swift
//  ToDoListTests
//
//  Created by sofiigorevna on 21.08.2025.
//

import XCTest
import CoreData
@testable import ToDoList

// MARK: - Test Utilities

class TestUtilities {
    
    static func createMockUserTask(
        id: UUID = UUID(),
        title: String = "Test Task",
        description: String? = "Test Description",
        isCompleted: Bool = false,
        serverID: Int64 = 123,
        creationDate: Date = Date()
    ) -> UserTask {
        let context = CoreDataManager.shared.backgroundContext
        let task = UserTask(context: context)
        task.id = id
        task.title = title
        task.taskDescription = description
        task.isCompleted = isCompleted
        task.serverID = serverID
        task.creationDate = creationDate
        return task
    }
    
    static func createMockTodo(
        id: Int = 123,
        todo: String = "Test Todo",
        completed: Bool = false
    ) -> Todo {
        return Todo(
            id: id,
            todo: todo,
            completed: completed,
            userId: 1
        )
    }
    
    static func createMockMainModelResponse(with tasks: [UserTask] = []) -> MainModel.Response {
        let sections = tasks.map { task in
            MainModel.Response.MainSection(
                section: .title(title: MainTitleSection.taskCard.rawValue),
                items: [
                    .taskCard(
                        task: task,
                        goToDetailTask: {},
                        deleteTask: {},
                        toShareTask: {},
                        toggleIsDone: {}
                    )
                ]
            )
        }
        return MainModel.Response(data: sections)
    }
    
    static func createMockDetailTaskModelResponse(with task: UserTask? = nil) -> DetailTaskModel.Response {
        let titleSection = DetailTaskModel.Response.DetailTaskSection(
            section: .title(title: DetailTaskTitleSection.title.rawValue),
            items: [
                .textView(
                    text: task?.displayTitle ?? "",
                    placeholder: "Название задачи...",
                    fontSize: 30,
                    textAction: { _ in }
                )
            ]
        )
        
        let dateSection = DetailTaskModel.Response.DetailTaskSection(
            section: .title(title: DetailTaskTitleSection.date.rawValue),
            items: [
                .date(date: task?.formattedCreationDate ?? Date().formatted(date: .abbreviated, time: .omitted))
            ]
        )
        
        let descriptionSection = DetailTaskModel.Response.DetailTaskSection(
            section: .title(title: DetailTaskTitleSection.description.rawValue),
            items: [
                .textView(
                    text: task?.displayDescription ?? "",
                    placeholder: "Описание задачи...",
                    fontSize: 15,
                    textAction: { _ in }
                )
            ]
        )
        
        return DetailTaskModel.Response(data: [titleSection, dateSection, descriptionSection])
    }
}

// MARK: - Async Test Helpers

extension XCTestCase {
    
    func waitForAsyncOperation(timeout: TimeInterval = 1.0, operation: @escaping () -> Void) {
        let expectation = XCTestExpectation(description: "Async operation")
        
        DispatchQueue.main.async {
            operation()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
    func waitForBackgroundOperation(timeout: TimeInterval = 1.0, operation: @escaping () -> Void) {
        let expectation = XCTestExpectation(description: "Background operation")
        
        DispatchQueue.global(qos: .background).async {
            operation()
            DispatchQueue.main.async {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: - Mock Data Providers

class MockDataProvider {
    
    static let shared = MockDataProvider()
    
    private init() {}
    
    func createMockTasks(count: Int) -> [UserTask] {
        return (0..<count).map { index in
            TestUtilities.createMockUserTask(
                title: "Task \(index + 1)",
                description: "Description \(index + 1)",
                isCompleted: index % 2 == 0,
                serverID: Int64(index + 1)
            )
        }
    }
    
    func createMockTodos(count: Int) -> [Todo] {
        return (0..<count).map { index in
            TestUtilities.createMockTodo(
                id: index + 1,
                todo: "Todo \(index + 1)",
                completed: index % 2 == 0
            )
        }
    }
    
    func createMockSectionViewModels(count: Int) -> [SectionViewModel] {
        return (0..<count).map { index in
            SectionViewModel(
                title: "Section \(index + 1)",
                viewModels: [
                    TaskCardViewModel(
                        task: TestUtilities.createMockUserTask(title: "Task \(index + 1)"),
                        goToDetailTask: {},
                        deleteTask: {},
                        toShareTask: {},
                        toggleIsDone: {}
                    )
                ]
            )
        }
    }
}

// MARK: - Test Assertions

extension XCTestCase {
    
    func XCTAssertTaskEqual(_ task1: UserTask, _ task2: UserTask, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(task1.id, task2.id, "Task IDs should be equal", file: file, line: line)
        XCTAssertEqual(task1.title, task2.title, "Task titles should be equal", file: file, line: line)
        XCTAssertEqual(task1.taskDescription, task2.taskDescription, "Task descriptions should be equal", file: file, line: line)
        XCTAssertEqual(task1.isCompleted, task2.isCompleted, "Task completion status should be equal", file: file, line: line)
        XCTAssertEqual(task1.serverID, task2.serverID, "Task server IDs should be equal", file: file, line: line)
    }
    
    func XCTAssertTaskValid(_ task: UserTask, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(task.id, "Task should have an ID", file: file, line: line)
        XCTAssertNotNil(task.title, "Task should have a title", file: file, line: line)
        XCTAssertNotNil(task.creationDate, "Task should have a creation date", file: file, line: line)
        XCTAssertTrue(task.isValid, "Task should be valid", file: file, line: line)
    }
    
    func XCTAssertResponseValid(_ response: MainModel.Response, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(response.data, "Response should have data", file: file, line: line)
        XCTAssertGreaterThanOrEqual(response.data.count, 0, "Response should have non-negative section count", file: file, line: line)
    }
    
    func XCTAssertDetailResponseValid(_ response: DetailTaskModel.Response, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(response.data, "Detail response should have data", file: file, line: line)
        XCTAssertGreaterThanOrEqual(response.data.count, 0, "Detail response should have non-negative section count", file: file, line: line)
    }
}

// MARK: - Test Constants

struct TestConstants {
    static let timeout: TimeInterval = 1.0
    static let longTimeout: TimeInterval = 5.0
    
    struct Task {
        static let validTitle = "Valid Task Title"
        static let validDescription = "Valid Task Description"
        static let emptyTitle = ""
        static let whitespaceTitle = "   "
        static let searchQuery = "test"
    }
    
    struct Error {
        static let timeoutMessage = "Operation timed out"
        static let invalidDataMessage = "Invalid data provided"
        static let networkErrorMessage = "Network error occurred"
    }
}
