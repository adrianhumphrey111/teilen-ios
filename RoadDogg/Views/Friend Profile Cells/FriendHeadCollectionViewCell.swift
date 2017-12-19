//
//  FriendHeadCollectionViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/27/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

protocol ProfileActionDelegate{
    func showSettings()
    func showPayments()
}

protocol ShowImagePickerDelegate {
    func showImagePicker()
}

class FriendHeadCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addFrindButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    @IBOutlet weak var numberOfFriendsLabel: UILabel!
    @IBOutlet weak var numberOfPostsLabel: UILabel!
    @IBOutlet weak var addFriendImageView: UIImageView!
    
    var messageImage = UIImage(named: "Message")
    var addFriendImage = UIImage(named: "Add_Friend")
    var unFriendImage = UIImage(named: "Un_Friend")
    var settingsImage = UIImage(named: "Gray_Settings")
    
    var status : String!
    
    let color = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
    
    var userKey : String!
    
    var isOwnProfile = false
    
    var delegate : ProfileActionDelegate?
    var imageDelegate : ShowImagePickerDelegate?
    
    @IBOutlet weak var roundBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //Resize message button
        messageButton?.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        //Background
        backgroundColor = .clear
        roundBackgroundView.backgroundColor = .white
        roundBackgroundView.layer.cornerRadius = 8
        
        // Set Up Profile Image
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        //Add Friend
        addFrindButton.layer.cornerRadius = 8
        addFrindButton.contentHorizontalAlignment = .left
        addFrindButton.titleEdgeInsets.left = 10
        
        //Set Labels while the server fetches the user
        numberOfFriendsLabel.text = ""
        numberOfPostsLabel.text = ""
        numberOfTripsLabel.text = ""
        
        //Message button
        if ( isOwnProfile ){
            addFrindButton.setTitle("Edit Profile", for: .normal)
            addFrindButton.layer.borderColor = UIColor.black.cgColor
            messageButton.setImage( settingsImage, for: .normal)
        }else{
            messageButton.setImage( messageImage, for: .normal)
        }
        
    }
    
    @IBAction func addFriendAction(_ sender: Any) {
        print("Toggling Now")
        if ( isOwnProfile ){
            print("show the edit profile whatever it may be")
            delegate?.showSettings()
        }else{
            toggleFriendButton()
        }
        
    }
    
    @IBAction func messageUserAction(_ sender: Any) {
        if ( isOwnProfile){
            //Show payments
            delegate?.showPayments()
        }
        else{
            //show a page to message the user
        }
    }
    
    func toggleFriendButton(){
        //Friend button is unfriend to addfriend
        //NotFriend button is addfriend to reqeusted
        //Requested button is requested to addfriend
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
        addFrindButton.setTitle("Unfriend", for: .normal)
        addFrindButton.setTitleColor(.white, for: .normal)
        addFrindButton.contentHorizontalAlignment = .left
        addFrindButton.titleEdgeInsets.left = 10
        addFrindButton.backgroundColor = color
        addFriendImageView.image = unFriendImage
    }
    
    func buttonToRequested(){
        addFrindButton.setTitle("Requested", for: .normal)
        addFrindButton.setTitleColor(.white, for: .normal)
        addFrindButton.backgroundColor = color
        addFrindButton.contentHorizontalAlignment = .center
        addFrindButton.titleEdgeInsets.left = 0
        addFriendImageView.image = nil
        
    }
    
    func buttonToAddFriend(){
        addFrindButton.layer.borderColor = color.cgColor
        addFrindButton.backgroundColor = .white
        addFrindButton.layer.borderWidth = 1
        addFrindButton.contentHorizontalAlignment = .left
        addFrindButton.titleEdgeInsets.left = 10
        addFrindButton.setTitleColor(color, for: .normal)
        addFrindButton.setTitle("Add Friend", for: .normal)
        addFriendImageView.image = addFriendImage
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
