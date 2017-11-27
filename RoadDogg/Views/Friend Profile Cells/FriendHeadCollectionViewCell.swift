//
//  FriendHeadCollectionViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/27/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

class FriendHeadCollectionViewCell: UICollectionViewCell, NibReusable {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addFrindButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    @IBOutlet weak var numberOfFriendsLabel: UILabel!
    @IBOutlet weak var numberOfPostsLabel: UILabel!
    
    @IBOutlet weak var roundBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        
        //Set Labels while the server fetches the user
        numberOfFriendsLabel.text = ""
        numberOfPostsLabel.text = ""
        numberOfTripsLabel.text = ""
    }
    
    @IBAction func addFriendAction(_ sender: Any) {
        
    }
    
    @IBAction func messageUserAction(_ sender: Any) {
        
    }
    
}
