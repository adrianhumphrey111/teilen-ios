//
//  ModalNewPostViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/3/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import DateTimePicker
import SearchTextField

enum Status {
    case INITIAL
    case TYPECHOSEN
    case STARTENTERED
    case ENDENTERED
    case DESIREDCHOSEN
    case RADIUSCHOSEN
    case TEXTENTERED
    case FINISHED
}

enum TypeOfTrip {
    case NONE
    case DRIVING
    case LOOKING
}

enum LeaveTime {
    case NONE
    case DEPARTURE
    case ARRIVAL
}

class ModalNewPostViewController: UIViewController {
    
    //ENUMS
    var status = Status.INITIAL
    var trip = TypeOfTrip.NONE
    var leaveTime = LeaveTime.NONE
    
    //Header View
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var exitButton: UIButton!
    
    //Buttons and label to be animated
    @IBOutlet weak var drivingButton: UIButton!
    @IBOutlet weak var ridingButton: UIButton!
    @IBOutlet weak var startLocationTextField: SearchTextField!
    @IBOutlet weak var endLocationTextField: SearchTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startDestinationLabel: UILabel!
    @IBOutlet weak var endDestinationLabel: UILabel!
    @IBOutlet weak var setTimeLabel: UILabel!
    @IBOutlet weak var departureButton: UIButton!
    @IBOutlet weak var arrivalButton: UIButton!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!

    
    //Top Label Constants
    var TOP_BUTTON_HEIGHT : CGFloat!
    var INITIAL_DRIVING_HEIGHT : CGFloat!
    var INITIAL_RIDING_HEIGHT : CGFloat!
    
    //Keyboard Check
    var isKeyboardShowing = false
    
    //Bottom Constraint for next Button
    var bottomConstraint: NSLayoutConstraint!
    
    //Frame for TextView
    var textViewFrame: CGRect!
    
    //Trip Object To Send to Server
    var tripObject = Trip()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set selectors for textfields
        startLocationTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        endLocationTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        
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
    
    @objc func textFieldDidChange(textField : UITextField){
        print("The textfield did change")
        Network.shared.GooglePlacesFetch( address: startLocationTextField.text! ).then { results -> Void in
            var newFilter : [SearchTextFieldItem] = []
            //Set the filter results with the results that were returned
            print( "Results from Google => ")
            for result in results {
                newFilter.append( SearchTextFieldItem( title: result.to_string() ) )
            }
            self.startLocationTextField.filterItems( newFilter )
            self.endLocationTextField.filterItems( newFilter )
        }
    }
    
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            isKeyboardShowing = notification.name == Notification.Name.UIKeyboardWillShow
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
            
