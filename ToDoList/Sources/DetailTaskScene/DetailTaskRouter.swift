//
//  DetailTaskRouter.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

protocol IDetailTaskRouter { }

final class DetailTaskRouter: IDetailTaskRouter{
    weak var transitionHandler: UIViewController?
}
