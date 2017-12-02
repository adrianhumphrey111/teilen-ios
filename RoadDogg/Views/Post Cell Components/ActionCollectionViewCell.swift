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
    func showKeyboard()
    func shareAction()
    func showOptions()
}

class ActionCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var roundedBackgroundView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var post : Post!
    
    var delegate : PostActionDelegate!
    
    var feed : Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // IConfigure background
        roundedBackgroundView.backgroundColor = .white
        roundedBackgroundView.layer.cornerRadius = 8
        backgroundColor = .clear
        
        // Configure Like Button
        likeButton.setTitle("Like", for: .normal)
        likeButton.setTitleColor(.gray, for: .normal)
        
        // Configure comment button
        commentButton.setTitle("Comment", for: .normal)
        commentButton.setTitleColor(.gray, for: .normal)
        
        // Configure share button
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.gray, for: .normal)

    }
    
    @IBAction func likeAction(_ sender: Any) {
        print("Like")
        if ( self.post?.isLiked )!{
            Network.shared.unLikePost(postKey: (post?.postKey)!)
            self.post?.unlike()
            likeButton.setTitle("Like", for: .normal)
        }else{
            Network.shared.likePost(postKey: (post?.postKey)!)
            self.post?.like()
            likeButton.setTitle("Unlike", for: .normal)
        }
        print(self.post.likeCount)
        delegate.performUpdatesForLike()
    }

    @IBAction func commentAction(_ sender: Any) {
        if ( feed == false ){
            delegate?.showKeyboard()
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier :"Trip") as! TripViewController
            vc.tripArray.append( self.post )
            vc.tripArray += self.post.comments.comments
            vc.commenting = true
            delegate.pushPostViewController( vc: vc )
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        delegate.shareAction()
        
    }
}
