//
//  RideButtonCollectionViewCell.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/21/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

class RideButtonCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var riderButton: UIButton!
    var delegate : PostActionDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func buttonAction(_ sender: Any) {
        print("Are you sure you woul like to notify rider?")
        delegate?.notifyRider()
    }
}
