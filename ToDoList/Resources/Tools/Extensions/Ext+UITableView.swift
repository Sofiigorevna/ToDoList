//
//  Ext+UITableView.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

extension UITableView {
    /// Регистрирует множество различных ячеек в таблице.
    ///
    /// Каждая переданная ячейка регистрируется с использованием ее типа в качестве идентификатора.
    ///
    /// - Parameter cells: Типы ячеек для регистрации.
    public func registeringCellsInTable(_ cells: UITableViewCell.Type...) {
        cells.forEach { cell in
            self.register(cell, forCellReuseIdentifier: cell.description())
        }
    }
}
