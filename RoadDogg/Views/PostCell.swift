//
//  PostCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/29/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var optionsButtonLabel: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var likeButtonLabel: UIButton!
    @IBOutlet weak var commentButtonLabel: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var post : Post?
    

    @IBAction func likePressed(_ sender: Any) {
        if ( self.post?.isLiked )!{
            Network.shared.unLikePost(postKey: (post?.postKey)!)
            self.post?.unlike()
            self.likeLabel.text = post?.likeCountString
            self.likeButtonLabel.setTitle("Like", for: .normal)
        }else{
            Network.shared.likePost(postKey: (post?.postKey)!)
            self.post?.like()
            self.likeLabel.text = post?.likeCountString
            self.likeButtonLabel.setTitle("UnLike", for: .normal)
        }
    }
    
    @IBAction func commentPressed(_ sender: Any) {
    }
}
