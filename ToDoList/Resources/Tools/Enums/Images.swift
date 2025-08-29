//
//  Images.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit
/// Перечисление изображений находящихся в проекте
enum Images: String {
    case squarePencil = "square.and.pencil"
    case checkmark = "checkmark.circle.fill"
    case circle = "circle"
    case filter = "line.3.horizontal.decrease.circle"
    case sort = "arrow.up.arrow.down"
    case trash = "trash"
    case shared = "square.and.arrow.up"
    case pencil = "pencil"
    
    var image: UIImage? {
        return UIImage(systemName: self.rawValue)
    }
}
