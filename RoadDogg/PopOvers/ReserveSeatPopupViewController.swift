//
//  ReserveSeatPopupViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/22/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import SearchTextField


protocol PopupDelegate {
    func goToPaymentController()
    func logout()
}
class ReserveSeatPopupViewController: UIViewController {
    
    //Buttons and labels
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var startAddressTextField: SearchTextField!
    //Trip informaion
    var price : Int!
    var postKey : String!
    var booked = false
   
    var startLocation : Address!
    
    var delegate : PopupDelegate?
    
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
        let dollarAmount = self.price / 100
        let amountString = "$\(dollarAmount)"
        priceLabel.text = amountString
        
        //Hide start Location
        self.startAddressTextField.isHidden = true
        
        //Set selectors for textfields
        startAddressTextField.addTarget(self, action: #selector(textStartFieldDidChange), for: UIControlEvents.editingChanged)
        
        //Start Location TExt Field
        startAddressTextField.theme = SearchTextFieldTheme.darkTheme()
        startAddressTextField.theme.font = UIFont.systemFont(ofSize: 20)
        startAddressTextField.theme.fontColor = UIColor.black
        startAddressTextField.theme.bgColor = UIColor.white
        startAddressTextField.theme.borderColor = UIColor.black
        startAddressTextField.theme.separatorColor = UIColor.black
        startAddressTextField.theme.cellHeight = 50
        startAddressTextField.maxNumberOfResults = 4
        startAddressTextField.maxResultsListHeight = 200
        startAddressTextField.minCharactersNumberToStartFiltering = 2
        
        //Handle What happens when pressed
        startAddressTextField.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.startAddressTextField.text = item.title
            self.startLocation = item.address! as! Address
        }

    }
    
    @IBAction func reserveAction(_ sender: Any) {
        //Check if the user has their payment verified
        if ( RealmManager.shared.selfUser!.paymentVerified ){
            Network.shared.reserveSeat(postKey: self.postKey).then{ result -> Void in
                let success = result["success"] as! Bool

                if ( success ){
                    //The driver was successfully notified
                    self.priceLabel.text = "Driver Notified"
                    self.textView.text = "You will get a notification when the driver accepts your friend request."
                    self.cancelButton.setTitle("Got it!", for: .normal)
                    self.reserveButton.isHidden = true
                    self.heightConstraint.constant = 300
                    
                    self.cancelButton.addTarget(self, action: #selector(self.addStartLocation), for: .touchUpInside)
                    self.booked = true
                    
                }else{
                    //Ride requested already
                    if ( result["error_message"] as? String == "ride already requested" ){
                        //The rider has already attempted to reserve this seat
                        self.priceLabel.text = "Pending"
                        self.textView.text = "You have already sent this driver a request for this ride. The driver has been notified and you will get a notification when they have accepted or denied your reservation request"
                        self.cancelButton.setTitle("Got it!", for: .normal)
                        self.reserveButton.isHidden = true
                        self.heightConstraint.constant = 300
                    }
                    
                    //There are no seats available
                    if ( result["error_message"] as? String == "no seats available" ){
                        //The rider has already attempted to reserve this seat
                        self.priceLabel.text = "No Seats Available"
                        self.textView.text = "This trip has no more available seats. However, we know people are likely to cancel at any time. Add yourself to the waitlist to be notified if and when someone cancels."
                        self.cancelButton.setTitle("Cancel Reservation", for: .normal)
                        self.reserveButton.setTitle("Join Waitlist", for: .normal)
                        self.heightConstraint.constant = 300
                    }
                }
            }
        }
        else{
            //Their payment has not been verified
            self.priceLabel.text = "No Valid Payment"
            self.textView.text = "Please set up a valid form of payment in order to reserve a seat."
            self.reserveButton.setTitle("Enter Payment", for: .normal)
            self.reserveButton.addTarget(self, action: #selector(takeUserToPayment), for: .touchUpInside)
            self.cancelButton.setTitle("Cancel Reservation", for: .normal)
            self.heightConstraint.constant = 350
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        if ( !booked ){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func takeUserToPayment(){
        self.dismiss(animated: true) {
            //Go to a certain tab in the tab bar
            self.delegate?.goToPaymentController()
        }
    }
    
    @objc func addStartLocation(){
        print("got to this prt")
       //Tell the users the driver needs to know where to pick you up from
        self.titleLabel.text = "Pick Up Location"
        self.priceLabel.isHidden = true
        self.startAddressTextField.isHidden = false
        self.textView.text = "Please Enter and Select the address that you would like to be picked up from."
        self.cancelButton.setTitle("Done!", for: .normal)
        self.reserveButton.isHidden = true
        self.heightConstraint.constant = 350
        
        self.cancelButton.addTarget(self, action: #selector(saveStartLocation), for: .touchUpInside)
    }
    
    @objc func textStartFieldDidChange(textField : UITextField){
        Network.shared.GooglePlacesFetch( address: startAddressTextField.text! ).then { results -> Void in
            var newFilter : [SearchTextFieldItem] = []
            for result in results {
                newFilter.append( SearchTextFieldItem( title: result.to_string() , address: result as AnyObject) )
            }
            self.startAddressTextField.filterItems( newFilter )
        }
    }
    
    @objc func saveStartLocation(){
        self.dismiss(animated: true) {
            Network.shared.saveStartLocation(postKey: self.postKey, address: self.startLocation)
        }
    }
}





