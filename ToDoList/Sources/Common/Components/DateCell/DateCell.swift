//
//  DateCell.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

final class DateCell: UITableViewCell {
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ITableViewCell
extension DateCell: ITableViewCell {
    func configure(with viewModel: any ICellViewModel) {
        guard let viewModel = viewModel as? DateViewModel else { return }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        
        if Calendar.current.isDateInToday(viewModel.date) {
            formatter.dateFormat = "d MMMM"
            label.text = formatter.string(from: viewModel.date)
        }
    }
}

// MARK: - Settings view and another private methods
private extension DateCell {
    func setupView() {
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = Colors.gray.color
        label.textAlignment = .center
        
        contentView.addSubview(label)
        label.tAMIC()
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Sizes.Spacing.S8.left),
            label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Sizes.Spacing.S8.top),
            label.heightAnchor.constraint(equalToConstant: Sizes.Height.h024),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: Sizes.Width.w090 + 10)
        ])
        
        selectionStyle = .none
        backgroundColor = Colors.background.color
    }
}
