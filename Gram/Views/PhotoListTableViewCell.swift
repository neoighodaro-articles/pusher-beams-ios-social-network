//
//  PhotoListTableViewCell.swift
//  Gram
//
//  Created by Neo Ighodaro on 28/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit

protocol PhotoListCellDelegate {
    func likeButtonWasTapped(at indexPath: IndexPath)
    func commentButtonWasTapped(at indexPath: IndexPath)
}

class PhotoListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!

    var indexPath: IndexPath?
    var delegate: PhotoListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        likeButton.addTarget(self, action: #selector(likeButtonWasTapped), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentButtonWasTapped), for: .touchUpInside)
    }
    
    @objc func likeButtonWasTapped() {
        if let indexPath = indexPath, let delegate = delegate {
            delegate.likeButtonWasTapped(at: indexPath)
        }
    }
    
    @objc func commentButtonWasTapped() {
        if let indexPath = indexPath, let delegate = delegate {
            delegate.commentButtonWasTapped(at: indexPath)
        }
    }
}
