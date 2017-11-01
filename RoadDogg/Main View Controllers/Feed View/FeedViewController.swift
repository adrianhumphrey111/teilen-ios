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

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFeed()
        self.collectionView.backgroundColor = .gray
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchFeed(){
        Network.shared.getFeed(user_key: "ag1kZXZ-Z29hbC1yaXNlchELEgRVc2VyGICAgICAgMAKDA").then { feed -> Void in
            self.posts = feed.posts
            self.collectionView.reloadData()
            }.catch { error -> Void in
                print(error)
            }
    }
    
    func pushPostViewController( vc: TripViewController ){
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       
        let estimatedTextHeight = self.posts[indexPath.row].getEstimatedTextViewSize(width: view.frame.width - 20)
        let postHeight : CGFloat = 210
        let allPostHeight = postHeight + estimatedTextHeight
        return CGSize(width: view.frame.width, height: allPostHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! FeedPostCell
        var post = self.posts[indexPath.row]
        cell.delegate = self
        cell.userNameLabel.text = post.user.firstName + " " + post.user.lastName
        cell.likeLabel.text = post.likeCountString
        cell.profileImageView.backgroundColor = .black
        cell.backgroundColor = .white
        cell.textView.font = UIFont.systemFont(ofSize: post.fontSize)
        cell.textView.text = post.text
        cell.textView.backgroundColor = .red
        cell.commentLabel.text = post.commentCountString
        post.textHeight = adjustUITextViewHeight(arg: cell.textView)
        cell.post = post
        cell.createdAtLabel.text = post.createdAt
        if ( post.isLiked ){
            cell.likeButtonLabel.setTitle("UnLike", for: .normal)
        }
        else{
            cell.likeButtonLabel.setTitle("Like", for: .normal)
        }
        return cell
    }
    
    //Lets get an estimation of the height of the post text
    
    
    
    
    func adjustUITextViewHeight(arg : UITextView) -> CGFloat
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
        return arg.frame.height
    }
}
