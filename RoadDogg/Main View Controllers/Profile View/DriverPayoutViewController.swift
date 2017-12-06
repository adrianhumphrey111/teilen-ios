//
//  DriverPayoutViewController.swift
//  Teilen
//
//  Created by Adrian Humphrey on 12/5/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import Eureka

class DriverPayoutViewController: FormViewController {
    
    //Set the user that is saved in the database
    var user = RealmManager.shared.selfUser!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Update these values
        
        let dict = form.values()
        //Birthdate
        let date = dict["birthdate"] as? Date //This is a date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date!)
        var dob = result.components(separatedBy: ".")
        let dobDate = dob[0]
        let dobMonth = dob[1]
        let dobYear = dob[2]
        
        //Last four of social
        let lastFour = dict["lastfour"]
        
        let creditCardObj = dict["creditCard"] as! CreditCardInfo
        let addressObj = dict["address"] as! PostalAddress
        
        //Dict to send to the appi
        var legalEntity : [String : Any] = [:]
        var dobDict : [String : Any] = [:]
        var address : [String : Any] = [:]
        var creditCard : [String : Any ] = [:]
        
        //Set up birthdate
        dobDict["day"] = dobDate
        dobDict["month"] = dobMonth
        dobDict["year"] = dobYear
        legalEntity["dob"] = dobDict
        
        //Set up address
        address["city"] = addressObj.city!
        address["state"] = addressObj.state!
        address["postal_code"] = addressObj.postalCode!
        address["line1"] = addressObj.street!
        legalEntity["address"] = address
        
        //Set up the credit card
        let exp = creditCardObj.expiration!.components(separatedBy: "-")
        creditCard["number"] = creditCardObj.creditCardNumber!
        creditCard["cvv"] = creditCardObj.cvv!
        creditCard["exp_month"] = exp[0]
        creditCard["exp_year"] = exp[1]
        legalEntity["credit_card"] = creditCard
        
        //Set SSN
        legalEntity["last_four"] = lastFour as! String
        
        //Set Stripe Id
        legalEntity["stripe_id"] = RealmManager.shared.selfUser!.stripeAccountId
        
        print(legalEntity)
        
        Network.shared.addDriverPayoutInfo(dict: legalEntity, dob: result, creditCardInfo: creditCardObj, address:  addressObj)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backItem = UIBarButtonItem(title: "Done", style: .done, target: nil, action: nil)
        self.navigationController?.navigationItem.backBarButtonItem = backItem
        
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the title to the settings page
        self.title = "Driver Payout"
        
        form +++ Section("Information Needed to Payout")
            <<< PasswordRow(){ row in
                row.title = "Last Four of SSN"
                row.tag = "lastfour"
            }
        
            +++ Section("Birth Date")
            <<< DateRow(){
                $0.title = "Birth Date"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
                $0.tag = "birthdate"
            }
            
            +++ Section("Debit Card to Recieve Funds")
            <<< CreditCardRow() {
                $0.tag = "creditCard"
                $0.numberSeparator = "-"
                $0.expirationSeparator = "-"
                $0.maxCreditCardNumberLength = 16
                $0.maxCVVLength = 3
            }
            
            +++ Section("Billing Address")
            <<< PostalAddressRow() {
                $0.tag = "address"
                $0.streetPlaceholder = "Street"
                $0.statePlaceholder = "State"
                $0.cityPlaceholder = "City"
                $0.countryPlaceholder = "Country"
                $0.postalCodePlaceholder = "Zip code"
            }

    }


}
