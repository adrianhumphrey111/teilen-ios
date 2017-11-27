//
//  NotificationCollectionViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/23/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

class RequestNotificationCollectionViewCell.swift: UICollectionViewCell, NibReusable {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var labelContraint: NSLayoutConstraint!
    @IBOutlet weak var acceptButton: UIButton!
    
    var type : String!
    
    @IBOutlet weak var denyButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Accept Button
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        acceptButton.layer.cornerRadius = 8
        
        //Deny Button
        let color = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        denyButton.setTitle("Cancel", for: .normal)
        denyButton.setTitleColor(color, for: .normal)
        denyButton.backgroundColor = .white
        denyButton.layer.cornerRadius = 8
        
    }

    @IBAction func denyAction(_ sender: Any) {
        
    }
    
    
    @IBAction func acceptAction(_ sender: Any) {
        
    }
}
