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
    
 
    
}

extension ProfileViewController: ListAdapterDataSource {
    // 1
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let selfUser = RealmManager.shared.selfUser!
        let userArr : [loggedInUser] = [selfUser]
        return (userArr as? [ListDiffable])!
    }
    
    // 2
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return SelfProfileSectionController()
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


