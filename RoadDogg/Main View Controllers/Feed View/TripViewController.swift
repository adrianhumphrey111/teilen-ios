//
//  TripViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/31/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

//TODO: ADD Tap gesture to Tripview, becuase maybe the post does not have any comments yet.

class TripViewController: UIViewController, PostViewCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var post : Post!
    var comments: [Comment]!
    var commenting = false
    
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
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action:#selector(handleSendPressed), for: .touchUpInside)
        return button
        
    }()
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Instantly show the keyboard if the person is commenting on the post
        if ( commenting ){ inputTextField.becomeFirstResponder() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Trip"
        tabBarController?.tabBar.isHidden = true
        
        //Set up Message View Container
        view.addSubview( messageInputContainerView )
        
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
    
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let isKeyboardShowing = notification.name == Notification.Name.UIKeyboardWillShow
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
            collectionViewBottomConstraint.constant = isKeyboardShowing ? -( keyboardFrame.height + 48 ) : 48
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
    
                DispatchQueue.main.async {
                    if isKeyboardShowing{
                    let indexPath = IndexPath(item: self.comments.count - 1, section: 1)
                    self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
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
        var comment = Comment(comment: text)
        comment.createdAt = "Posting"
        post.comments.append( comment )
        comments.append( comment )
        
        //Reload Table so that Comment shows up instantly
        self.collectionView.reloadData()
        
        Network.shared.commentPost(postKey: post.postKey, comment: text).then { returnedComment -> Void in
            //Add comment key to the comment which is returned by the server
            //comment.commentKey = returnedComment.commentKey
            //comment.createdAt = returnedComment.createdAt
            comment.createdAt = "Just Now"
            comment.postKey = returnedComment.postKey
            comment.userKey = returnedComment.userKey
            
            //Enable Send button
            self.sendButton.isUserInteractionEnabled = true
            
            //Reload CollectionView
            self.collectionView.reloadData()
            
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
        NSLayoutConstraint(item: sendButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: messageInputContainerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -10 ).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: messageInputContainerView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: view.frame.width * 0.10 ).isActive = true
        NSLayoutConstraint(item: sendButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 42).isActive = true
        
    }
    
    func comment() {
        inputTextField.becomeFirstResponder()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension TripViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing( true )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if (indexPath.section == 0){
            let estimatedTextHeight = self.post?.getEstimatedTextViewSize(width: view.frame.width - 20)
            let postHeight : CGFloat = 200
            let allPostHeight = postHeight + estimatedTextHeight!
            return CGSize(width: view.frame.width, height: allPostHeight)
        }
        else{
            let estimatedTextHeight = self.post?.comments[indexPath.row].getEstimatedTextViewSize(width: view.frame.width - 20)
            let postHeight : CGFloat = 40
            let allPostHeight = postHeight + estimatedTextHeight!
            return CGSize(width: view.frame.width, height: allPostHeight)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ( section == 0 ) ? 1 : post.comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            //make sure the identifier of your cell for first section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postViewCell", for: indexPath) as! PostViewCell
            configurePostCell(cell: cell, post: post)
            return cell
        }else{
            //make sure the identifier of your cell for second section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as! CommentViewCell
            configureCommentCell(cell: cell, comment: post.comments[indexPath.row])
            return cell
        }
    }
    
    func configurePostCell( cell: PostViewCell, post: Post){
        cell.post = post
        cell.profileImageView.backgroundColor = .black
        cell.fullNameLabel.text = (post.user.firstName) + " " + (post.user.lastName)
        cell.userNameLabel.text = "username here"
        
        //Create TextView in Post Cell
        let textView = UITextView(frame: CGRect(x: 10, y: 0, width: view.frame.width - 20, height: cell.textAreaView.frame.height))
        textView.text = post.text
        textView.font = UIFont.systemFont(ofSize: (post.fontSize))
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        cell.textAreaView.addSubview( textView )
        cell.timeStampLabel.text = post.createdAt
        cell.numberOfLikesLabel.text = post.likeCountString
        cell.numberOfCommentsLabel.text = post.commentCountString
        
        //Set delegate
        cell.delegate = self
        
        //Set Like Label
        if ( post.isLiked ){
            cell.likeButton.setTitle("UnLike", for: .normal)
        }
        else{
            cell.likeButton.setTitle("Like", for: .normal)
        }
    }
    
    func configureCommentCell( cell: CommentViewCell, comment: Comment){
        cell.comment = comment
        cell.profileImageView.backgroundColor = .black
        
        //Create TextView in Comment Cell
        let textView = UITextView(frame: CGRect(x: 10, y: 0, width: view.frame.width - 20, height: cell.textAreaView.frame.height))
        textView.text = comment.text
        textView.backgroundColor = .blue
        textView.font = UIFont.systemFont(ofSize: (post.fontSize))
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        cell.textAreaView.addSubview( textView )
        
        cell.timeStampLabel.text = comment.createdAt
        
    }
}
