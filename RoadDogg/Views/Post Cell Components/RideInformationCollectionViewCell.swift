//
//  RideInformationCollectionViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/21/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

class RideInformationCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var seatsAvailableLabel: UILabel!
    
    @IBOutlet weak var startToEndLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var seatsAvailableIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        seatsAvailableIcon.image = UIImage(named: "Seats_Available")
    }

}
