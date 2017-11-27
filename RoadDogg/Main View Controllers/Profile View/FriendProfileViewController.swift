//
//  FriendProfileViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/8/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import IGListKit

enum Case {
    case POST
    case REVIEWS
}

class FriendProfileViewController: UIViewController , FeedPostDelegate {
    
    //User for Profile
    var user: User!
    var profileArray : [AnyObject] = []
    
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
    
    //Refresher
    var refresher:UIRefreshControl!
    
    var colletionCase : Case = .POST
    
    @IBOutlet weak var carStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add colelctionview
        view.addSubview(collectionView)
        
        //Set up collection Adapter
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        //Show the colletion View currnetly loading
        fetchUserFeed()
        
        //Add Refresh To Collection View
        self.refresher = UIRefreshControl()
        self.collectionView.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(fetchUserFeed), for: .valueChanged)
        self.collectionView.refreshControl = refresher
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc func fetchUserFeed(){
        Network.shared.getUserFeed(user_key: self.user.key).then { feed -> Void in
            //Set the post to the user
            self.user.posts = feed.posts
            self.profileArray += self.user.posts
            
            //End Refreshing
            self.collectionView.refreshControl?.endRefreshing()
            
            self.adapter.performUpdates(animated: true, completion: nil)
            
            }.catch { error -> Void in
                print(error)
        }
    }
    
    func pushPostViewController( vc: UIViewController ){
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension FriendProfileViewController: ListAdapterDataSource {
    // 1
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        
        return (self.profileArray as? [ListDiffable])!
    }
    
    // 2
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        if let post = object as? Post{
            if ( post.trip?.postedBy == "driver"){
               return DriverPostSectionController()
            }
            else{
                return RiderPostSectionContoller()
            }
        }else{
            return FriendProfileHeadSectionController()
        }
    }
    
    // 3
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        print("The Trip controller is empty")
        return nil
        
    } //Return a certatin view later
}


