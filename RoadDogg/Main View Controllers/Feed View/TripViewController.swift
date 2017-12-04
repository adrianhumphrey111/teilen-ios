//
//  TripViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/31/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import IGListKit

protocol PostViewCellDelegate {
    func comment()
    func pushPostViewController( vc : UIViewController)
    
}

//TODO: ADD Tap gesture to Tripview, becuase maybe the post does not have any comments yet.

class TripViewController: UIViewController, PostViewCellDelegate, PopupDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    var tripArray : [AnyObject] = [] //First object will be the post, that the driver or rider will configure, second will be array of comments if any
    var commenting = false
    
    //Collection View
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor().colorWithHexString(hex: "#cfcecb", alpha: 0.75)
        return view
    }()
    
    //IGList Adapter
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    //Setup message container view
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 0.7
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    //Set up input text field
    let inputTextField: UITextField = {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15.0, height: textField.frame.height))
        textField.placeholder = "Write a Comment..."
        textField.layer.cornerRadius = 15.0
        textField.layer.borderWidth = 0.7
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.leftView = paddingView
        textField.leftViewMode = UITextFieldViewMode.always
        return textField
    }()
    
    //Set up send button
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(UIColor().colorWithHexString(hex: "#76D2CE", alpha: 0.5), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action:#selector(handleSendPressed), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    
    //Constriaint for the bottom textview
    var bottomConstraint: NSLayoutConstraint?
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Disallow recognition of tap gestures in the segmented control.
        if (touch.view == self.sendButton) {
            //change it to your condition
            return false
        }
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Instantly show the keyboard if the person is commenting on the post
        if ( commenting ){ inputTextField.becomeFirstResponder() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isTranslucent = true
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up tabbar and nav controller
        self.title = "Trip"
        tabBarController?.tabBar.isHidden = true
        
        //TextView set delegate
        inputTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        
        
        //Add colelctionview
        view.addSubview(collectionView)
        
        //Set up collection Adapter
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        //Set up Message View Container
        view.addSubview( messageInputContainerView )
        
        //Tap gesture to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.delegate = self
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        //Set up the input field view and constraints
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: messageInputContainerView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        bottomConstraint =  NSLayoutConstraint(item: messageInputContainerView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint(item: messageInputContainerView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: view.frame.width).isActive = true
        NSLayoutConstraint(item: messageInputContainerView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 48).isActive = true
        view.addConstraint( bottomConstraint! )
        
        //Set Up TextField for comments
        setUpInputComponents()
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let collectionFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 48)
        collectionView.frame = collectionFrame
    }
    
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let isKeyboardShowing = notification.name == Notification.Name.UIKeyboardWillShow
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
    
                DispatchQueue.main.async {
                    if isKeyboardShowing{
//                    let indexPath = IndexPath(item: self.comments.count - 1, section: 1)
//
                    }
                }
            })
        }
    }
    
    @objc func handleSendPressed(){
        let text = inputTextField.text!
        
        //Dismiss the keyboard
        inputTextField.endEditing( true )
        
        //Disable send button
        sendButton.isUserInteractionEnabled = false
        inputTextField.text = ""
        
        //Add the comment to the post, with a "posting", once the promise is returned, update the ui to "Just Now"
        let post = self.tripArray[0] as? Post
        let comment = Comment(comment: text)
        comment.createdAt = "less than minute ago"
        comment.user = User()
        comment.user?.profileUrl = RealmManager.shared.selfUser!.profileUrl
        
        //Add to the post
        post?.comments.addComment( comment: comment )
        
        //Add to the diffable array
        self.tripArray.append( comment )
        
        //Reload Section Controller
        self.adapter.performUpdates(animated: true) { (bool) in
            print("The comment was posted and should have shown up")
        }
        
        Network.shared.commentPost(postKey: (post?.postKey)!, comment: text).then { returnedComment -> Void in
            comment.createdAt = returnedComment.createdAt
            comment.postKey = returnedComment.postKey
            comment.userKey = returnedComment.userKey
            //Enable Send button
            self.sendButton.isUserInteractionEnabled = true
            
            //Reload CollectionView
            self.adapter.performUpdates(animated: true, completion: nil)
            
            }.catch { error -> Void in
                print(error)
        }
    }
    
    private func setUpInputComponents() {
        //Set up input Text field to message container view
        messageInputContainerView.addSubview( inputTextField )
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: inputTextField, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: messageInputContainerView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -25 ).isActive = true
        NSLayoutConstraint(item: inputTextField, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: messageInputContainerView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: inputTextField, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: view.frame.width * 0.80 ).isActive = true
        NSLayoutConstraint(item: inputTextField, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 42).isActive = true
        
        //Set up send button to message container view
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        messageInputContainerView.addSubview( sendButton )
        NSLayoutConstraint(item: sendButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: messageInputContainerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -5 ).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: messageInputContainerView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: view.frame.width * 0.15 ).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 42).isActive = true
        
    }
    
    func comment() {
        inputTextField.becomeFirstResponder()
    }
    
    //MARK Delegate Methods
    
    func pushPostViewController(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToPaymentController() {
        //Take user to the payment page
    }
    
    func showKeyboard() {
        inputTextField.becomeFirstResponder()
    }
    
    func reserveSeat(price: Int, postKey: String){
        var vc = PopupManager.shared.reserveSeat(price: price, postKey: postKey)
        if let requestVc = vc.viewController as? ReserveSeatPopupViewController{
            requestVc.delegate = self
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func logout() {
        //Do nothing
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(textField : UITextField){
        if let count = self.inputTextField.text?.characters.count {
            if ( count > 0){
                self.sendButton.setTitleColor(UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0), for: .normal)
                self.sendButton.isUserInteractionEnabled = true
            }
            else{
                self.sendButton.setTitleColor(UIColor().colorWithHexString(hex: "#76D2CE", alpha: 0.5), for: .normal)
                self.sendButton.isUserInteractionEnabled = false
            }
        }
    }
    
}

extension TripViewController: ListAdapterDataSource {
    // 1
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        print("Trip array => " , self.tripArray)
        return (self.tripArray as? [ListDiffable])!
    }
    
    // 2
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        if let post = object as? Post{
            return TripPostSectionController() //Handle the driver and rider distinction inside class
            
        }else{
            return CommentsSectionsController()
        }
    }
    
    // 3
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        print("The Trip controller is empty")
        return nil
        
    } //Return a certatin view later
}
