//
//  FriendCarCollectionViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/27/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

class FriendCarCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var mpgLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var numberOfSeatsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
