//
//  ProfileHeaderCollectionViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/24/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage

class ProfileHeaderCollectionViewCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        
        // Profile Image
        userProfileImageView.backgroundColor = .black
        userProfileImageView.layer.masksToBounds = false
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height/2
        userProfileImageView.clipsToBounds = true
        userProfileImageView.image = RealmManager.shared.loadImage(fileName: RealmManager.shared.selfUser!.imageFileName)
        
        //Car Image
        carImageView.backgroundColor = .black
        carImageView.layer.masksToBounds = false
        carImageView.layer.cornerRadius = carImageView.frame.height/2
        carImageView.clipsToBounds = true
        
        //Left Side
        firstNameLabel.text = RealmManager.shared.selfUser!.firstName
        firstNameLabel.center.x = userProfileImageView.center.x
        editButton.center.x = firstNameLabel.center.x
        
        //Right Side
        carLabel.text = RealmManager.shared.selfUser!.car == nil ? "None" : RealmManager.shared.selfUser!.car?.model
        carLabel.center.x = carImageView.center.x
        changeButton.center.x = carLabel.center.x
        
        //Round the corners of the notifications
        self.layer.cornerRadius = 8
    }


    @IBAction func editAction(_ sender: Any) {
        
    }
    
    
    @IBAction func changeCarAction(_ sender: Any) {
        
    }
    
}
