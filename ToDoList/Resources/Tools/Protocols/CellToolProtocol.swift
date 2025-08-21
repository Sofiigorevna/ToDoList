//
//  CellToolProtocol.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit
/// Протокол для передачи данных из модели компонента
protocol ITableViewCell where Self: UITableViewCell {
    func configure(with viewModel: ICellViewModel)
}
