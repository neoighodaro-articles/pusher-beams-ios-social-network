//
//  CommentTableViewController.swift
//  Gram
//
//  Created by Neo Ighodaro on 01/05/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class CommentsTableViewController: UITableViewController {
    
    var photoId: Int = 0
    
    var commentField: UITextField?

    var comments: PhotoComments = []
    
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"

        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addCommentButtonWasTapped))
        
        if photoId != 0 {
            ApiService.shared.fetchComments(forPhoto: photoId) { comments in
                guard let comments = comments else { return }
                
                self.comments = comments
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Comment", for: indexPath) as! CommentsListTableViewCell
        let comment = comments[indexPath.row]
        
        cell.username?.text = comment.user.name
        cell.comment?.text = comment.comment
        
        return cell
    }
    
    // MARK: Action methods
    
    @objc func addCommentButtonWasTapped() {
        let alertCtrl = UIAlertController(title: "Add Comment", message: nil, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertCtrl.addTextField { textField in self.commentField = textField }
        alertCtrl.addAction(UIAlertAction(title: "Add Comment", style: .default) { _ in
            guard let comment = self.commentField?.text else { return }
            
            ApiService.shared.leaveComment(forId: self.photoId, comment: comment) { newComment in
                guard let comment = newComment else {
                    return StatusBarNotificationBanner(title: "Failed to post comment", style: .danger).show()
                }

                self.comments.insert(comment, at: 0)
                self.tableView.reloadData()
            }
        })

        self.present(alertCtrl, animated: true, completion: nil)
    }

}
