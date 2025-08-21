//
//  DateViewModel.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation

final class DateViewModel: ICellViewModel {
    var date: Date
    
    init(date: Date) {
        self.date = date
    }
    
    func cellReuseID() -> String {
        DateCell.description()
    }
}
