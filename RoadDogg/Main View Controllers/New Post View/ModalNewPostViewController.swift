//
//  ModalNewPostViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/3/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

enum Status {
    case INITIAL
    case TYPECHOSEN
    case STARTENTERED
    case ENDENTERED
    case DESIREDCHOSEN
    case RADIUSCHOSEN
    case FINISHED
}

enum TypeOfTrip {
    case NONE
    case DRIVING
    case LOOKING
}

class ModalNewPostViewController: UIViewController {
    
    //ENUMS
    var status = Status.INITIAL
    var trip = TypeOfTrip.NONE
    
    //Header View
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var exitButton: UIButton!
    
    //Buttons and label to be animated
    @IBOutlet weak var drivingButton: UIButton!
    @IBOutlet weak var ridingButton: UIButton!
    @IBOutlet weak var startLocationTextField: UITextField!
    @IBOutlet weak var endLocationTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startDestinationLabel: UILabel!
    @IBOutlet weak var endDestinationLabel: UILabel!
    
    //Top Label Constants
    var TOP_BUTTON_HEIGHT : CGFloat!
    var INITIAL_DRIVING_HEIGHT : CGFloat!
    var INITIAL_RIDING_HEIGHT : CGFloat!
    
    //Keyboard Check
    var isKeyboardShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the local label height
        TOP_BUTTON_HEIGHT = 50
        INITIAL_DRIVING_HEIGHT = view.bounds.height / 3
        INITIAL_RIDING_HEIGHT = INITIAL_DRIVING_HEIGHT + 45
        
        //Set Up All Initial views
        setInitialPositions()
        
