//
//  CommentCollectionViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/26/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

class CommentCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeStamp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //Text View
        textView.isUserInteractionEnabled = false
        
        //Time stamp
        timeStamp.textColor = .gray
        
        //background
        backgroundColor = .white
        self.layer.cornerRadius = 8
        
        //Profile Image View
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        
    }

}
