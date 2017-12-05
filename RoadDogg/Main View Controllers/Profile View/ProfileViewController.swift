//
//  ProfileViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/24/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import UIKit
import Stripe
import IGListKit

class ProfileViewController : UIViewController {
    
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
    
    var selfUser = RealmManager.shared.selfUser!
    var profileArray : [AnyObject] = []
    
    //Refresher
    var refresher:UIRefreshControl!
    
    //Self User
    var user: loggedInUser!
    
    //All of the users post
    var posts : [Post] = []
    
    //profile Token
    let searchToken: NSNumber = 42
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //Navigation bar
        self.title = "Profile"
        
        //Make tab bar visible
        tabBarController?.tabBar.isHidden = false
        
        //Add colelctionview
        view.addSubview(collectionView)
        
        //Set up collection Adapter
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        //Add user to user array
        profileArray.append( RealmManager.shared.selfUser! )
        
        //Add Refresh To Collection View
        self.refresher = UIRefreshControl()
        self.collectionView.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.black
        self.refresher.addTarget(self, action: #selector(fetchUserFeed), for: .valueChanged)
        self.collectionView.refreshControl = refresher
        self.collectionView.refreshControl?.beginRefreshing()
        
        //Fetch the post by the user
        fetchUserFeed()
        
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
    
    func showPayment(){
        print("We are now on the payment page, push the view controller for payments")
        //Setup payment methods view controller
        let vc = STPPaymentMethodsViewController(configuration: STPPaymentConfiguration.shared(), theme: STPTheme.default(), customerContext: PaymentManager.shared.customerContext, delegate: self)
        self.tabBarController?.tabBar.isHidden = true
        
        // Present add card view controller
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func fetchUserFeed(){
        print("there is no key here")
        Network.shared.getUserFeed(user_key: self.selfUser.key).then { feed -> Void in
            //If there are anypost
            if ( feed.posts.count > 0 ){
                guard let post = feed.posts[0] as? Post else {
                    //If they do not hav any post add a section controller saying they dont have any post
                    return
                }
                guard let user = post.user as? User else {
                    //The user has no post
                    return
                }
                //Save the user
                print(self.selfUser)
                RealmManager.shared.updateLoggedInUser(loggedInUser: self.selfUser, user: user )
            
                
                self.posts = feed.posts as! [Post]
            }
            
            //End Refreshing
            self.collectionView.refreshControl?.endRefreshing()
            
            self.adapter.performUpdates(animated: true, completion: nil)
            
            }.catch { error -> Void in
                print(error)
        }
    }
}

extension ProfileViewController: ListAdapterDataSource {
    
    
    // 1
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        //Set the logged in user
        RealmManager.shared.getLoggedInUser()
        let user = RealmManager.shared.selfUser!
        return [user] + posts
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
                return SelfProfileSectionController()
        }
        
    }
    
    // 3
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
        
    } //Return a certatin view later
}

// MARK: STPPaymentMethodsViewControllerDelegate
extension ProfileViewController: STPPaymentMethodsViewControllerDelegate{
    
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        // Dismiss payment methods view controller
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
        // Present error to user...
    }
    
    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        // Dismiss payment methods view controller
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        // Dismiss payment methods view controller
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didSelect paymentMethod: STPPaymentMethod) {
        // Save selected payment method
        RealmManager.shared.paymentVerified()
    }
    
    
}


