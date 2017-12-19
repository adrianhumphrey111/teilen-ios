//
//  FriendInfoCollectionViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/27/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

class FriendInfoCollectionViewCell: UICollectionViewCell, NibReusable {

   // @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var currentTripLabel: UILabel!
    @IBOutlet weak var roundBackgroundView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        currentTripLabel.text = "No Current Trip"
        currentTripLabel.textColor = .gray
        
        //Review Button
//        reviewsButton.setTitleColor(.white, for: .normal)
//        reviewsButton.setTitle("Reviews", for: .normal)
//        reviewsButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
//        reviewsButton.layer.cornerRadius = 8
    }

    @IBAction func reviewsAction(_ sender: Any) {
        print("Show a modal review controller. very simple")
    }
    
}
