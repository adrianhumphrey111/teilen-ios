//
//  CommentViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/31/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class CommentViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textAreaView: UIView!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var comment: Comment!
    
}
