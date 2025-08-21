//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .systemBackground
        
        contentView.addSubview(checkmarkImageView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            checkmarkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24),
            
            stackView.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with task: UserTask) {
        titleLabel.text = task.displayTitle
        descriptionLabel.text = task.displayDescription
        dateLabel.text = task.formattedCreationDate
        
        // Update checkmark and text styling based on completion status
        if task.isCompleted {
            checkmarkImageView.image = UIImage(systemName: task.statusIcon)
            checkmarkImageView.tintColor = .systemGreen
            
            // Strike through completed tasks
            titleLabel.attributedText = NSAttributedString(
                string: task.displayTitle,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.systemGray
                ]
            )
            
            descriptionLabel.textColor = .systemGray
        } else {
            checkmarkImageView.image = UIImage(systemName: task.statusIcon)
            checkmarkImageView.tintColor = .systemBlue
            
            // Reset text styling for incomplete tasks
            titleLabel.attributedText = nil
            titleLabel.text = task.displayTitle
            titleLabel.textColor = .label
            
            descriptionLabel.textColor = .secondaryLabel
        }
        
        // Hide description label if empty
        descriptionLabel.isHidden = task.taskDescription?.isEmpty ?? true
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        checkmarkImageView.image = nil
    }
}
