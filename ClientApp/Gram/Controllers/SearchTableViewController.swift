//
//  SearchTableViewController.swift
//  Gram
//
//  Created by Neo Ighodaro on 26/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class SearchTableViewController: UITableViewController {

    var users: Users = []
    
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiService.shared.fetchUsers { users in
            guard let users = users else {
                return StatusBarNotificationBanner(title: "Unable to fetch users.", style: .danger).show()
            }
            
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = self.users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "User", for: indexPath) as! UserListTableViewCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.textLabel?.text = user.name
        
        if let following = user.follows {
            cell.setFollowStatus(following)
        }

        return cell
    }
    
}


// MARK: - Follow button delegate

extension SearchTableViewController: UserListCellFollowButtonDelegate {
    
    func followButtonTapped(at indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        let userFollows = user.follows ?? false
        
        ApiService.shared.toggleFollowStatus(forUserId: user.id, following: userFollows) { successful in
            guard let successful = successful, successful else { return }
            
            self.users[indexPath.row].follows = !userFollows
            self.tableView.reloadData()
        }
    }
    
}
