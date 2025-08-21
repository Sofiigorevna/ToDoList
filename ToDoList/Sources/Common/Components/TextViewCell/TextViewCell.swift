//
//  TextViewCell.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit
/**
 Контейнер, содержит в себе:
 - Динамическое текстовое поле
 
 Можно вводить большое кол-ва текста
 */
final class TextViewCell: UITableViewCell {
    private let textView = CustomTextView()

    private var cellModel: TextViewViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TextViewCell {
    func setupView() {
        setupContentView()
        constraints()
    }
    
    func setupContentView() {
        contentView.addSubview(textView)
        contentView.backgroundColor = Colors.background.color
        textView.delegate = self
    }
    
    func constraints() {
        textView.tAMIC()
        textView.fullScreen(contentView)
    }
}
// MARK: - ITableViewCell
extension TextViewCell: ITableViewCell {
    func configure(with viewModel: ICellViewModel) {
        guard let viewModel = viewModel as? TextViewViewModel else { return }
        cellModel = viewModel
        textView.text = viewModel.text
        textView.placeholder = viewModel.placeholder
        textView.fontSize = viewModel.fontSize
    }
}

extension TextViewCell: MaterialTextViewDelegate {
    func textChangeTracking(_ text: String) {
        cellModel?.textAction(text)
    }
}
