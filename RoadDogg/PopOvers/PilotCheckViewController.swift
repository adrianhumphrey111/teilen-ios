//
//  PilotCheckViewController.swift
//  Teilen
//
//  Created by Adrian Humphrey on 12/5/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

protocol PilotDelegate {
    func showPilotScreen()
}

class PilotCheckViewController: UIViewController {
    
    var delegate : PilotDelegate?

    @IBOutlet weak var noemailButton: UIButton!
    @IBOutlet weak var continuebutton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test aahumphrey@pipeline.sbcc.edu and belentorres@umail.ucsb.edu
        continuebutton.setTitle("Continue", for: .normal)
        continuebutton.setTitleColor(.white, for: .normal)
        continuebutton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        continuebutton.layer.cornerRadius = 8
        
        noemailButton.setTitle("I Do Not Have One", for: .normal)
        noemailButton.setTitleColor(.white, for: .normal)
        noemailButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        noemailButton.layer.cornerRadius = 8
    }

    @IBAction func notifyAction(_ sender: Any) {
        self.view.endEditing( true )
        delegate?.showPilotScreen()
        
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if ( ( isValidEmail(testStr: self.emailTextField.text!) ) && ( isSantaBarbaraEmail(email: self.emailTextField.text!) ) ) {
            RealmManager.shared.setStudentEmail(email: self.emailTextField.text!)
            self.view.endEditing( true )
            self.dismiss(animated: true, completion: nil)
        }
        else{
            //Show perment lay over to keep them out of the app.
            self.emailTextField.text = ""
            self.emailTextField.placeholder = "Not Valid School Email"
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isSantaBarbaraEmail(email: String) -> Bool{
        let school = email.components(separatedBy: "@")[1]
        return school == "pipeline.sbcc.edu" || school == "umail.ucsb.edu" ? true : false
    }
}
