//
//  Notification View.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/24/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

class NotificationViewController : UIViewController {
    
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
    
    var notifications : [TNotification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Navigation bar
        self.title = "Notifications"
        
        //Make tab bar visible
        tabBarController?.tabBar.isHidden = false
        
        //Add colelctionview
        view.addSubview(collectionView)
        
        //Set up collection Adapter
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        //Grab all the notification
        fetchNotifications()
        
        //Add Refresh To Collection View
        self.refresher = UIRefreshControl()
        self.collectionView.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(fetchNotifications), for: .valueChanged)
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
        self.tabBarController?.tabBar.isTranslucent = false
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func fetchNotifications(){
        Network.shared.getNotifications().then { notifications -> Void in
            //End Refreshing
            self.collectionView.refreshControl?.endRefreshing()
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
}
    
extension NotificationViewController: ListAdapterDataSource {
        // 1
        func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
            return ( RealmManager.shared.getNotifications() as? [ListDiffable])!
        }
        
        // 2
        func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
            return NotificationSectionController()
            
        }
        
        // 3
        func emptyView(for listAdapter: ListAdapter) -> UIView? {
            print("You have no ntotications")
            return nil
            
        } //Return a certatin view later
}
    

