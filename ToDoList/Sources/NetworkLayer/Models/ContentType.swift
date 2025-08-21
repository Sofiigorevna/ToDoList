//
//  ContentType.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation
/// Тип контента
public enum ContentType {
    /// JSON данные
    case json
    case urlencoded
    /// Multipart данные
    case multipart(boundary: String)
    ///Изображение форматаjpeg
    case jpeg
    /// Изображение формата png
    case png
    /// Возвращает значение типа контента для передачи в HTTP заголовке
    public var value: String {
        switch self {
        case .json: "application/json"
        case .urlencoded: "application/x-www-form-urlencoded"
        case .multipart(let boundary): "multipart/form-data; boundary=\(boundary)"
        case .jpeg: "image/jpeg"
        case .png: "image/png"
        }
    }
}
