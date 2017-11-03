//
//  PostViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/31/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

protocol PostViewCellDelegate {
    func comment()
}

class PostViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var optionsLabel: UIButton!
    //@IBOutlet weak var textView: UITextView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var textAreaView: UIView!
    var post : Post!
    var delegate: PostViewCellDelegate?
    
    
    @IBAction func optionsAction(_ sender: Any) {
        
    }
    
    @IBAction func likeAction(_ sender: Any) {
        if ( self.post?.isLiked )!{
            Network.shared.unLikePost(postKey: (post?.postKey)!)
            self.post?.unlike()
            self.numberOfLikesLabel.text = post?.likeCountString
            self.likeButton.setTitle("Like", for: .normal)
        }else{
            Network.shared.likePost(postKey: (post?.postKey)!)
            self.post?.like()
            self.numberOfLikesLabel.text = post?.likeCountString
            self.likeButton.setTitle("UnLike", for: .normal)
        }
    }
    
    @IBAction func commentAction(_ sender: Any) {
        delegate?.comment()
    }
    
    @IBAction func shareAction(_ sender: Any) {
    }
}
