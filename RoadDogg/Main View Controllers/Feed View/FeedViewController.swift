//
//  ViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/22/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import PromiseKit

class FeedViewController: UIViewController, FeedPostDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    
    var refresher:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFeed()
        self.collectionView.backgroundColor = .gray
        
        //Add Refresh To Collection View
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(fetchFeed), for: .valueChanged)
        self.collectionView!.refreshControl = refresher
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func fetchFeed(){
        //Begin Refreshing
        self.collectionView!.refreshControl?.beginRefreshing()
        
        Network.shared.getFeed(user_key: "ag1kZXZ-Z29hbC1yaXNlchELEgRVc2VyGICAgICAgMAKDA").then { feed -> Void in
            self.posts = feed.posts
            
            //End Refreshing
            self.collectionView!.refreshControl?.endRefreshing()
            
            //Reload Collection View DAta
            self.collectionView.reloadData()
            }.catch { error -> Void in
                print(error)
            }
    }
    
    func pushPostViewController( vc: TripViewController ){
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func testReload( indexPath : NSIndexPath){
       // self.collectionView.reloadItems(at: [indexPath])
    }
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let estimatedTextHeight = self.posts[indexPath.row].getEstimatedTextViewSize(width: view.frame.width - 20)
        let postHeight : CGFloat = 190
        let allPostHeight = postHeight + estimatedTextHeight
        return CGSize(width: view.frame.width, height: allPostHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Set Up Cell
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! FeedPostCell
        let post = self.posts[indexPath.row]
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
        
        return cell
    }

    
    func adjustUITextViewHeight(arg : UITextView) -> CGFloat
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
        return arg.frame.height
    }
}
