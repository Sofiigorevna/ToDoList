//
//  ModuleTableViewController+DataSource.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import UIKit

// MARK: ModuleTableViewController UITableViewDataSource
extension ModuleTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < sections.count else { return 0 }
        return self.sections[section].viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: sections[indexPath.section].viewModels[indexPath.row].cellReuseID(),
                for: indexPath
            ) as? ITableViewCell else { return UITableViewCell() }
        
        let cellModel = sections[indexPath.section].viewModels[indexPath.row]
        
        cell.selectionStyle = .none
        cell.configure(with: cellModel)
        cell.backgroundColor = .black
        
        return cell
    }
}
