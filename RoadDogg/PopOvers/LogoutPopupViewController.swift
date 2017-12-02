//
//  LogoutPopupViewController.swift
//  Teilen
//
//  Created by Adrian Humphrey on 12/1/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class LogoutPopupViewController: UIViewController {

    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate : SettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set up yes button
        yesButton.setTitle("YES", for: .normal)
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        yesButton.layer.cornerRadius = 8
        
        //Set up Cancel button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        cancelButton.layer.cornerRadius = 8
    }
    
    @IBAction func yesAction(_ sender: Any) {
        delegate?.showStartScreen()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
