//
//  SettingsTableViewController.swift
//  Gram
//
//  Created by Neo Ighodaro on 26/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let settings = {
        return SettingsService.shared.settings
    }()
    
    private func shouldCheckCell(at indexPath: IndexPath, with setting: String) -> Bool {
        let status = Setting.Notification.Comments(rawValue: setting)

        return (status == .off && indexPath.row == 0) ||
               (status == .following && indexPath.row == 1) ||
               (status == .everyone && indexPath.row == 2)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.accessoryType = .none
        
        if let setting = settings["notification_comments"], shouldCheckCell(at: indexPath, with: setting) {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowsCount = self.tableView.numberOfRows(inSection: indexPath.section)
        
        for i in 0..<rowsCount  {
            if let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section)) {
                cell.accessoryType = indexPath.row == i ? .checkmark : .none
            }
        }
        
        let setting = indexPath.row == 0 ? "Off" : (indexPath.row == 1 ? "Following" : "Everyone")
        
        if let status = Setting.Notification.Comments(rawValue: setting) {
            SettingsService.shared.updateCommentsNotificationSetting(status)
        }
    }
    
}
