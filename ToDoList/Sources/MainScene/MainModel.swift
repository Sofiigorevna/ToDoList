//
//  MainModel.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation

enum MainModel {
    struct Response {
        var data: [MainSection]
        
        struct MainSection {
            var section: Sections
            var items: [Item]
        }
        
        enum Item {
            case taskCard(
                task: UserTask,
                goToDetailTask: (() -> Void),
                deleteTask: (() -> Void),
                toShareTask: (() -> Void)
            )
        }
    }
}
