//
//  ReserveSeatPopupViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/22/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class ReserveSeatPopupViewController: UIViewController {
    
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var reserveButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up reserve button
        reserveButton.setTitle("Reserve Seat", for: .normal)
        reserveButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)

    }
    
    @IBAction func reserveAction(_ sender: Any) {
        print("Reserve this seat")
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
