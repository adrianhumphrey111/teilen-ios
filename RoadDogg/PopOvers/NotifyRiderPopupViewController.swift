//
//  NotifyRiderPopupViewController.swift
//  Teilen
//
//  Created by Adrian Humphrey on 12/8/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

protocol NotifyRiderDelegate {
    func notifyRiderFromPopup()
}

class NotifyRiderPopupViewController: UIViewController {
    
    var delegate : NotifyRiderDelegate?

    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up Cancel button
        cancelButton.setTitle("Got it!", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        cancelButton.layer.cornerRadius = 8

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
