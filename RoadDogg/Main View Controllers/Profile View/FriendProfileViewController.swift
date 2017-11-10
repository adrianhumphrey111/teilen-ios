//
//  FriendProfileViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/8/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

enum Case {
    case POST
    case REVIEWS
}

class FriendProfileViewController: UIViewController , FeedPostDelegate {
    
    //User for Profile
    var user: User!
    
    //Refresher for collection View of the post for the user
    var refresher:UIRefreshControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var colletionCase : Case = .POST
    
    @IBOutlet weak var carStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add Refresh To Collection View
        self.refresher = UIRefreshControl()
        self.refresher.beginRefreshing()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(fetchUserFeed), for: .valueChanged)
        self.collectionView!.refreshControl = refresher
        
        //Show the colletion View currnetly loading
        fetchUserFeed()
        
    }
    
    @objc func fetchUserFeed(){
        Network.shared.getUserFeed(user_key: "ag1kZXZ-Z29hbC1yaXNlchELEgRVc2VyGICAgICAgMAKDA").then { feed -> Void in
            //Set the post to the user
            self.user.posts = feed.posts
            
            //End Refreshing
            self.collectionView!.refreshControl?.endRefreshing()
            
            //Reload Collection View DAta
            self.collectionView.reloadData()
            
            }.catch { error -> Void in
                print(error)
        }
    }
    
    func pushPostViewController( vc: UIViewController ){
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension FriendProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Do Nothing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if (indexPath.section == 1){
            
            let estimatedTextHeight = self.user.posts![indexPath.row].getEstimatedTextViewSize(width: view.frame.width - 20)
            let postHeight : CGFloat = 190
            let allPostHeight = postHeight + estimatedTextHeight
            return CGSize(width: view.frame.width, height: allPostHeight)
            
        }
        else{
            if ( self.user.car == nil ){
                return CGSize(width: view.frame.width, height: 270)
            }else{
                
                return CGSize(width: view.frame.width, height: 500)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let posts = self.user.posts{
            return ( section == 0 ) ? 1 : posts.count
        }
        else{
            return ( section == 0 ) ? 1 : 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "friendProfileCell", for: indexPath) as! FriendProfileHeadViewCell
            
            //If the user does not have a car, remove carstackview
            if ( self.user.car == nil ){
                if ( cell.carStackView != nil ){
                    cell.carStackView.removeFromSuperview()
                    //cell.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
                }
            }
            return cell
        }
        else{
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! FeedPostCell
            if let user = self.user{
                if let posts = user.posts{
                    configurePostCell(cell: cell, post: posts[indexPath.row] )
                }
            }
            return cell
        }
    }
    
    func configurePostCell( cell: FeedPostCell, post: Post){
        cell.post = post
        cell.delegate = self 
        cell.backgroundColor = .white
        
        //Set up Labels
        cell.userNameLabel.text = post.user.firstName + " " + post.user.lastName
        cell.likeLabel.text = post.likeCountString
        cell.commentLabel.text = post.commentCountString
        cell.createdAtLabel.text = post.createdAt
        
        //Set Up Profile Image View
        cell.profileImageView.layer.borderWidth = 1
        cell.profileImageView.layer.masksToBounds = false
        cell.profileImageView.backgroundColor = .black
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2
        cell.profileImageView.clipsToBounds = true
        
        //Create TextView in Post Cell
        let textView = UITextView(frame: CGRect(x: 10, y: 0, width: view.frame.width - 20, height: cell.textAreaView.frame.height))
        textView.text = post.text
        textView.font = UIFont.systemFont(ofSize: (post.fontSize))
        textView.backgroundColor = .green
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        cell.textAreaView.addSubview( textView )
        
        //Set Up Cell Like button text
        if ( post.isLiked ){
            cell.likeButtonLabel.setTitle("UnLike", for: .normal)
        }
        else{
            cell.likeButtonLabel.setTitle("Like", for: .normal)
        }
    }
}
