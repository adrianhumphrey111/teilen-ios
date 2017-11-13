//
//  FriendProfileHeadViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/9/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class FriendProfileHeadViewCell: UICollectionViewCell {
    
    @IBOutlet weak var carStackView: UIStackView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    @IBOutlet weak var tripsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingNumberLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var mpgLabel: UILabel!
    
    @IBAction func postAction(_ sender: Any) {
        print("Switch to show post if not already")
    }
    
    @IBAction func reviewAction(_ sender: Any) {
        print("Switch to show reviews if not already")
    }
}
