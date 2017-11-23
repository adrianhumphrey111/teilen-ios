//
//  ReserveSeatPopupViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/22/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class ReserveSeatPopupViewController: UIViewController {
    
    //Buttons and labels
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    //Trip informaion
    var price : Int!
    var postKey : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up reserve button
        reserveButton.setTitle("Reserve Seat", for: .normal)
        reserveButton.setTitleColor(.white, for: .normal)
        reserveButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        reserveButton.layer.cornerRadius = 8
        
        //Set up Cancel button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        cancelButton.layer.cornerRadius = 8
        
        //Set price label
        print( self.price! )
        let dollarAmount = self.price / 100
        let amountString = "$\(dollarAmount)"
        priceLabel.text = amountString

    }
    
    @IBAction func reserveAction(_ sender: Any) {
        Network.shared.reserveSeat(postKey: self.postKey).then{ success -> Void in
            
            if ( success ){
                //The driver was successfully notified
                self.priceLabel.text = "Driver Notified"
                self.textView.text = "You will get a notification when the driver accepts your friend request."
            }else{
                //The rider has already attempted to reserve this seat
                self.priceLabel.text = "Pending"
                self.textView.text = "You have already sent this driver a request for this ride. The driver has been notified and you will get a notification when they have accepted or denied your reservation request"
            }
            self.cancelButton.setTitle("Got it!", for: .normal)
            self.reserveButton.isHidden = true
            self.heightConstraint.constant = 300
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
