//
//  ViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/22/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import PromiseKit

class FeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFeed()
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
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        cell.textView.text = self.posts[indexPath.row].text
        cell.userNameLabel.text = self.posts[indexPath.row].user.firstName + " " + self.posts[indexPath.row].user.lastName
        cell.likeLabel.text = self.posts[indexPath.row].likeCountString
        cell.commentLabel.text = self.posts[indexPath.row].commentCountString
        cell.post = self.posts[indexPath.row]
        if ( self.posts[indexPath.row].isLiked ){
            cell.likeButtonLabel.setTitle("UnLike", for: .normal)
        }
        else{
            cell.likeButtonLabel.setTitle("Like", for: .normal)
        }
        return cell
    }
}
