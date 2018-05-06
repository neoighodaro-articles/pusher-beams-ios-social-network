//
//  PhotoListTableViewCell.swift
//  Gram
//
//  Created by Neo Ighodaro on 28/04/2018.
//  Copyright © 2018 TapSharp Interactive. All rights reserved.
//

import UIKit

protocol PhotoListCellDelegate {
    func commentButtonWasTapped(at indexPath: IndexPath)
}

class PhotoListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var commentButton: UIButton!

    var indexPath: IndexPath?
    var delegate: PhotoListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        commentButton.addTarget(self, action: #selector(commentButtonWasTapped), for: .touchUpInside)
    }
    
    @objc func commentButtonWasTapped() {
        if let indexPath = indexPath, let delegate = delegate {
            delegate.commentButtonWasTapped(at: indexPath)
        }
    }
}
