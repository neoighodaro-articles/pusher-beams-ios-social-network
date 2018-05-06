//
//  CommentTableViewController.swift
//  Gram
//
//  Created by Neo Ighodaro on 01/05/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    var photoId: Int = 0
    
    var commentField: UITextField?

    var comments: [[String: AnyObject]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addCommentButtonWasTapped))
        
        if photoId != 0 {
            ApiService.shared.fetchComments(forPhoto: photoId, completion: { comments in
                if let comments = comments {
                    self.comments = comments
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    @objc func addCommentButtonWasTapped() {
        let alertCtrl = UIAlertController(title: "Add Comment", message: "Add a new comment", preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertCtrl.addAction(UIAlertAction(title: "Add Comment", style: .default, handler: { action in
            if let comment = self.commentField?.text {
                ApiService.shared.leaveComment(forId: self.photoId, comment: comment, completion: { newComment in
                    if let newComment = newComment {
                        self.comments.insert(newComment, at: 0)
                        self.tableView.reloadData()
                    }
                })
            }
        }))

        alertCtrl.addTextField { textField in
            self.commentField = textField
            textField.placeholder = "Type Comment Here..."
        }

        self.present(alertCtrl, animated: true, completion: nil)
    }

}


// MARK: - Table view data source

extension CommentsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Comment", for: indexPath) as! CommentsListTableViewCell
        let comment = comments[indexPath.row]
        
        if let user = comment["user"] as? [String: AnyObject] {
            cell.username?.text = user["name"] as? String
            cell.comment?.text = comment["comment"] as? String
        }

        return cell
    }
}
