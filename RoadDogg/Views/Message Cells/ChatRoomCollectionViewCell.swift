//
//  ChatRoomCollectionViewCell.swift
//  Teilen
//
//  Created by Adrian Humphrey on 1/9/18.
//  Copyright © 2018 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

class ChatRoomCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lastMessageLabel.textColor = .gray
    }

}
