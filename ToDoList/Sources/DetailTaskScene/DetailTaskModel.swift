//
//  DetailTaskModel.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation

enum DetailTaskModel {
    struct Response {
        var data: [DetailTaskSection]
        
        struct DetailTaskSection {
            var section: Sections
            var items: [Item]
        }
        
        enum Item {
            case date(date: String)
            
            case textView(
                text: String,
                placeholder: String,
                fontSize: CGFloat,
                textAction: (String) -> ()
            )
        }
    }
}
