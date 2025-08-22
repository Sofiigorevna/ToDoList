//
//  CustomTextView.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

protocol MaterialTextViewDelegate: AnyObject {
    func textChangeTracking(_ text: String)
}

final class CustomTextView: UIView {
    var onHeightChange: (() -> ())?
    
    var text: String {
        get { textView.text }
        set {
            setTextInTextView(newValue)
        }
    }
    
    var placeholder: String = "" {
        didSet {
            setPlaceholderInTextView(placeholder)
        }
    }
    
    var fontSize: CGFloat = 17 {
        didSet {
            textView.font =  .systemFont(ofSize: fontSize, weight: .bold)
        }
    }
    
    private let textView = UITextView()
    private let placeholderLabel = UILabel()
    
    weak var delegate: MaterialTextViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: textView.contentSize.height)
    }
}

extension CustomTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else { return }
        // Уведомляем систему о необходимости обновления макета
        self.layoutIfNeeded()
        onHeightChange?()
        
        checkPlaceholder(textView.text)
        delegate?.textChangeTracking(textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        checkPlaceholder(textView.text)
    }
    
    private func checkPlaceholder(_ text: String) {
        placeholderLabel.isHidden = !text.isEmpty
    }
}

private extension CustomTextView {
    func setupView() {
        setupTextView()
        setupPlaceholderLabel()
        setupConstrainrs()
    }
    
    func setupTextView() {
        textView.textColor = Colors.label.color
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.textContainer.lineBreakMode = .byWordWrapping // Поддержка переноса строк
        textView.textContainer.maximumNumberOfLines = 0 // Без ограничений на количество строк
        
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
    }
    
    func setupPlaceholderLabel() {
        placeholderLabel.textColor = Colors.gray.color
        placeholderLabel.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    func setupConstrainrs() {
        [textView, placeholderLabel].forEach {
            $0.tAMIC()
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leftAnchor.constraint(equalTo: leftAnchor),
            textView.rightAnchor.constraint(equalTo: rightAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: Sizes.Spacing.S8.top),
            placeholderLabel.leftAnchor.constraint(equalTo: textView.leftAnchor, constant: Sizes.Spacing.S12.left),
            placeholderLabel.rightAnchor.constraint(equalTo: textView.rightAnchor, constant: Sizes.Spacing.S8.right)
        ])
    }
    
    func setTextInTextView(_ text: String) {
        textView.text = text
        checkPlaceholder(text)
        textViewDidChange(textView)
    }
    
    func setPlaceholderInTextView(_ text: String) {
        placeholderLabel.text = text
        checkPlaceholder(textView.text)
    }
    
    func heightForFiveLines() -> CGFloat {
        guard let font = textView.font else { return 0 }
        return font.lineHeight * 5 + textView.textContainerInset.top + textView.textContainerInset.bottom
    }
    
    func heightForSingleLine() -> CGFloat {
        guard let font = textView.font else { return 0 }
        return font.lineHeight + textView.textContainerInset.top + textView.textContainerInset.bottom
    }
}
