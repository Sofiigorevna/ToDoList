//
//  TextViewCellViewModel.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import CoreFoundation

final class TextViewViewModel: ICellViewModel {
    var text: String
    var placeholder: String
    var fontSize: CGFloat
    var textAction: (String) -> ()
    
    init(text: String, placeholder: String, fontSize: CGFloat, textAction: @escaping (String) -> ()) {
        self.text = text
        self.placeholder = placeholder
        self.textAction = textAction
        self.fontSize = fontSize
    }
    
    func cellReuseID() -> String {
        TextViewCell.description()
    }
}