        //Set up notificaiton for when keyboard is shown
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        //Set up notificaiton for when keyboard is hidden
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            isKeyboardShowing = notification.name == Notification.Name.UIKeyboardWillShow
        }
    }
    
    func setInitialPositions(){
        //set up the UI
        nextButton.layer.cornerRadius = 8.0
        nextButton.layer.masksToBounds = true
        
        //Driving and Riding buttons
        drivingButton.center.y = INITIAL_DRIVING_HEIGHT
        drivingButton.center.x = view.center.x
        ridingButton.center.y = INITIAL_RIDING_HEIGHT
        ridingButton.center.x = view.center.x
        
        
        //Set TextFields off the screen
        startLocationTextField.center.x -= self.view.bounds.width
        startLocationTextField.frame.size.width = self.view.frame.width - 40
        endLocationTextField.center.x -= self.view.bounds.width
        endLocationTextField.frame.size.width = self.view.frame.width - 40
        
        //Labels
        startDestinationLabel.center.x -= self.view.bounds.width
        endDestinationLabel.center.x -= self.view.bounds.width
        
        //Hide Next Button
        nextButton.isHidden = true
        
        //Hide BAck Button
        backButton.isHidden = true
        
        //Set Up Profile Image View
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.backgroundColor = .black
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }

    //Set the selected Trip Button to the top of the screen and disable the button
    func animateTopButtonUP(button: String){
        switch button {
        case "driving":
            //Set the driving button to the top and disable the button
            UIView.animate(withDuration: 0.5) {
                self.drivingButton.center.y = self.TOP_BUTTON_HEIGHT
            }
            self.drivingButton.isUserInteractionEnabled = false
        case "riding":
            //Set the riding button to the top and disable the button
            UIView.animate(withDuration: 0.5) {
                self.ridingButton.center.y = self.TOP_BUTTON_HEIGHT
            }
            self.ridingButton.isUserInteractionEnabled = false
        default:
            //Do nothing
            return
        }
    }
    
    //Set the selected Trip Button back to the original spot on the screen
    func animateTopButtonDOWN(button: String){
        switch button {
        case "driving":
            //Set the driving button to the top and disable the button
            UIView.animate(withDuration: 0.5) {
                self.drivingButton.center.y = self.INITIAL_DRIVING_HEIGHT
            }
            self.drivingButton.isUserInteractionEnabled = false
        case "riding":
            //Set the riding button to the top and disable the button
            UIView.animate(withDuration: 0.5) {
                self.ridingButton.center.y = self.INITIAL_RIDING_HEIGHT
            }
            self.ridingButton.isUserInteractionEnabled = false
        default:
            //Do nothing
            return
        }
    }
    
    //Animate the object OFF the screen
    func animateOFF(obj: String){
        switch obj{
        case "drivingButton":
            //Animate the driving button off screen
            UIView.animate(withDuration: 0.5) {
                self.drivingButton.center.x -= self.view.bounds.width
            }
        case "ridingButton":
            //Animate the riding Button off the screen
            UIView.animate(withDuration: 0.5) {
                self.ridingButton.center.x -= self.view.bounds.width
            }
        case "startDestination":
            UIView.animate(withDuration: 0.5) {
                self.startLocationTextField.center.x -= self.view.bounds.width
                self.startDestinationLabel.center.x -= self.view.bounds.width
            }
        case "startDestination":
            UIView.animate(withDuration: 0.5) {
                self.endLocationTextField.center.x -= self.view.bounds.width
                self.endDestinationLabel.center.x -= self.view.bounds.width
            }

        default:
            //Do Nothing
            return
        }
    }
    
    //Animate the object ON the screen
    func animateON(obj: String){
        switch obj{
        case "drivingButton":
            //Animate the driving button off screen
            UIView.animate(withDuration: 0.5) {
                self.drivingButton.center.x += self.view.bounds.width
            }
        case "ridingButton":
            //Animate the riding Button off the screen
            UIView.animate(withDuration: 0.5) {
                self.ridingButton.center.x += self.view.bounds.width
            }
        case "startDestination":
            //Animate Start text Field on
            UIView.animate(withDuration: 0.5) {
                self.startLocationTextField.center.x = self.view.center.x
                self.startDestinationLabel.center.x = self.view.center.x
            }
        case "endDestination":
            //Animate Start text Field on
            UIView.animate(withDuration: 0.5) {
                self.endLocationTextField.center.x = self.view.center.x
                self.endLocationTextField.center.x = self.view.center.x
            }
            
        default:
            //Do nothing
            return
        }
    }
    
    @IBAction func exitAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ridingAction(_ sender: Any) {
        //Set the status of the post
        status = Status.TYPECHOSEN
        trip = TypeOfTrip.LOOKING
        
        //Animation
        animateTopButtonUP(button: "riding")
        animateOFF(obj: "drivingButton")
        animateON(obj: "startDestination")
        
        //Show back button
        self.backButton.isHidden = false
        nextButton.isHidden = false
        
    }
    
    
    @IBAction func drivingAction(_ sender: Any) {
        //Set the status of the post
        status = Status.TYPECHOSEN
        trip = TypeOfTrip.DRIVING
        
        //Animation
        animateTopButtonUP(button: "driving")
        animateOFF(obj: "ridingButton")
        animateON(obj: "startDestination")
        
        //Show back button
        self.backButton.isHidden = false
        nextButton.isHidden = false
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        if(status == Status.STARTENTERED){
            //Animate the end destination onto the screen
            animateON(obj: "endDestination")
            animateOFF(obj: "startDestination")
        }
        
    }

    @IBAction func backAction(_ sender: Any) {
        
        //Hide the key board if it is showing
        if isKeyboardShowing {
            startLocationTextField.endEditing( true )
            endLocationTextField.endEditing( true )
        }
        
        if(status == Status.TYPECHOSEN){
            
            if(trip == TypeOfTrip.DRIVING){
                //Animate Riding back on screen
                self.animateON(obj: "ridingButton")
                animateTopButtonDOWN(button: "driving")
                self.drivingButton.isUserInteractionEnabled = true
            }
            else{
                //Animate Driving back on screen
                self.animateON(obj: "drivingButton")
                animateTopButtonDOWN(button: "riding")
                self.ridingButton.isUserInteractionEnabled = true
            }
            
            //Hide the back button , next Button since we are at the begining
            self.backButton.isHidden = true
            self.nextButton.isHidden = true
            
            animateOFF(obj: "startDestination")
            
            //SEt Status
            status = Status.INITIAL

        }
    }
}
