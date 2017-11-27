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
        riderButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        riderButton.setTitleColor(.white, for: .normal)
        riderButton.setTitle("Notify Rider", for: .normal)
    }

    @IBAction func buttonAction(_ sender: Any) {
        print("Are you sure you woul like to notify rider?")
        delegate?.notifyRider()
    }
}
