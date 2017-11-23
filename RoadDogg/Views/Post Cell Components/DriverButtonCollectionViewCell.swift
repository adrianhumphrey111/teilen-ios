//
//  DriverButtonCollectionViewCell.swift
//  RoadDogg
//
//  Created by Computer Science on 11/21/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

class DriverButtonCollectionViewCell: UICollectionViewCell, NibReusable {

    var delegate : PostActionDelegate?
    
    @IBOutlet weak var driverButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func buttonAction(_ sender: Any) {
        print("Are you sure that you want to reserve this ride?")
        delegate?.reserveSeat()
    }
}
