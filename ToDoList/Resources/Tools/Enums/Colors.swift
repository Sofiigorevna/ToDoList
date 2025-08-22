//
//  Colors.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

enum Colors {
    case background
    case secondaryBackground
    case label
    case secondaryLabel
    case accent
    case gray
    case lightGray
    
    var color: UIColor {
        switch self {
        case .background:
            return .systemBackground
        case .secondaryBackground:
            return .secondarySystemBackground
        case .label:
            return .label
        case .secondaryLabel:
            return .secondaryLabel
        case .accent:
            return .systemYellow
        case .gray:
            return .systemGray
        case .lightGray:
            return .lightGray
        }
    }
}
