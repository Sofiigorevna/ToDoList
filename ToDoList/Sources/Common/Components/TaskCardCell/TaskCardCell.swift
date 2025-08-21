//
//  TaskCardCell.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit
import UniformTypeIdentifiers

final class TaskCardCell: UITableViewCell {
    private let customContentView = ContentVIewTaskCard()
    
    private let editTitleButton: String = FixedPhrases.edit
    private let toShareTitleButton: String = FixedPhrases.toShare
    private let deleteTitleButton: String = FixedPhrases.delete
    private var cellModel: TaskCardViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        
        let interaction = UIContextMenuInteraction(delegate: self)
        customContentView.addInteraction(interaction)
        customContentView.enable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        customContentView.prepare()
    }
}

private extension TaskCardCell {
    func setupView() {
        setupContentView()
        constraints()
    }
    
    func setupContentView() {
        contentView.addSubview(customContentView)
        contentView.backgroundColor = Colors.background.color
        customContentView.layer.cornerRadius = Sizes.Radius.r300
    }
    
    func constraints() {
        customContentView.tAMIC()
        customContentView.fullScreen(contentView)
//        NSLayoutConstraint.activate([
//            customContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Sizes.Spacing.S16.top),
//            customContentView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Sizes.Spacing.S16.left),
//            customContentView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: Sizes.Spacing.S16.right),
//            customContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Sizes.Spacing.S12.bottom)
//        ])
    }
}
// MARK: - ITableViewCell
extension TaskCardCell: ITableViewCell {
    func configure(with viewModel: ICellViewModel) {
        guard let viewModel = viewModel as? TaskCardViewModel else { return }
        cellModel = viewModel
        customContentView.configure(with: viewModel)
    }
}
// MARK: - UIContextMenuInteractionDelegate
extension TaskCardCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            // Редактировать 
            let edit = UIAction(title: self.editTitleButton, image: UIImage(systemName: "pencil")) { _ in
                self.cellModel?.goToDetailTask()
            }
            
            // Поделиться
            let toShare = UIAction(title: self.toShareTitleButton, image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.cellModel?.toShareTask()
            }
            
            // Удалить
            let delete = UIAction(
                title: self.deleteTitleButton,
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                self.cellModel?.deleteTask()
            }
            
            return UIMenu(title: "", children: [edit, toShare, delete])
        }
    }
    
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        // Создаем preview только для View
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(roundedRect: customContentView.bounds,
                                              cornerRadius: customContentView.layer.cornerRadius)
        
        return UITargetedPreview(view: customContentView, parameters: parameters)
    }
    
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        // Аналогично для dismiss preview
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(roundedRect: customContentView.bounds,
                                              cornerRadius: customContentView.layer.cornerRadius)
        
        return UITargetedPreview(view: customContentView, parameters: parameters)
    }
}
