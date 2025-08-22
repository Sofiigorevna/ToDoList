//
//  DateViewModel.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation

final class DateViewModel: ICellViewModel {
    var date: String
    
    init(date: String) {
        self.date = date
    }
    
    func cellReuseID() -> String {
        DateCell.description()
    }
}
