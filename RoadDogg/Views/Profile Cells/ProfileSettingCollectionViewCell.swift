//
//  ProfileSettingCollectionViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/24/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

class ProfileSettingCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var settingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = .black
        backgroundColor = .white
        
        //Label
        settingLabel.textColor = UIColor.black
    }

}
