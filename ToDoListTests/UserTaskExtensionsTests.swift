//
//  UserTaskExtensionsTests.swift
//  ToDoListTests
//
//  Created by sofiigorevna on 21.08.2025.
//

import XCTest
import CoreData
@testable import ToDoList

final class UserTaskExtensionsTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        context = CoreDataManager.shared.backgroundContext
    }
    
    override func tearDownWithError() throws {
        context = nil
        try super.tearDownWithError()
    }
    
    // MARK: - DisplayTitle Tests
    
    func testDisplayTitleWithValidTitle() {
        // Given
        let task = UserTask(context: context)
        task.title = "Test Task"
        
        // When
        let displayTitle = task.displayTitle
        
        // Then
        XCTAssertEqual(displayTitle, "Test Task")
    }
    
    func testDisplayTitleWithNilTitle() {
        // Given
        let task = UserTask(context: context)
        task.title = nil
        
        // When
        let displayTitle = task.displayTitle
        
        // Then
        XCTAssertEqual(displayTitle, "Без названия")
    }
    
    func testDisplayTitleWithEmptyTitle() {
        // Given
        let task = UserTask(context: context)
        task.title = ""
        
        // When
        let displayTitle = task.displayTitle
        
        // Then
        XCTAssertEqual(displayTitle, "")
    }
    
    // MARK: - DisplayDescription Tests
    
    func testDisplayDescriptionWithValidDescription() {
        // Given
        let task = UserTask(context: context)
        task.taskDescription = "Test Description"
        
        // When
        let displayDescription = task.displayDescription
        
        // Then
        XCTAssertEqual(displayDescription, "Test Description")
    }
    
    func testDisplayDescriptionWithNilDescription() {
        // Given
        let task = UserTask(context: context)
        task.taskDescription = nil
        
        // When
        let displayDescription = task.displayDescription
        
        // Then
        XCTAssertEqual(displayDescription, "Нет описания")
    }
    
    func testDisplayDescriptionWithEmptyDescription() {
        // Given
        let task = UserTask(context: context)
        task.taskDescription = ""
        
        // When
        let displayDescription = task.displayDescription
        
        // Then
        XCTAssertEqual(displayDescription, "")
    }
    
    // MARK: - FormattedCreationDate Tests
    
    func testFormattedCreationDateWithValidDate() {
        // Given
        let task = UserTask(context: context)
        let testDate = Date()
        task.creationDate = testDate
        
        // When
        let formattedDate = task.formattedCreationDate
        
        // Then
        XCTAssertFalse(formattedDate.isEmpty)
        XCTAssertNotEqual(formattedDate, "Дата неизвестна")
        
        // Проверяем, что дата содержит русскую локаль
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        let expectedFormat = formatter.string(from: testDate)
        XCTAssertEqual(formattedDate, expectedFormat)
    }
    
    func testFormattedCreationDateWithNilDate() {
        // Given
        let task = UserTask(context: context)
        task.creationDate = nil
        
        // When
        let formattedDate = task.formattedCreationDate
        
        // Then
        XCTAssertEqual(formattedDate, "Дата неизвестна")
    }
    
    // MARK: - StatusText Tests
    
    func testStatusTextWhenCompleted() {
        // Given
        let task = UserTask(context: context)
        task.isCompleted = true
        
        // When
        let statusText = task.statusText
        
        // Then
        XCTAssertEqual(statusText, "Выполнено")
    }
    
    func testStatusTextWhenNotCompleted() {
        // Given
        let task = UserTask(context: context)
        task.isCompleted = false
        
        // When
        let statusText = task.statusText
        
        // Then
        XCTAssertEqual(statusText, "Не выполнено")
    }
    
    // MARK: - StatusIcon Tests
    
    func testStatusIconWhenCompleted() {
        // Given
        let task = UserTask(context: context)
        task.isCompleted = true
        
        // When
        let statusIcon = task.statusIcon
        
        // Then
        XCTAssertEqual(statusIcon, Images.checkmark.rawValue)
    }
    
    func testStatusIconWhenNotCompleted() {
        // Given
        let task = UserTask(context: context)
        task.isCompleted = false
        
        // When
        let statusIcon = task.statusIcon
        
        // Then
        XCTAssertEqual(statusIcon, Images.circle.rawValue)
    }
    
    // MARK: - IsValid Tests
    
    func testIsValidWithValidTitle() {
        // Given
        let task = UserTask(context: context)
        task.title = "Valid Title"
        
        // When
        let isValid = task.isValid
        
        // Then
        XCTAssertTrue(isValid)
    }
    
    func testIsValidWithNilTitle() {
        // Given
        let task = UserTask(context: context)
        task.title = nil
        
        // When
        let isValid = task.isValid
        
        // Then
        XCTAssertFalse(isValid)
    }
    
    func testIsValidWithEmptyTitle() {
        // Given
        let task = UserTask(context: context)
        task.title = ""
        
        // When
        let isValid = task.isValid
        
        // Then
        XCTAssertFalse(isValid)
    }
    
    func testIsValidWithWhitespaceOnlyTitle() {
        // Given
        let task = UserTask(context: context)
        task.title = "   "
        
        // When
        let isValid = task.isValid
        
        // Then
        XCTAssertFalse(isValid)
    }
    
    // MARK: - ToggleCompletion Tests
    
    func testToggleCompletionFromFalseToTrue() {
        // Given
        let task = UserTask(context: context)
        task.isCompleted = false
        
        // When
        task.toggleCompletion()
        
        // Then
        XCTAssertTrue(task.isCompleted)
    }
    
    func testToggleCompletionFromTrueToFalse() {
        // Given
        let task = UserTask(context: context)
        task.isCompleted = true
        
        // When
        task.toggleCompletion()
        
        // Then
        XCTAssertFalse(task.isCompleted)
    }
    
    // MARK: - MarkAsCompleted Tests
    
    func testMarkAsCompleted() {
        // Given
        let task = UserTask(context: context)
        task.isCompleted = false
        
        // When
        task.markAsCompleted()
        
        // Then
        XCTAssertTrue(task.isCompleted)
    }
    
    // MARK: - MarkAsIncomplete Tests
    
    func testMarkAsIncomplete() {
        // Given
        let task = UserTask(context: context)
        task.isCompleted = true
        
        // When
        task.markAsIncomplete()
        
        // Then
        XCTAssertFalse(task.isCompleted)
    }
    
    // MARK: - Matches Search Tests
    
    func testMatchesSearchWithTitleMatch() {
        // Given
        let task = UserTask(context: context)
        task.title = "Test Task Title"
        task.taskDescription = "Test Description"
        
        // When
        let matches = task.matches(searchText: "Task")
        
        // Then
        XCTAssertTrue(matches)
    }
    
    func testMatchesSearchWithDescriptionMatch() {
        // Given
        let task = UserTask(context: context)
        task.title = "Test Task"
        task.taskDescription = "Test Description"
        
        // When
        let matches = task.matches(searchText: "Description")
        
        // Then
        XCTAssertTrue(matches)
    }
    
    func testMatchesSearchWithCaseInsensitiveMatch() {
        // Given
        let task = UserTask(context: context)
        task.title = "Test Task"
        task.taskDescription = "Test Description"
        
        // When
        let matches = task.matches(searchText: "TASK")
        
        // Then
        XCTAssertTrue(matches)
    }
    
    func testMatchesSearchWithNoMatch() {
        // Given
        let task = UserTask(context: context)
        task.title = "Test Task"
        task.taskDescription = "Test Description"
        
        // When
        let matches = task.matches(searchText: "NonExistent")
        
        // Then
        XCTAssertFalse(matches)
    }
    
    func testMatchesSearchWithEmptySearchText() {
        // Given
        let task = UserTask(context: context)
        task.title = "Test Task"
        task.taskDescription = "Test Description"
        
        // When
        let matches = task.matches(searchText: "")
        
        // Then
        XCTAssertFalse(matches)
    }
    
    func testMatchesSearchWithNilTitleAndDescription() {
        // Given
        let task = UserTask(context: context)
        task.title = nil
        task.taskDescription = nil
        
        // When
        let matches = task.matches(searchText: "test")
        
        // Then
        XCTAssertFalse(matches)
    }
    
    // MARK: - CreateFromTodo Tests
    
    func testCreateFromTodo() {
        // Given
        let todo = Todo(
            id: 123,
            todo: "Test Todo",
            completed: false,
            userId: 1
        )
        
        // When
        let userTask = UserTask.createFromTodo(todo, in: context)
        
        // Then
        XCTAssertNotNil(userTask.id)
        XCTAssertEqual(userTask.serverID, 123)
        XCTAssertEqual(userTask.title, "Test Todo")
        XCTAssertNil(userTask.taskDescription)
        XCTAssertFalse(userTask.isCompleted)
        XCTAssertNotNil(userTask.creationDate)
    }
    
    func testCreateFromTodos() {
        // Given
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
        
        let todos = [todo1, todo2]
        
        // When
        let userTasks = UserTask.createFromTodos(todos, in: context)
        
        // Then
        XCTAssertEqual(userTasks.count, 2)
        XCTAssertEqual(userTasks[0].serverID, 1)
        XCTAssertEqual(userTasks[0].title, "Todo 1")
        XCTAssertFalse(userTasks[0].isCompleted)
        XCTAssertEqual(userTasks[1].serverID, 2)
        XCTAssertEqual(userTasks[1].title, "Todo 2")
        XCTAssertTrue(userTasks[1].isCompleted)
    }
}
