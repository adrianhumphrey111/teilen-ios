//
//  TripViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/31/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class CustomSearchTextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 15, 0, 15))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 15, 0, 15))
    }
}


class TripViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var post : Post!
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 0.7
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    
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
    
    var bottomConstraint: NSLayoutConstraint?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Trip"
        tabBarController?.tabBar.isHidden = true
        
        //Set up Message View Container
        view.addSubview( messageInputContainerView )
        
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: messageInputContainerView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: messageInputContainerView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: messageInputContainerView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: view.frame.width).isActive = true
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 48)
        view.addConstraint( bottomConstraint! )
        
        //Set Up TextField for comments
        setUpInputComponents()
        
        //Set up notificaiton for when keyboard is shown
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            bottomConstraint?.constant = -keyboardFrame.height
            print( keyboardFrame )
        }
    }
    
    private func setUpInputComponents() {
        messageInputContainerView.addSubview( inputTextField )
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: inputTextField, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: messageInputContainerView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -25 ).isActive = true
        NSLayoutConstraint(item: inputTextField, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: messageInputContainerView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: inputTextField, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: view.frame.width - 60 ).isActive = true
        NSLayoutConstraint(item: inputTextField, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 42).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing( true )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let estimatedTextHeight = self.post?.getEstimatedTextViewSize(width: view.frame.width - 20)
        let postHeight : CGFloat = 200
        let allPostHeight = postHeight + estimatedTextHeight!
        return CGSize(width: view.frame.width, height: allPostHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "postViewCell", for: indexPath) as! PostViewCell
        
        cell.post = post
        cell.profileImageView.backgroundColor = .black
        cell.fullNameLabel.text = (post?.user.firstName)! + " " + (post?.user.lastName)!
        cell.userNameLabel.text = "username here"
        
        //Create TextView in Post Cell
        let textView = UITextView(frame: CGRect(x: 10, y: 0, width: view.frame.width - 20, height: cell.textAreaView.frame.height))
        textView.text = post?.text
        textView.font = UIFont.systemFont(ofSize: (post?.fontSize)!)
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        cell.textAreaView.addSubview( textView )
        
        
        cell.timeStampLabel.text = post?.createdAt
        cell.numberOfLikesLabel.text = post?.likeCountString
        cell.numberOfCommentsLabel.text = post?.commentCountString
        
        //Set Like Label
        if ( post.isLiked ){
            cell.likeButton.setTitle("UnLike", for: .normal)
        }
        else{
            cell.likeButton.setTitle("Like", for: .normal)
        }
        
        return cell
    }
}
