//
//  ContentVIewTaskCard.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit
/// Используется в ячейке TaskCardCell
final class ContentVIewTaskCard: UIView {
    private let checkmarkImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let stackView = UIStackView()
    private var cellModel: TaskCardViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        titleLabel.attributedText = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        checkmarkImageView.image = nil
    }
    
    func configure(with viewModel: TaskCardViewModel) {
        cellModel = viewModel
        let task = viewModel.task
        titleLabel.text = task.displayTitle
        descriptionLabel.text = task.displayDescription
        dateLabel.text = task.formattedCreationDate
        
        if task.isCompleted {
            checkmarkImageView.image = UIImage(systemName: task.statusIcon)
            checkmarkImageView.tintColor = Colors.accent.color
            
            titleLabel.attributedText = NSAttributedString(
                string: task.displayTitle,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.systemGray
                ]
            )
            
            descriptionLabel.textColor = Colors.gray.color
        } else {
            checkmarkImageView.image = UIImage(systemName: task.statusIcon)
            checkmarkImageView.tintColor = Colors.gray.color
            
            titleLabel.attributedText = nil
            titleLabel.text = task.displayTitle
            titleLabel.textColor = .label
            
            descriptionLabel.textColor = .secondaryLabel
        }
        
        descriptionLabel.isHidden = task.taskDescription?.isEmpty ?? true
    }
    
    @objc private func pressToView() {
        cellModel?.goToDetailTask()
    }
}

private extension ContentVIewTaskCard {
    func setupView() {
        setupContentView()
        constraints()
        self.enable()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressToView)))
    }
    
    func setupContentView() {
        [checkmarkImageView, stackView].forEach { view in
            self.subviewsOnView(view)
        }
        
        [titleLabel, descriptionLabel, dateLabel].forEach { view in
            stackView.addArrangedSubview(view)
        }
        
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.tintColor = Colors.gray.color
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
    }
    
    func constraints() {
        [checkmarkImageView, titleLabel, descriptionLabel, dateLabel, stackView].forEach { view in
            view.tAMIC()
        }
        
        NSLayoutConstraint.activate([
            checkmarkImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Sizes.Spacing.S16.left),
            checkmarkImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: Sizes.Height.h024),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: Sizes.Width.w024),
            
            stackView.leftAnchor.constraint(equalTo: checkmarkImageView.rightAnchor, constant: Sizes.Spacing.S12.left),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: Sizes.Spacing.S16.right),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: Sizes.Spacing.S12.top),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Sizes.Spacing.S12.bottom)
        ])
    }
}
