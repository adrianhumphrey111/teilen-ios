//
//  LikeCommentCollectionViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/21/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

class LikeCommentCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var commentLabel: UILabel!

    @IBOutlet weak var likeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
