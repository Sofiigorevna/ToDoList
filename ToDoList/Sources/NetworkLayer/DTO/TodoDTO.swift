//
//  TodoDTO.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation

// MARK: - Todo
struct Todo: Codable {
    let id: Int?
    let todo: String?
    let completed: Bool?
    let userId: Int?
}

// MARK: - TodosResponse
struct TodosResponse: Codable {
    let todos: [Todo]?
    let total: Int?
    let skip: Int?
    let limit: Int?
}
