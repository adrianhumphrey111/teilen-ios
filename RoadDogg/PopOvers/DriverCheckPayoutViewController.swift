//
//  DriverCheckPayoutViewController.swift
//  Teilen
//
//  Created by Adrian Humphrey on 12/5/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class DriverCheckPayoutViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton.setTitle("YES", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        continueButton.layer.cornerRadius = 8
        
        //Set up Cancel button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        cancelButton.layer.cornerRadius = 8
    }

    @IBAction func continueAction(_ sender: Any) {
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
    }
    
}
