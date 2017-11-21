//
//  PostHeaderCollectionViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/20/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

class PostHeaderCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var optionButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
