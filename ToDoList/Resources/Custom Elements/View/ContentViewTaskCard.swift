//
//  ContentVIewTaskCard.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit
/// Используется в ячейке TaskCardCell
final class ContentViewTaskCard: UIView {
    private let checkmarkImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let stackView = UIStackView()
    private let separatorView = UIView()
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
        separatorView.backgroundColor = Colors.lightGray.color
    }
    
    func configure(with viewModel: TaskCardViewModel) {
        cellModel = viewModel
        let task = viewModel.task
        titleLabel.text = task.displayTitle
        descriptionLabel.text = task.displayDescription
        dateLabel.text = task.formattedCreationDate
        
        updateTaskAppearance(task: task, animated: false)
        
        descriptionLabel.isHidden = task.taskDescription?.isEmpty ?? true
    }
    
    func updateTaskAppearance(task: UserTask, animated: Bool = true) {
        let duration: TimeInterval = animated ? 0.6 : 0.0
        
        if task.isCompleted {
            checkmarkImageView.image = UIImage(systemName: task.statusIcon)
            checkmarkImageView.tintColor = Colors.accent.color
            
            if animated {
                // Анимированное зачеркивание
                UIView.animate(withDuration: duration, delay: 0.1, options: [.curveEaseInOut]) {
                    self.titleLabel.attributedText = NSAttributedString(
                        string: task.displayTitle,
                        attributes: [
                            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                            .foregroundColor: UIColor.systemGray
                        ]
                    )
                    self.descriptionLabel.textColor = Colors.gray.color
                }
            } else {
                titleLabel.attributedText = NSAttributedString(
                    string: task.displayTitle,
                    attributes: [
                        .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                        .foregroundColor: UIColor.systemGray
                    ]
                )
                descriptionLabel.textColor = Colors.gray.color
            }
        } else {
            checkmarkImageView.image = UIImage(systemName: task.statusIcon)
            checkmarkImageView.tintColor = Colors.gray.color
            
            if animated {
                // Анимированное убирание зачеркивания
                UIView.animate(withDuration: duration, delay: 0.1, options: [.curveEaseInOut]) {
                    self.titleLabel.attributedText = nil
                    self.titleLabel.text = task.displayTitle
                    self.titleLabel.textColor = .label
                    self.descriptionLabel.textColor = .secondaryLabel
                }
            } else {
                titleLabel.attributedText = nil
                titleLabel.text = task.displayTitle
                titleLabel.textColor = .label
                descriptionLabel.textColor = .secondaryLabel
            }
        }
    }
    
    @objc private func pressToView() {
        cellModel?.goToDetailTask()
    }
    
    @objc private func pressToCheckmark() {
        cellModel?.toggleIsDone()
    }
}

private extension ContentViewTaskCard {
    func setupView() {
        setupContentView()
        constraints()
        stackView.enable()
        checkmarkImageView.enable()
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressToView)))
        checkmarkImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressToCheckmark)))
    }
    
    func setupContentView() {
        [checkmarkImageView, stackView, separatorView].forEach { view in
            self.subviewsOnView(view)
        }
        
        [titleLabel, descriptionLabel, dateLabel].forEach { view in
            stackView.addArrangedSubview(view)
        }
        
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.tintColor = Colors.gray.color
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byTruncatingTail
        
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        // Настройка разделительной полосы
        separatorView.backgroundColor = Colors.lightGray.color
        separatorView.layer.opacity = 0.2
        separatorView.layer.cornerRadius = 0.5 // Половина высоты для скругления
    }
    
    func constraints() {
        [checkmarkImageView, titleLabel, descriptionLabel, dateLabel, stackView, separatorView].forEach { view in
            view.tAMIC()
        }
        
        NSLayoutConstraint.activate([
            checkmarkImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Sizes.Spacing.S8.left),
            checkmarkImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: Sizes.Spacing.S12.top),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: Sizes.Height.h028),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: Sizes.Width.w028),
            
            stackView.leftAnchor.constraint(equalTo: checkmarkImageView.rightAnchor, constant: Sizes.Spacing.S12.left),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: Sizes.Spacing.S16.right),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: Sizes.Spacing.S12.top),
            stackView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: Sizes.Spacing.S8.bottom),
            
            // Разделительная полоса
            separatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Sizes.Spacing.S8.left),
            separatorView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: Sizes.Spacing.S8.right),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Sizes.Spacing.S12.bottom),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0)
        ])
    }
}
