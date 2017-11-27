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

    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var currentTripLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .white
        
        currentTripLabel.text = "No Current Trip"
    }

    @IBAction func reviewsAction(_ sender: Any) {
        
    }
    
}
