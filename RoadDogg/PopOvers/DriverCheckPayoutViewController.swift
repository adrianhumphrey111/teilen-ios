//
//  DriverCheckPayoutViewController.swift
//  Teilen
//
//  Created by Adrian Humphrey on 12/5/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

protocol CheckDriverDelegate{
    func showDriverPayout()
}

class DriverCheckPayoutViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var delegate : CheckDriverDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        continueButton.layer.cornerRadius = 8
        
        //Set up Cancel button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        cancelButton.layer.cornerRadius = 8
        
        var text = "When making a driving post, riders will be able to request a reservation in your car. Upon your approval, they will be charged the asking price. You will get paid the instant the trip starts. However we need some additional info in order for you to get paid. We only need this once. We still need your:\n"
        if ( RealmManager.shared.selfUser!.lastFour == nil ){
            text += "Last Four SSN.\n"
        }
        
        if ( RealmManager.shared.selfUser!.billingAddress == nil ){
            text += "Billing Address. \n"
        }
        
        if ( RealmManager.shared.selfUser!.dateOfBirth == nil ){
            text += "Birthdate. \n"
        }
        
        if ( RealmManager.shared.selfUser!.currentCard == nil ){
            text += "Debit Card For Payout."
        }
        
        //Tell the user what we still need from them in order to be paid out
        textView.text = text
    }

    @IBAction func continueAction(_ sender: Any) {
        print("continue button was pressed")
        self.dismiss(animated: true) {
            self.delegate?.showDriverPayout()
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
    }
    
}
