//
//  UserListTableViewCell.swift
//  Gram
//
//  Created by Neo Ighodaro on 26/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit

protocol UserListCellFollowButtonDelegate {
    func followButtonTapped(at index:IndexPath)
}

class UserListTableViewCell: UITableViewCell {

    var indexPath: IndexPath?
    
    var delegate: UserListCellFollowButtonDelegate?
    
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.setFollowStatus(false)
        self.followButton.layer.cornerRadius = 5
        self.followButton.setTitleColor(UIColor.white, for: .normal)
        self.followButton.addTarget(self, action: #selector(followButtonTapped(_:)), for: .touchUpInside)
    }

    func setFollowStatus(_ following: Bool) {
        self.followButton.backgroundColor = following ? UIColor.red : UIColor.blue
        self.followButton.setTitle(following ? "Unfollow" : "Follow", for: .normal)
    }
    
    @objc private func followButtonTapped(_ sender: UIButton) {
        if let delegate = delegate, let indexPath = indexPath {
            delegate.followButtonTapped(at: indexPath)
        }
    }
}
