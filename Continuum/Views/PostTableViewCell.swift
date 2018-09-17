//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var post: Post?{
        didSet{
            updateViews()
        }
    }

    func updateViews(){
        guard let post = post else {return}
        photoImageView.image = post.photo
        captionLabel.text = post.comments.first?.text
        commentCountLabel.text = "\(post.comments.count)"
    }
}
