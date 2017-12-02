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
    
 
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var roundedBackgroundView: UIView!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var delegate : PostActionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        roundedBackgroundView.backgroundColor = .white        
        roundedBackgroundView.layer.cornerRadius = 8
        
        //Make profile image round
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        //Set Options image
        var optionsImage : UIImage = UIImage(named: "Option")!
        optionButton.setImage(optionsImage, for: .normal)
        
    }

    @IBAction func optionAction(_ sender: Any) {
        delegate?.showOptions()
    }
}


