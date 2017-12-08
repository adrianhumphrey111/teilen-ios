//
//  StartTripButtonCell.swift
//  Teilen
//
//  Created by Adrian Humphrey on 12/7/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Reusable

protocol StartTripDelegate{
    func startTrip()
}

class StartTripButtonCell: UICollectionViewCell, NibReusable {
    
    var delegate : StartTripDelegate?

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var rounedBackGroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        rounedBackGroundView.layer.cornerRadius = 8
        rounedBackGroundView.layer.borderWidth = 1
        rounedBackGroundView.layer.borderColor = UIColor.black.cgColor

        //startButton.setTitle("<#T##title: String?##String?#>", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        backgroundColor = .clear
    }
    
    @IBAction func startTripAction(_ sender: Any) {
        delegate?.startTrip()
    }
    

}
