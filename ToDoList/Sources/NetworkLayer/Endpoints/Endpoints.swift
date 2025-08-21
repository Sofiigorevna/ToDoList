//
//  Endpoints.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation

public struct Link {
    static let url = "https://dummyjson.com/"
}

enum Endpoints {
    case todos
}

extension Endpoints: NetworkRequest {
    var baseURL: URL {
        return URL(string: Link.url)!
    }
    
    var path: String {
        switch self {
            case .todos: "todos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            default: .get
        }
    }
    
    var parameters: Parameters {
        switch self {                
            default:
                return .none
        }
    }
}
