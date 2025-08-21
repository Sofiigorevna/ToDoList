//
//  NetworkRequest.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation
/// Протокол для создания сетевых запросов
protocol NetworkRequest {
    var baseURL: URL { get }
    /// Путь запроса
    var path: String { get }
    /// HTTP Метод, указывающий тип запроса
    var method: HTTPMethod { get }
    /// HTTP заголовок
    var header: HTTPHeader? { get }
    /// Параметры запроса
    var parameters: Parameters { get }
}
extension NetworkRequest {
    /// Значение HTTPHeaders по умолчанию
    var header: HTTPHeader? {
        var headers = HTTPHeader()
        
        let defaultHeaders: [HeaderField] = [
            .userAgent("sofiigorevnaa@yandex.ru"),
        ]
        
        defaultHeaders.forEach { headerFields in
            headers[headerFields.key] = headerFields.value
        }

        return headers
    }
}
