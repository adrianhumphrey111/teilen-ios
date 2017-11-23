//
//  ActionCollectionViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/21/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

protocol PostActionDelegate {
    func pushPostViewController( vc : UIViewController)
    func performUpdatesForLike()
    func reserveSeat()
    func notifyRider()
}

class ActionCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var roundedBackgroundView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var post : Post!
    
    var delegate : PostActionDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundedBackgroundView.backgroundColor = .white
        let radius = self.frame.height / 6
        
        roundedBackgroundView.layer.cornerRadius = radius
    }
    
    @IBAction func likeAction(_ sender: Any) {
        print("Like")
        if ( self.post?.isLiked )!{
            Network.shared.unLikePost(postKey: (post?.postKey)!)
            self.post?.unlike()
           // self.likeLabel.text = post?.likeCountString
           // self.likeButtonLabel.setTitle("Like", for: .normal)
        }else{
            Network.shared.likePost(postKey: (post?.postKey)!)
            self.post?.like()
            //self.likeLabel.text = post?.likeCountString
           // self.likeButtonLabel.setTitle("UnLike", for: .normal)
        }
        print(self.post.likeCount)
        delegate.performUpdatesForLike()
    }

    @IBAction func commentAction(_ sender: Any) {
        print("Comment")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier :"Trip") as! TripViewController
        vc.post = self.post
        vc.commenting = true
        vc.comments = self.post?.comments
        delegate.pushPostViewController( vc: vc )
    }
    
    @IBAction func shareAction(_ sender: Any) {
        print("share")
    }
}
