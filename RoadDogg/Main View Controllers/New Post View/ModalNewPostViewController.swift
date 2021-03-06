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
    case TIMESHOWN
    case TIMECHOSEN
    case SEATSCHOSEN
    case RATECHOSEN
    case RADIUSPICKED
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

protocol ModalNewPostDelegate{
    func showDriverPayout()
}

class ModalNewPostViewController: UIViewController, CheckDriverDelegate {
    
    //MARK CheckDriverDelegate
    func showDriverPayout(){
        self.dismiss(animated: true) {
            self.delegate?.showDriverPayout()
        }
}


    //Delegate
var delegate : ModalNewPostDelegate?
    
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
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var seatsStackView: UIStackView!
    @IBOutlet weak var seatsLabel: UILabel!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var rateLabel: UILabel!
    
    //Seat buttons
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    
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
    
    //Number of seats that the user has chosen
    var seatsAvailable : Int?
    
    //Universal color
    let color = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
    let disabledColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 0.3)
    
    var user : loggedInUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set user
        self.user = RealmManager.shared.selfUser!
        
        //Set selectors for textfields
        startLocationTextField.addTarget(self, action: #selector(textStartFieldDidChange), for: UIControlEvents.editingChanged)
        endLocationTextField.addTarget(self, action: #selector(textEndFieldDidChange), for: UIControlEvents.editingChanged)
        
        //Set the local label height
        TOP_BUTTON_HEIGHT = 50
        INITIAL_DRIVING_HEIGHT = view.bounds.height / 3
        INITIAL_RIDING_HEIGHT = INITIAL_DRIVING_HEIGHT + 70
        
        //Set up the button looks
        setUpBViewDesigns()
        
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
    
    @objc func textStartFieldDidChange(textField : UITextField){
        Network.shared.GooglePlacesFetch( address: startLocationTextField.text! ).then { results -> Void in
            var newFilter : [SearchTextFieldItem] = []
            for result in results {
                newFilter.append( SearchTextFieldItem( title: result.to_string() , address: result as AnyObject) )
            }
            self.startLocationTextField.filterItems( newFilter )
        }
    }
    
    @objc func textEndFieldDidChange(textField : UITextField){
        Network.shared.GooglePlacesFetch( address: endLocationTextField.text! ).then { results -> Void in
            var newFilter : [SearchTextFieldItem] = []
            for result in results {
                newFilter.append( SearchTextFieldItem( title: result.to_string() , address: result as AnyObject) )
            }
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
    
    func setUpBViewDesigns(){
        
        //Choose seat available buttons
        self.resetAllButtonBackgrounds()
        
        //Driving Button
        drivingButton.backgroundColor = color
        drivingButton.setTitleColor(.white, for: .normal)
        drivingButton.frame.size.width = self.view.frame.size.width - 40
        drivingButton.frame.size.height = 50
        drivingButton.layer.cornerRadius = 8
        
        //RidingButton
        ridingButton.backgroundColor = color
        ridingButton.setTitleColor(.white, for: .normal)
        ridingButton.frame.size.width = self.view.frame.size.width - 40
        ridingButton.frame.size.height = 50
        ridingButton.layer.cornerRadius = 8
        
        //Departure Button
        departureButton.backgroundColor = color
        departureButton.setTitleColor(.white, for: .normal)
        departureButton.frame.size.width = self.view.frame.size.width - 40
        departureButton.frame.size.height = 50
        departureButton.layer.cornerRadius = 8
        
        //Arrival Button
        arrivalButton.backgroundColor = color
        arrivalButton.setTitleColor(.white, for: .normal)
        arrivalButton.frame.size.width = self.view.frame.size.width - 40
        arrivalButton.frame.size.height = 50
        arrivalButton.layer.cornerRadius = 8
        
        //Next Button
        nextButton.backgroundColor = color
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.setTitle("Next", for: .normal)
        nextButton.frame.size.width = self.view.frame.size.width
        nextButton.frame.size.height = 50
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        //Exit Button
        exitButton.setTitleColor(color, for: .normal)
        
        //Back Button
        backButton.setTitleColor(color, for: .normal)
        
        
        
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
        rateTextField.center.x += self.view.bounds.width * 2
        rateTextField.frame.size.width = self.view.frame.width - 40
        
        //Set Up TextField AutoComplete START
        startLocationTextField.theme = SearchTextFieldTheme.darkTheme()
        startLocationTextField.theme.font = UIFont.systemFont(ofSize: 20)
        startLocationTextField.theme.fontColor = UIColor.black
        startLocationTextField.theme.bgColor = UIColor.white
        startLocationTextField.theme.borderColor = UIColor.black
        startLocationTextField.theme.separatorColor = UIColor.black
        startLocationTextField.theme.cellHeight = 50
        startLocationTextField.maxNumberOfResults = 4
        startLocationTextField.maxResultsListHeight = 200
        startLocationTextField.minCharactersNumberToStartFiltering = 2
        
        //Set Up TextField AutoComplete END
        endLocationTextField.theme = SearchTextFieldTheme.darkTheme()
        endLocationTextField.theme.font = UIFont.systemFont(ofSize: 20)
        endLocationTextField.theme.fontColor = UIColor.black
        endLocationTextField.theme.bgColor = UIColor.white
        endLocationTextField.theme.borderColor = UIColor.black
        endLocationTextField.theme.separatorColor = UIColor.black
        endLocationTextField.theme.cellHeight = 50
        endLocationTextField.maxNumberOfResults = 4
        endLocationTextField.maxResultsListHeight = 200
        endLocationTextField.minCharactersNumberToStartFiltering = 2
        
        //Handle What happens when pressed
        startLocationTextField.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.startLocationTextField.text = item.title
            self.tripObject.startLocation = item.address! as! Address
        }
        
        //Handle What happens when pressed
        endLocationTextField.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.endLocationTextField.text = item.title
            self.tripObject.endLocation = item.address! as! Address
        }
        
        //Labels
        startDestinationLabel.center.x += self.view.bounds.width
        endDestinationLabel.center.x += self.view.bounds.width
        radiusLabel.center.x += self.view.bounds.width
        setTimeLabel.center.x += self.view.bounds.width
        seatsLabel.center.x += self.view.bounds.width
        rateLabel.center.x += self.view.bounds.width
        
        //Set Up Text View
        postTextView.center.x -= view.bounds.width
        postTextView.font = UIFont.systemFont(ofSize: 20.0)
        postTextView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        postTextView.placeholder = "What Would You Like To Share. . ."
        postTextView.textColor = UIColor.lightGray
        
        //Set Up Stack View
        seatsStackView.center.y = INITIAL_DRIVING_HEIGHT
        seatsStackView.center.x += self.view.bounds.width
        seatsStackView.frame = CGRect(x: view.frame.width, y: INITIAL_DRIVING_HEIGHT, width: view.frame.width, height: 100)
        
        
        //Set Up Profile Image View
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.backgroundColor = .black
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        profileImageView.sd_setImage(with: URL(string: (self.user?.profileUrl)!), placeholderImage: UIImage(named: "Profile_Placeholder"))

        
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
        case "seats":
            UIView.animate(withDuration: 0.5) {
                self.seatsStackView.center.x -= self.view.bounds.width
                self.seatsLabel.center.x -= self.view.bounds.width
            }
        case "radius":
            UIView.animate(withDuration: 0.5) {
                self.radiusTextField.center.x -= self.view.bounds.width
                self.radiusLabel.center.x -= self.view.bounds.width
            }
        case "rate":
            UIView.animate(withDuration: 0.5) {
                self.rateLabel.center.x -= self.view.bounds.width
                self.rateTextField.center.x -= self.view.bounds.width
            }
        case "textField":
            UIView.animate(withDuration: 0.5) {
                self.postTextView.frame = CGRect(x: self.view.bounds.size.width, y: self.view.bounds.size.height, width: 0, height: 0)
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
        case "seats":
            //Animate Start text Field on
            UIView.animate(withDuration: 0.5) {
                self.seatsLabel.center.x = self.view.center.x
                self.seatsStackView.frame = CGRect(x: 0, y: self.INITIAL_DRIVING_HEIGHT, width: self.view.frame.width, height: 100)
            }
        case "radius":
            //Animate Start text Field on
            UIView.animate(withDuration: 0.5) {
                self.radiusLabel.center.x = self.view.center.x
                self.radiusTextField.center.x = self.view.center.x
            }
        case "rate":
            //Animate Start text Field on
            UIView.animate(withDuration: 0.5) {
                self.rateLabel.center.x = self.view.center.x
                self.rateTextField.center.x = self.view.center.x
            }
        case "text":
            //Animate Text View in
            UIView.animate(withDuration: 0.5) {
                self.postTextView.frame = self.textViewFrame
                self.postTextView.becomeFirstResponder()
            }
            self.nextButton.setTitle("Post", for: .normal)
            self.nextButton.isUserInteractionEnabled = true
            self.nextButton.backgroundColor = color
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
        case "seats":
            UIView.animate(withDuration: 0.5) {
                self.seatsLabel.center.x += self.view.bounds.width
                self.seatsStackView.center.x += self.view.bounds.width
            }
        case "radius":
            UIView.animate(withDuration: 0.5) {
                self.radiusLabel.center.x += self.view.bounds.width
                self.radiusTextField.center.x += self.view.bounds.width
            }
        case "rate":
            UIView.animate(withDuration: 0.5) {
                self.rateLabel.center.x += self.view.bounds.width
                self.rateTextField.center.x += self.view.bounds.width
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
        //Check if the user can make a driving post
        if ( RealmManager.shared.driverCanBePaidOut() ){
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
        }else{
            //show the pop up and take the user to the page
            let popup = PopupManager.shared.checkDriverPayout()
            if let vc = popup.viewController as? DriverCheckPayoutViewController {
                vc.delegate = self
            }
            self.present(popup, animated: true, completion: nil)
        }
        
        
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
            self.nextButton.isUserInteractionEnabled = false
            self.nextButton.backgroundColor = disabledColor
            
        case Status.TIMECHOSEN:
            return
        case Status.TIMESHOWN:
            if ( leaveTime == LeaveTime.ARRIVAL){
                animateOFF(obj: "arrivalButton")
            }else{
                animateOFF(obj: "departureButton")
            }
            
            if ( trip == TypeOfTrip.LOOKING ){
                animateON(obj: "text")
                status = Status.FINISHED
            }else{
                animateON(obj: "seats")
                status = Status.TIMECHOSEN
            }
            
        case Status.SEATSCHOSEN:
            animateOFF(obj: "seats")
            animateON(obj: "radius")
            status = Status.RADIUSPICKED
            
        case Status.RADIUSPICKED:
            animateOFF(obj: "radius")
            animateON(obj: "rate")
            status = Status.RATECHOSEN
            
        case Status.RATECHOSEN:
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
            
            //Save the rate to the tripobject
            tripObject.ratePerSeat = Int( rateTextField.text! )
            
            //Animate Off Rate Chosen
            animateOFF(obj: "rate")
            
            //animate on the textfield
            animateON(obj: "textField")
            
            //Show the keyboard
            postTextView.becomeFirstResponder()
            
            animateON(obj: "text")
            
            //Set Next Title for button
            nextButton.setTitle("Post Trip", for: .normal)
            
            //Set Status
            status = Status.FINISHED

        case Status.FINISHED:
            tripObject.postText = postTextView.text
            tripObject.radius = Int( radiusTextField.text! )!
            tripObject.ratePerSeat = Int( rateTextField.text! )
            if ( trip == TypeOfTrip.DRIVING ){
                tripObject.postedBy = "driver"
            }
            else{
                tripObject.postedBy = "rider"
            }
            view.endEditing( true )
            self.dismiss(animated: true, completion: {
                //Do something with this, idk what yet though, maybe refresh feed
                Network.shared.createPost(trip: self.tripObject).then { key_array -> Void in
                    let post_key = key_array[0] as! String
                    let trip_key = key_array[1] as! String
                    let eta = key_array[2] as! String
                    let driving = key_array[3]
                    //Save the current trip key to the realm user if they are driving
                    if ( driving == "true" ){
                        RealmManager.shared.setCurrentTrip(destination: self.tripObject.endLocation.city, tripKey: trip_key, eta:eta)
                    }
                    
                }
            })
            
        default:
            return
        }
        print(status)
        
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
        case Status.TIMECHOSEN:
            animateBACK(obj: "seats")
            animateON(obj: "setTimeButtons")
            status = Status.TIMESHOWN
        case Status.TIMESHOWN:
            animateBACK(obj: "departure")
            animateBACK(obj: "arrival")
            status = Status.ENDENTERED
        case Status.STARTENTERED:
            startLocationTextField.becomeFirstResponder()
            animateBACK(obj: "endDestination")
            animateON(obj: "startDestination")
            status = Status.TYPECHOSEN
            
        case Status.ENDENTERED:
            animateON(obj: "endDestination")
            animateBACK(obj: "desired")
            status = Status.STARTENTERED
            self.nextButton.isUserInteractionEnabled = true
            self.nextButton.backgroundColor = color
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
        case Status.SEATSCHOSEN:
            animateBACK(obj: "seats")
            animateON(obj: "setTimeButtons")
            status = Status.DESIREDCHOSEN
            
        case Status.RADIUSPICKED:
            animateBACK(obj: "radius")
            animateON(obj: "seats")
            status = Status.SEATSCHOSEN
            
        case Status.RATECHOSEN:
            animateBACK(obj: "rate")
            animateON(obj: "radius")
            status = Status.RADIUSPICKED
            
        case Status.FINISHED:
            animateOFF(obj: "textField")
            animateON(obj: "rate")
            status = Status.RATECHOSEN
        default:
            return
        }
        print(status)
    }
    
    @IBAction func departureAction(_ sender: Any) {
        leaveTime = LeaveTime.DEPARTURE
        animateOFF(obj: "setTimeLabel")
        animateOFF(obj: "arrivalButton")
        status = Status.TIMESHOWN
        showTimePicker()
        tripObject.chosenTime = "departure"
    }
    
    @IBAction func arrivalAction(_ sender: Any) {
        leaveTime = LeaveTime.ARRIVAL
        animateOFF(obj: "setTimeLabel")
        animateOFF(obj: "departureButton")
        status = Status.TIMESHOWN
        showTimePicker()
        tripObject.chosenTime = "arrival"
    }
    
    func showTimePicker(){
        let picker = DateTimePicker.show()
        picker.highlightColor = color
        picker.isDatePickerOnly = false // to hide time and show only date picker
        picker.is12HourFormat = true
        picker.completionHandler = { date in
            print( date.to_string() )
            self.tripObject.eta = date.to_string()
            self.next()
            
            /* CONVERT STRING FROM SERVER TO DATE STRING
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "dd-mm-yyyy" //Your date format
             dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
             let date = dateFormatter.date(from: "01-01-2017") //according to date format your date string
             print(date ?? "") //Convert String to Date
             
             */
        }
    }

    @IBAction func button1Action(_ sender: Any) {
        buttonChosen(int: 1)
    }
    @IBAction func button2Action(_ sender: Any) {
        buttonChosen(int: 2)
    }
    @IBAction func button3Action(_ sender: Any) {
        buttonChosen(int: 3)
    }
    @IBAction func button4Action(_ sender: Any) {
        buttonChosen(int: 4)
    }
    @IBAction func button5Action(_ sender: Any) {
        buttonChosen(int: 5)
    }
    @IBAction func button6Action(_ sender: Any) {
        buttonChosen(int: 6)
    }
    @IBAction func button7Action(_ sender: Any) {
        buttonChosen(int: 7)
    }
    
    func buttonChosen(int: Int){
        
        resetAllButtonBackgrounds()
        
        switch int {
        case 1:
            button1.backgroundColor = color
            button1.setTitleColor(.white, for: .normal)
            tripObject.seatsAvailable = 1
        case 2:
            button2.backgroundColor = color
            button2.setTitleColor(.white, for: .normal)
            tripObject.seatsAvailable = 2
        case 3:
            button3.backgroundColor = color
            button3.setTitleColor(.white, for: .normal)
            tripObject.seatsAvailable = 3
        case 4:
            button4.backgroundColor = color
            button4.setTitleColor(.white, for: .normal)
            tripObject.seatsAvailable = 4
        case 5:
            button5.backgroundColor = color
            button5.setTitleColor(.white, for: .normal)
            tripObject.seatsAvailable = 5
        case 6:
            button6.backgroundColor = color
            button6.setTitleColor(.white, for: .normal)
            tripObject.seatsAvailable = 6
        case 7:
            button7.backgroundColor = color
            button7.setTitleColor(.white, for: .normal)
            tripObject.seatsAvailable = 7
        default:
            return
        }

        //Enable the next button
        nextButton.isUserInteractionEnabled = true
        nextButton.backgroundColor = color
        
        //Set the status for next transition
        status = Status.SEATSCHOSEN
    }
    
    func resetAllButtonBackgrounds(){
        button1.backgroundColor = .clear
        button2.backgroundColor = .clear
        button3.backgroundColor = .clear
        button4.backgroundColor = .clear
        button5.backgroundColor = .clear
        button6.backgroundColor = .clear
        button7.backgroundColor = .clear
        
        button1.setTitleColor(color, for: .normal)
        button2.setTitleColor(color, for: .normal)
        button3.setTitleColor(color, for: .normal)
        button4.setTitleColor(color, for: .normal)
        button5.setTitleColor(color, for: .normal)
        button6.setTitleColor(color, for: .normal)
        button7.setTitleColor(color, for: .normal)
        
        button1.layer.borderColor = UIColor.black.cgColor
        button2.layer.borderColor = UIColor.black.cgColor
        button3.layer.borderColor = UIColor.black.cgColor
        button4.layer.borderColor = UIColor.black.cgColor
        button5.layer.borderColor = UIColor.black.cgColor
        button6.layer.borderColor = UIColor.black.cgColor
        button7.layer.borderColor = UIColor.black.cgColor
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button4.layer.borderWidth = 1
        button5.layer.borderWidth = 1
        button6.layer.borderWidth = 1
        button7.layer.borderWidth = 1
        
        button1.layer.cornerRadius = 8
        button2.layer.cornerRadius = 8
        button3.layer.cornerRadius = 8
        button4.layer.cornerRadius = 8
        button5.layer.cornerRadius = 8
        button6.layer.cornerRadius = 8
        button7.layer.cornerRadius = 8
    }
}
