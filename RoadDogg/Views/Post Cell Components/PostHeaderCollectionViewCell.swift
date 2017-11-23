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
    @IBOutlet weak var roundedBackgroundView: UIView!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundedBackgroundView.backgroundColor = .white
        let radius = self.frame.height / 6
        
        roundedBackgroundView.layer.cornerRadius = radius
        
        
    }

}
