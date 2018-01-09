//
//  MainChatViewController.swift
//  Teilen
//
//  Created by Adrian Humphrey on 1/6/18.
//  Copyright © 2018 Adrian Humphrey. All rights reserved.
//

import Foundation
import UIKit
import IGListKit


class MainChatViewController : UIViewController{
    
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
    var users : [User] = []
    
    //Refresher
    var refresher:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Make tab bar visible
        tabBarController?.tabBar.isHidden = false
        self.title = "Messages"
        
        //Add colelctionview
        view.addSubview(collectionView)
        
        //Set up collection Adapter
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        //Add Refresh To Collection View
        self.refresher = UIRefreshControl()
        self.collectionView.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.black
        self.refresher.addTarget(self, action: #selector(fetchChatRooms), for: .valueChanged)
        self.collectionView.refreshControl = refresher
        
        //Add message button to nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Make tab bar visible
        self.adapter.performUpdates(animated: true, completion: nil)
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
    
    @objc func addTapped(){
        //Do Nothing
    }
    
    @objc func fetchChatRooms(){
        //Start refresh control
        collectionView.refreshControl?.beginRefreshing()
        Network.shared.fetchChatRooms()
    }
    
}

extension MainChatViewController: ListAdapterDataSource {
    // 1
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return (self.users as? [ListDiffable])!
    }
    
    // 2
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ChatRoomsSectionController()
    }
    
    // 3
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let vc = EmptyMainChatRoomViewController(nibName: "EmptyMainChatRoomViewController", bundle: nil)
        self.addChildViewController( vc )
        vc.didMove(toParentViewController: self)
        return vc.view
    }
}

