//
//  SettingsTableViewController.swift
//  Gram
//
//  Created by Neo Ighodaro on 26/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var settings: [String: String] {
        return SettingsService.shared.settings
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        switch indexPath.section {
        case 0: self.setAccessoryTypeForCell(&cell, at: indexPath, in: "notification_likes")
        case 1: self.setAccessoryTypeForCell(&cell, at: indexPath, in: "notification_comments")
        case 2: self.setAccessoryTypeForCell(&cell, at: indexPath, in: "notification_followers")
        default: break
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
        
        self.updateNotificationSetting(at: indexPath)
    }
    
    private func setAccessoryTypeForCell(_ cell: inout UITableViewCell, at indexPath: IndexPath, in section: String) {
        if let status = settings[section], let setting = Setting.Notification.Likes(rawValue: status) {
            cell.accessoryType = .none

            if setting == .off && indexPath.row == 0 {
                cell.accessoryType = .checkmark
            }

            else if setting == .following && indexPath.row == 1 {
                cell.accessoryType = .checkmark
            }

            else if setting == .everyone && indexPath.row == 2 {
                cell.accessoryType = .checkmark
            }
        }
    }

    private func updateNotificationSetting(at indexPath: IndexPath) {
        let section = indexPath.section
        let setting = indexPath.row == 0 ? "Off" : (indexPath.row == 1 ? "Following" : "Everyone")

        // Likes
        if section == 0, let status = Setting.Notification.Likes(rawValue: setting) {
            SettingsService.shared.updateLikesNotificationSetting(status)
        }

        // Comments
        else if section == 1, let status = Setting.Notification.Comments(rawValue: setting) {
            SettingsService.shared.updateCommentsNotificationSetting(status)
        }

        // New followers
        else if section == 2, let status = Setting.Notification.Followers(rawValue: setting) {
            SettingsService.shared.updateNewFollowersNotificationSetting(status)
        }
    }
}
