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
    @IBOutlet weak var usernameLabel: UILabel!
    
    let color = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
    
    
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
        
    }
}
