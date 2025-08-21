//
//  Sections.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation

enum Sections {
    case title(title: String)
    
    var text: String {
        switch self {
        case .title(let title):
            return title
        }
    }
}
