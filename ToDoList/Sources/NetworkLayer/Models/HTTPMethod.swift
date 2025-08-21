//
//  HTTPMethod.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation
/// Перечисление `HTTPMethod` определяет доступные HTTP методы для сетевых запросов.
public enum HTTPMethod: String {
    /// HTTP метод "GET", используемый для запросов на получение данных.
    case get = "GET"
    /// HTTP метод "POST", используемый для создания новых данных.
    case post = "POST"
    /// HTTP метод "PATCH", используемый для частичного обновления существующих данных.
    case patch = "PATCH"
    /// HTTP метод "DELETE", используемый для удаления существующих данных.
    case delete = "DELETE"
}
