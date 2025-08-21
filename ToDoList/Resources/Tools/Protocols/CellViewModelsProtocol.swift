//
//  CellViewModelsProtocol.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit
/// Протокол для модели компонента
protocol ICellViewModel {
    func cellReuseID() -> String
}
