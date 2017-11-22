//
//  IGListFeedViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/20/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

class IGListFeedViewController : UIViewController, FeedPostDelegate{
    
    func pushPostViewController(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Collection View
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    //IGList Adapter
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    //Posts that will populate CollectionView
    var posts : [Post] = []
    
    //Refresher
    var refresher:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Make tab bar visible
        tabBarController?.tabBar.isHidden = false
        
        //Add colelctionview
        view.addSubview(collectionView)
        
        //Set up collection Adapter
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        //Grab All posts
        fetchFeed()
        
        //Add Refresh To Collection View
        self.refresher = UIRefreshControl()
        self.collectionView.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(fetchFeed), for: .valueChanged)
        self.collectionView.refreshControl = refresher
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Make tab bar visible
        tabBarController?.tabBar.isHidden = false
        
        fetchFeed()
    }
    
    @objc func fetchFeed(){
        Network.shared.getFeed().then { feed -> Void in
            //End Refreshing
            self.collectionView.refreshControl?.endRefreshing()
            
            //Set the post and perform updates
            self.posts = feed.posts
            print("Post after the fetch => ", self.posts)
            self.adapter.performUpdates(animated: true, completion: { (bool) in
                print("Posts after the updates have been performed => ", self.posts)
            })
        }
    }
}

extension IGListFeedViewController: ListAdapterDataSource {
    // 1
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return (self.posts as? [ListDiffable])!
    }
    
    // 2
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        //Check if this post was posted by a rider or a driver
        let post = object as? Post
        if ( post?.trip?.postedBy == "driver" ){
            return DriverPostSectionController()
        }
        else{
            print("This was posted by a rider")
            return DriverPostSectionController()
        }
        
    }
    
    // 3
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        print("The view is empty and was not updated")
        return nil
        
    } //Return a certatin view later
}
