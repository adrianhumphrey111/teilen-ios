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


class IGListFeedViewController : UIViewController, FeedPostDelegate, PopupDelegate, ModalNewPostDelegate, NotifyRiderDelegate{
    
    //Scroll view
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .green
        return v
    }()
    
    //Collection View
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor().colorWithHexString(hex: "#cfcecb", alpha: 0.75)
        return view
    }()
    
    //Messages ViewController
    var messageVC = SingleChatViewController()
    
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
        
        //Setup Scrollview
        scrollView.contentSize.width = view.frame.size.width * 2
        
        //Add scrollview
        view.addSubview(scrollView)
    
        // constrain the scroll view to 8-pts on each side
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        scrollView.isPagingEnabled = true
        
        //Add colelctionview
        scrollView.addSubview(collectionView)
        
        //Set up collection Adapter
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        //Add Refresh To Collection View
        self.refresher = UIRefreshControl()
        self.collectionView.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.black
        self.refresher.addTarget(self, action: #selector(fetchFeed), for: .valueChanged)
        self.collectionView.refreshControl = refresher
        
        //Add message button to nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
        //Grab All posts
        fetchFeed()

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
    
    @objc func addTapped(){
        let vc = MainChatViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func fetchFeed(){
        //Start refresh control
        collectionView.refreshControl?.beginRefreshing()
        
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
    
    func notifyRider(postKey: String){
        var vc = PopupManager.shared.notifyRider(postKey: postKey)
        if let notifyVc = vc.viewController as? NotifyRiderPopupViewController{
            notifyVc.delegate = self
        }
        Network.shared.notifyRider(postKey: postKey)
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
    
    func showDriverPayout(){
        print("Take the user to the driver page")
        tabBarController?.selectedIndex = 4
        if let navController = tabBarController?.viewControllers![4] as? UINavigationController{
            if let vc = navController.viewControllers[0] as? ProfileViewController{
                vc.showDriverPayout()
            }
        }
    }
    
    func pushPostViewController(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func notifyRiderFromPopup(){
        
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
