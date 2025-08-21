//
//  Ext+UIView.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

extension UIView {
    
    /// Устанавливает свойство `isUserInteractionEnabled` в `true`.
    public func enable() {
        self.isUserInteractionEnabled = true
    }
    /// Устанавливает свойство `isUserInteractionEnabled` в `false`.
    public func disable() {
        self.isUserInteractionEnabled = false
    }
    /// Устанавливает свойство `translatesAutoresizingMaskIntoConstraints` в `false`.
    public func tAMIC() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    /// Добавляет несколько подвью на текущее представление.
    ///
    /// - Parameter subviews: Массив подвью для добавления.
    public func subviewsOnView(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}


extension UIView {
    private var superView: UIView { superview! }
    
    public func fullScreen(_ view: UIView? = nil) {
        tAMIC()
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view?.topAnchor ?? superView.topAnchor),
            leftAnchor.constraint(equalTo: view?.leftAnchor ?? superView.leftAnchor),
            rightAnchor.constraint(equalTo: view?.rightAnchor ?? superView.rightAnchor),
            bottomAnchor.constraint(equalTo: view?.bottomAnchor ?? superView.bottomAnchor)
        ])
    }
    
    public func fullScreenMarginsGuide() {
        tAMIC()
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.layoutMarginsGuide.topAnchor),
            leftAnchor.constraint(equalTo: superView.leftAnchor),
            rightAnchor.constraint(equalTo: superView.rightAnchor),
            bottomAnchor.constraint(equalTo: superView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
