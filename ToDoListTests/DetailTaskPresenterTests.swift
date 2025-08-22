//
//  DetailTaskPresenterTests.swift
//  ToDoListTests
//
//  Created by sofiigorevna on 21.08.2025.
//

import XCTest
import CoreData
@testable import ToDoList

final class DetailTaskPresenterTests: XCTestCase {
    
    var presenter: DetailTaskPresenter!
    var mockViewController: MockDetailTaskViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        presenter = DetailTaskPresenter()
        mockViewController = MockDetailTaskViewController()
        presenter.viewController = mockViewController
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        mockViewController = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Publish Tests
    
    func testPublishWithValidData() {
        // Given
        let testTask = createTestTask()
        let response = createTestResponse(with: testTask)
        
        // When
        presenter.publish(data: response)
        
        // Then
        XCTAssertTrue(mockViewController.updateCalled)
        XCTAssertEqual(mockViewController.updatedSections?.count, 3) // title, date, description
        XCTAssertNotNil(mockViewController.updatedSections)
    }
    
    func testPublishWithEmptyData() {
        // Given
        let emptyResponse = DetailTaskModel.Response(data: [])
        
        // When
        presenter.publish(data: emptyResponse)
        
        // Then
        XCTAssertTrue(mockViewController.updateCalled)
        XCTAssertEqual(mockViewController.updatedSections?.count, 0)
    }
    
    func testPublishWithNilViewController() {
        // Given
        presenter.viewController = nil
        let response = createTestResponse(with: createTestTask())
        
        // When & Then
        // Не должно вызывать краш
        presenter.publish(data: response)
        XCTAssertTrue(true) // Если дошли сюда, значит краша не было
    }
    
    // MARK: - Data Mapping Tests
    
    func testMapDataWithTextViewItem() {
        // Given
        let testTask = createTestTask()
        let response = createTestResponse(with: testTask)
        
        // When
        presenter.publish(data: response)
        
        // Then
        XCTAssertTrue(mockViewController.updateCalled)
        
        // Проверяем, что есть TextView элементы
        let titleSection = mockViewController.updatedSections?.first { section in
            section.title == DetailTaskTitleSection.title.rawValue
        }
        XCTAssertNotNil(titleSection)
        XCTAssertEqual(titleSection?.viewModels.count, 1)
        
        let descriptionSection = mockViewController.updatedSections?.first { section in
            section.title == DetailTaskTitleSection.description.rawValue
        }
        XCTAssertNotNil(descriptionSection)
        XCTAssertEqual(descriptionSection?.viewModels.count, 1)
    }
    
    func testMapDataWithDateItem() {
        // Given
        let testTask = createTestTask()
        let response = createTestResponse(with: testTask)
        
        // When
        presenter.publish(data: response)
        
        // Then
        XCTAssertTrue(mockViewController.updateCalled)
        
        // Проверяем, что есть Date элемент
        let dateSection = mockViewController.updatedSections?.first { section in
            section.title == DetailTaskTitleSection.date.rawValue
        }
        XCTAssertNotNil(dateSection)
        XCTAssertEqual(dateSection?.viewModels.count, 1)
    }
    
    // MARK: - Helper Methods
    
    private func createTestTask() -> UserTask {
        let context = CoreDataManager.shared.backgroundContext
        let task = UserTask(context: context)
        task.id = UUID()
        task.title = "Test Task Title"
        task.taskDescription = "Test Task Description"
        task.creationDate = Date()
        task.isCompleted = false
        task.serverID = 123
        return task
    }
    
    private func createTestResponse(with task: UserTask) -> DetailTaskModel.Response {
        let titleSection = DetailTaskModel.Response.DetailTaskSection(
            section: .title(title: DetailTaskTitleSection.title.rawValue),
            items: [
                .textView(
                    text: task.displayTitle,
                    placeholder: "Название задачи...",
                    fontSize: 30,
                    textAction: { _ in }
                )
            ]
        )
        
        let dateSection = DetailTaskModel.Response.DetailTaskSection(
            section: .title(title: DetailTaskTitleSection.date.rawValue),
            items: [
                .date(date: task.formattedCreationDate)
            ]
        )
        
        let descriptionSection = DetailTaskModel.Response.DetailTaskSection(
            section: .title(title: DetailTaskTitleSection.description.rawValue),
            items: [
                .textView(
                    text: task.displayDescription,
                    placeholder: "Описание задачи...",
                    fontSize: 15,
                    textAction: { _ in }
                )
            ]
        )
        
        return DetailTaskModel.Response(data: [titleSection, dateSection, descriptionSection])
    }
}

// MARK: - Mock Classes

class MockDetailTaskViewController: IDetailTaskView {
    var updateCalled = false
    var updatedSections: [SectionViewModel]?
    
    func update(sections: [SectionViewModel]) {
        updateCalled = true
        updatedSections = sections
    }
    
    // MARK: - IModuleTableView (required by protocol)
    
    var sections: [SectionViewModel] = []
    var tableView: UITableView = UITableView()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