            //Set Up Text Field Frame
            textViewFrame = CGRect(x: 0, y: view.bounds.origin.y, width: view.bounds.size.width, height: view.bounds.size.height - 136 - keyboardFrame.height)
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                //Do Nothing
            })
        }
    }
    
    func setInitialPositions(){
        //Hide Next Button
        nextButton.isHidden = true
        
        //Hide BAck Button
        backButton.isHidden = true
        
        //Set Buttons Off Screen
        drivingButton.center.y = INITIAL_DRIVING_HEIGHT
        drivingButton.center.x = view.center.x
        
        ridingButton.center.y = INITIAL_RIDING_HEIGHT
        ridingButton.center.x = view.center.x
        
        departureButton.center.y = INITIAL_DRIVING_HEIGHT - 45
        departureButton.center.x += self.view.bounds.width
        
        arrivalButton.center.y = INITIAL_RIDING_HEIGHT - 45
        arrivalButton.center.x += self.view.bounds.width
        
        postTextView.center.y = INITIAL_RIDING_HEIGHT
        postTextView.center.x += self.view.bounds.width * 2
        
        
        //Set TextFields off the screen
        startLocationTextField.center.x += self.view.bounds.width * 2
        startLocationTextField.frame.size.width = self.view.frame.width - 40
        endLocationTextField.center.x += self.view.bounds.width * 2
        endLocationTextField.frame.size.width = self.view.frame.width - 40
        radiusTextField.center.x += self.view.bounds.width * 2
        radiusTextField.frame.size.width = self.view.frame.width - 40
        
        //Set Up TextField AutoComplete START
        startLocationTextField.theme = SearchTextFieldTheme.darkTheme()
        startLocationTextField.theme.font = UIFont.systemFont(ofSize: 12)
        startLocationTextField.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
        startLocationTextField.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        startLocationTextField.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        startLocationTextField.theme.cellHeight = 50
        startLocationTextField.maxNumberOfResults = 4
        startLocationTextField.maxResultsListHeight = 200
        startLocationTextField.minCharactersNumberToStartFiltering = 2
        
        //Set Up TextField AutoComplete END
        endLocationTextField.theme = SearchTextFieldTheme.darkTheme()
        endLocationTextField.theme.font = UIFont.systemFont(ofSize: 12)
        endLocationTextField.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
        endLocationTextField.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        endLocationTextField.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        endLocationTextField.theme.cellHeight = 50
        endLocationTextField.maxNumberOfResults = 4
        endLocationTextField.maxResultsListHeight = 200
        endLocationTextField.minCharactersNumberToStartFiltering = 3
        
        //Handle What happens when pressed
        startLocationTextField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            print("Item at position \(itemPosition): \(item.title)")
            
            // Do whatever you want with the picked item
            self.startLocationTextField.text = item.title
        }
        
        //Handle What happens when pressed
        endLocationTextField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            print("Item at position \(itemPosition): \(item.title)")
            
            // Do whatever you want with the picked item
            self.endLocationTextField.text = item.title
        }
        
        //Labels
        startDestinationLabel.center.x += self.view.bounds.width
        endDestinationLabel.center.x += self.view.bounds.width
        radiusLabel.center.x += self.view.bounds.width
        setTimeLabel.center.x += self.view.bounds.width
        
        //Set Up Text View
        postTextView.center.x -= view.bounds.width
        postTextView.font = UIFont.systemFont(ofSize: 20.0)
        postTextView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        postTextView.placeholder = "What Would You Like To Share. . ."
        postTextView.textColor = UIColor.lightGray
        
        
        //Set Up Profile Image View
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.backgroundColor = .black
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        //Set Up Next Button
        nextButton.layer.cornerRadius = 8.0
        nextButton.layer.masksToBounds = true
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.blue, for: .normal)
        nextButton.backgroundColor = .black
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        //Constraints for next button
        //Set up the input field view and constraints
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: nextButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        bottomConstraint =  NSLayoutConstraint(item: nextButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint(item: nextButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: view.frame.width).isActive = true
        NSLayoutConstraint(item: nextButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 48).isActive = true
        view.addConstraint( bottomConstraint! )
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
        case "departure":
            //Set the riding button to the top and disable the button
            UIView.animate(withDuration: 0.5) {
                self.departureButton.center.y = self.TOP_BUTTON_HEIGHT + 20
            }
            self.departureButton.isUserInteractionEnabled = false
        case "arrival":
            //Set the riding button to the top and disable the button
            UIView.animate(withDuration: 0.5) {
                self.arrivalButton.center.y = self.TOP_BUTTON_HEIGHT + 20
            }
            self.arrivalButton.isUserInteractionEnabled = false
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
            self.drivingButton.isUserInteractionEnabled = true
        case "riding":
            //Set the riding button to the top and disable the button
            UIView.animate(withDuration: 0.5) {
                self.ridingButton.center.y = self.INITIAL_RIDING_HEIGHT
            }
            self.ridingButton.isUserInteractionEnabled = true
        case "departure":
            //Set the riding button to the top and disable the button
            UIView.animate(withDuration: 0.5) {
                self.departureButton.center.y = self.INITIAL_DRIVING_HEIGHT - 45
            }
            self.departureButton.isUserInteractionEnabled = true
        case "arrival":
            //Set the riding button to the top and disable the button
            UIView.animate(withDuration: 0.5) {
                self.arrivalButton.center.y = self.INITIAL_RIDING_HEIGHT - 45
            }
            self.arrivalButton.isUserInteractionEnabled = true
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
                self.startLocationTextField.center.x -= self.view.bounds.width * 2
                self.startDestinationLabel.center.x -= self.view.bounds.width
            }
        case "endDestination":
            UIView.animate(withDuration: 0.5) {
                self.endLocationTextField.center.x -= self.view.bounds.width * 2
                self.endDestinationLabel.center.x -= self.view.bounds.width
            }
        case "arrivalButton":
            UIView.animate(withDuration: 0.5) {
                self.arrivalButton.center.x -= self.view.bounds.width
            }
        case "departureButton":
            UIView.animate(withDuration: 0.5) {
                self.departureButton.center.x -= self.view.bounds.width
            }
        case "setTimeLabel":
            UIView.animate(withDuration: 0.5) {
                self.setTimeLabel.center.x -= self.view.bounds.width
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
                self.endDestinationLabel.center.x = self.view.center.x
                self.endLocationTextField.center.x = self.view.center.x
            }
        case "setTimeButtons":
            //Animate Start text Field on
            UIView.animate(withDuration: 0.5) {
                self.setTimeLabel.center.x = self.view.center.x
                self.departureButton.center.x = self.view.center.x
                self.arrivalButton.center.x = self.view.center.x
            }
        
        default:
            //Do nothing
            return
        }
    }
    
    //Animate the object BACK off the screen in the direction that it came onto the screen
    func animateBACK(obj: String){
        switch obj{
        case "endDestination":
            UIView.animate(withDuration: 0.5) {
                self.endLocationTextField.center.x += self.view.bounds.width * 2
                self.endDestinationLabel.center.x += self.view.bounds.width
            }
        case "startDestination":
            UIView.animate(withDuration: 0.5) {
                self.startLocationTextField.center.x += self.view.bounds.width * 2
                self.startDestinationLabel.center.x += self.view.bounds.width
            }
        case "departure":
            UIView.animate(withDuration: 0.5) {
                self.setTimeLabel.center.x += self.view.bounds.width
                self.departureButton.center.x += self.view.bounds.width
            }
        case "arrival":
            UIView.animate(withDuration: 0.5) {
                self.setTimeLabel.center.x += self.view.bounds.width
                self.arrivalButton.center.x += self.view.bounds.width
            }
        case "desired":
            UIView.animate(withDuration: 0.5) {
                self.departureButton.center.x += self.view.bounds.width
                self.arrivalButton.center.x += self.view.bounds.width
                self.setTimeLabel.center.x += self.view.bounds.width
            }
        default:
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
        
        //Show the keyboard
        startLocationTextField.becomeFirstResponder()
    }
    
    func next(){
        switch self.status{
        case Status.TYPECHOSEN:
            animateON(obj: "endDestination")
            animateOFF(obj: "startDestination")
            endLocationTextField.becomeFirstResponder()
            status = Status.STARTENTERED
        case Status.STARTENTERED:
            animateOFF(obj: "endDestination")
            animateON(obj: "setTimeButtons")
            view.endEditing( true )
            status = Status.ENDENTERED
        case Status.ENDENTERED:
            return
        case Status.DESIREDCHOSEN:
            //Animate off top button
            if (trip == TypeOfTrip.DRIVING ){
                animateOFF(obj: "drivingButton")
            }else{
                animateOFF(obj: "ridingButton")
            }
            
            //Animate off departure/arrival button
            if ( leaveTime == LeaveTime.DEPARTURE ){
                animateOFF(obj: "departureButton")
            }else{
                animateOFF(obj: "arrivalButton")
            }
            
            //animate on the textfield
            animateON(obj: "textField")
            
            //Show the keyboard
            postTextView.becomeFirstResponder()
            
            //Animate Text View in
            UIView.animate(withDuration: 0.5) {
                self.postTextView.frame = self.textViewFrame
            }
            
            //Set Next Title for button
            nextButton.setTitle("Post Trip", for: .normal)
            
            //Set Status
            status = Status.FINISHED

        case Status.FINISHED:
            tripObject.postText = postTextView.text
            view.endEditing( true )
            self.dismiss(animated: true, completion: {
                //Do something with this, idk what yet though, maybe refresh feed
                Network.shared.createPost(trip: self.tripObject)
            })
        default:
            return
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        next()
    }

    @IBAction func backAction(_ sender: Any) {
        
        //Always set Title to next if the user presses back
        nextButton.setTitle("Next", for: .normal)
        
        //Hide the key board if it is showing
        if isKeyboardShowing {
            view.endEditing( true )
        }
        
        switch status{
        case Status.TYPECHOSEN:
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
            
            animateBACK(obj: "startDestination")
            status = Status.INITIAL
            
        case Status.STARTENTERED:
            startLocationTextField.becomeFirstResponder()
            animateBACK(obj: "endDestination")
            animateON(obj: "startDestination")
            status = Status.TYPECHOSEN
            
        case Status.ENDENTERED:
            animateON(obj: "endDestination")
            animateBACK(obj: "desired")
            
            status = Status.STARTENTERED
        case Status.DESIREDCHOSEN:
            if ( leaveTime == LeaveTime.DEPARTURE ){
                animateTopButtonDOWN(button: "departure")
                animateBACK(obj: "arrival")
                status = Status.ENDENTERED
            }else{
                animateTopButtonDOWN(button: "arrival")
                animateBACK(obj: "departure")
                status = Status.ENDENTERED
            }
        case Status.FINISHED:
            UIView.animate(withDuration: 0.5) {
                self.postTextView.frame = CGRect(x: self.view.bounds.size.width, y: self.view.bounds.size.height, width: 0, height: 0)
            }
        default:
            return
            
        }
    }
    
    @IBAction func departureAction(_ sender: Any) {
        leaveTime = LeaveTime.DEPARTURE
        animateOFF(obj: "setTimeLabel")
        animateOFF(obj: "arrivalButton")
        status = Status.DESIREDCHOSEN
        showTimePicker()
    }
    
    @IBAction func arrivalAction(_ sender: Any) {
        leaveTime = LeaveTime.ARRIVAL
        animateOFF(obj: "setTimeLabel")
        animateOFF(obj: "departureButton")
        status = Status.DESIREDCHOSEN
        showTimePicker()
    }
    
    func showTimePicker(){
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = false // to hide time and show only date picker
        picker.completionHandler = { date in
            print(date)
            self.next()
        }
    }
}
