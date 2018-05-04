//
//  SearchTableViewController.swift
//  Gram
//
//  Created by Neo Ighodaro on 26/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UserListCellFollowButtonDelegate {

    var users: [[String: AnyObject]] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadUsersFromAPI()
    }
    
    private func loadUsersFromAPI() {
        ApiService.shared.fetchUsers(completion: { users in
            guard let users = users else {
                let alert = UIAlertController(title: "Oops", message: "Unable ot fetch users", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                return self.present(alert, animated: true, completion: nil)
            }
            
            self.users = users
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = self.users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "User", for: indexPath) as! UserListTableViewCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        cell.textLabel?.text = user["name"] as? String
        
        if let follows = user["follows"] as? Bool {
            cell.setFollowStatus(status: follows)
        }

        return cell
    }
    
    func followButtonTapped(at indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        
        if let id = user["id"] as? Int, let follows = user["follows"] as? Bool {
            ApiService.shared.toggleFollowStatus(forUserId: id, following: follows) { successful in
                guard let successful = successful, successful else { return }
                
                self.users[indexPath.row]["follows"] = !follows as AnyObject
                self.tableView.reloadData()
            }
        }
    }
}
