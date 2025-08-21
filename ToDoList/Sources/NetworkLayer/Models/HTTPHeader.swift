//
//  HTTPHeader.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation

typealias HTTPHeader = [String: String]
/// Поля HTTP-заголовка. Содержит список часто используемых полей заголовка для устранения хардкода и избежания ошибок написания полей
enum HeaderField {
    ///AIC-User-Agent
    case userAgent(String)
    
    /// Название ключа заголовка
    var key: String {
        switch self {
            case .userAgent(_): "AIC-User-Agent"
        }
    }
    
    /// Значение поля заголовка
    var value: String {
        switch self {
            case .userAgent(let agent): return agent
        }
    }
}
