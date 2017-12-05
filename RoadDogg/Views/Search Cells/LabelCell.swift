//
//  LabelCell.swift
//  Teilen
//
//  Created by Adrian Humphrey on 12/4/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

class LabelCell: UICollectionViewCell , NibReusable{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    let color = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
    
    var status : String = ""
    
    var userKey : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        
        // Profile Image
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        
        //Label full name
        
        //Username label
        
        //Ad friend button
        addFriendButton.layer.borderColor = color.cgColor
        addFriendButton.backgroundColor = .white
        addFriendButton.layer.borderWidth = 1
        addFriendButton.layer.cornerRadius = 8
        addFriendButton.setTitleColor(color, for: .normal)
        addFriendButton.setTitle("Add Friend", for: .normal)
        
    }

    @IBAction func addFriendAction(_ sender: Any) {
        switch status{
        case "friend":
            //The button is unfriend, change is to add friend
            self.buttonToAddFriend()
            status = "notFriend"
            removeFriend()
        case "requested":
            //The button is requested, remove the request, and go to add Afriend
            self.buttonToAddFriend()
            status = "notFriend"
            removeRequest()
        default:
            //The button is add friend so change to requested
            self.buttonToRequested()
            status = "requested"
            requestFriend()
        }
    }
    
    func buttonToUnfriend(){
        addFriendButton.setTitle("Unfriend", for: .normal)
        addFriendButton.setTitleColor(.white, for: .normal)
        addFriendButton.backgroundColor = color
    }
    
    func buttonToRequested(){
        addFriendButton.setTitle("Requested", for: .normal)
        addFriendButton.setTitleColor(.white, for: .normal)
        addFriendButton.backgroundColor = color
        addFriendButton.contentHorizontalAlignment = .center
        addFriendButton.titleEdgeInsets.left = 0
        
    }
    
    func buttonToAddFriend(){
        addFriendButton.layer.borderColor = color.cgColor
        addFriendButton.backgroundColor = .white
        addFriendButton.layer.borderWidth = 1
        addFriendButton.setTitleColor(color, for: .normal)
        addFriendButton.setTitle("Add Friend", for: .normal)
    }
    
    func requestFriend(){
        Network.shared.requestFriend(friendKey: self.userKey)
    }
    
    func removeFriend(){
        Network.shared.removeFriend(friendKey: self.userKey)
    }
    
    func removeRequest(){
        Network.shared.removeRequest(friendKey: self.userKey)
    }
}
