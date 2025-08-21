//
//  Parameters.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation
/// Параметры запроса
public enum Parameters {
    /// Параметры отсутствуют
    case none
    /// Параметры, передающиеся в URL, используется в GET запросах. Содержится в виде словаря
    case url([String: Any])
    /// JSON запрос. Содержит в себе JSON в виде словаря
    case json([String: Any])
    /// Тип содержимого, чаще всего использующийся для отправки HTML-форм с бинарными данными метода POST.
    /// Содержит параметры в виде словаря
    case formData([String: Any])
    /// Любые бинарные данные для отправки методом POST. Содержит в себе данные и тип данных
    case data(Data, ContentType)
    
    public var contentType: ContentType? {
        switch self {
        case .none: return nil //Так как параметры отсутствуют, то и тип тоже.
        case .url(let dictionary): return .json
        case .json(let dictionary): return .json
        case .formData: return .urlencoded
        case let .data(_, type): return type
        }
    }
}
