//
//  IActivityIndicatorViewProtocol.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

protocol IActivityIndicatorView {
    var activityIndicatorView: UIActivityIndicatorView { get set }
    
    func showLoader()
    func hideLoader()
}

extension IActivityIndicatorView where Self: UIViewController {
    func showLoader() {
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
    }
    
    func hideLoader() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
}
