//
//  ActiveTripViewController.swift
//  Teilen
//
//  Created by Adrian Humphrey on 12/7/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import IGListKit

class ActiveTripViewController: UIViewController {
    
    var currentTripKey : String!
    
    var users : [User] = []
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Current Trip"
        
        //Add colelctionview
        view.addSubview(collectionView)
        
        //Set up collection Adapter
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        fetchCurrentTripInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc func fetchCurrentTripInfo(){
        Network.shared.fetchCurrentTrip(tripKey: self.currentTripKey).then { users -> Void in
            self.users = users
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }

}

extension ActiveTripViewController: ListAdapterDataSource {

    // 1
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        //Set the logged in user
        //RealmManager.shared.getLoggedInUser()
//        let user = RealmManager.shared.selfUser!
        // [user] + posts
        return (self.users as? [ListDiffable])!
        
    }
    
    // 2
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
       return DirectionSectionController()
    }
    
    // 3
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        
        let vc = EmptyTripViewController(nibName: "EmptyTripViewController", bundle: nil)
        self.addChildViewController( vc )
        vc.didMove(toParentViewController: self)
        return vc.view
        
    } //Return a certatin view later

}
