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

protocol FeedPostDelegate{
    func pushPostViewController( vc : UIViewController)
}


class IGListFeedViewController : UIViewController, FeedPostDelegate, PopupDelegate{
    
    
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
        self.refresher.tintColor = UIColor.black
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
        self.adapter.performUpdates(animated: true, completion: nil)
        tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func fetchFeed(){
        Network.shared.getFeed().then { feed -> Void in
            //End Refreshing
            self.collectionView.refreshControl?.endRefreshing()
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    func reserveSeat(price: Int, postKey: String){
        var vc = PopupManager.shared.reserveSeat(price: price, postKey: postKey)
        if let requestVc = vc.viewController as? ReserveSeatPopupViewController{
            requestVc.delegate = self
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func logout(){
        //Do nothing
    }
    
    func goToPaymentController() {
        print("Take the user to the payment page")
        tabBarController?.selectedIndex = 4
        if let navController = tabBarController?.viewControllers![4] as? UINavigationController{
            if let vc = navController.viewControllers[0] as? ProfileViewController{
                vc.showPayment()
            }
        }
    }
    
    func pushPostViewController(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension IGListFeedViewController: ListAdapterDataSource {
    // 1
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return (Posts.shared.feedPosts as? [ListDiffable])!
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
            return RiderPostSectionContoller()
        }
    }
    
    // 3
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        
        let vc = EmptyFeedViewController(nibName: "EmptyFeedViewController", bundle: nil)
        self.addChildViewController( vc )
        vc.didMove(toParentViewController: self)
        return vc.view
    }
}
