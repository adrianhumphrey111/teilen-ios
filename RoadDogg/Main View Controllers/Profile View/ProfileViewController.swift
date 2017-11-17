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


class ProfileViewController : UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //Set Payment Context Delegate
        PaymentManager.shared.paymentContext.delegate = self
    }
    
    func didSelectSettingRow(row: Int){
        switch row {
        case 0:
            //Push new controller onto nav controller Driver Profile
            return
        case 1:
            //Push new controller onto nav controller Settings
            return
        case 2:
            //Push new controller onto nav controller Payment
            

            // Setup payment methods view controller
            let vc = STPPaymentMethodsViewController(configuration: STPPaymentConfiguration.shared(), theme: STPTheme.default(), customerContext: PaymentManager.shared.customerContext, delegate: self)
            self.tabBarController?.tabBar.isHidden = true
            
            // Present add card view controller
            self.navigationController?.pushViewController(vc, animated: true)
            
            //Remove both back buttons
            self.navigationController?.navigationBar.backItem?.backBarButtonItem = nil
            return
        case 3:
            //Push new controller onto nav controller Help
            return
        case 4:
            //Push new controller onto nav controller Sign out
            PaymentManager.shared.requestCharge(amount: 50)
            return
        default:
            print("Error")
        }
    }
    
}

extension ProfileViewController: STPPaymentContextDelegate{
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        //Handle Payment failing with error,
        print("Payment failed with error => " , error)

    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        //        self.activityIndicator.animating = paymentContext.loading  update UI
        //        self.paymentButton.enabled = paymentContext.selectedPaymentMethod != nil
        //        self.paymentLabel.text = paymentContext.selectedPaymentMethod?.label
        //        self.paymentIcon.image = paymentContext.selectedPaymentMethod?.image
        print("Payment did change")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        print("The payment deleagte was called")
        MyAPIClient.sharedClient.completeCharge(paymentResult, amount: 50, shippingAddress: paymentContext.shippingAddress, shippingMethod: paymentContext.shippingMethods?[0], completion: completion)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        switch status {
        case .error:
            //self.showError(error)
            print(error)
            return
        case .success:
            //self.showReceipt()
            print("Success:")
            return
        case .userCancellation:
            return // Do nothing
        }
    }
    
    
}

extension ProfileViewController: STPPaymentMethodsViewControllerDelegate{
    
    // MARK: STPPaymentMethodsViewControllerDelegate
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        // Dismiss payment methods view controller
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
        print("What the fuck")
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
        //RealmManager.shared.selfUser?.selectedPaymentMethod = paymentMethod
        //RealmManager.shared.updateLoggedInUser()
    }
    
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Do Nothing
        self.didSelectSettingRow( row: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if (indexPath.section == 0){
            return CGSize(width: view.frame.width, height: 300.0)
        }
        else{
            return CGSize(width: view.frame.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ( section == 0 ) ? 1 : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //top. left. bottom. right
        return UIEdgeInsetsMake(0, 0, 20, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "profileHeaderCell", for: indexPath) as! UserProfileHeadViewCell
            configureHeaderCell(cell : cell)
            return cell
        }
        else{
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "settingCell", for: indexPath) as! ProfileSettingViewCell
            configureSettingCell(cell: cell, indexPath: indexPath)
            return cell
        }
    }
    
    func configureSettingCell(cell: ProfileSettingViewCell, indexPath: IndexPath){
        //Use the index Path to configure which cell to set up
        cell.backgroundColor = .blue
        
        //Set cell tag to map to correct func
        switch indexPath.row {
        case 0:
            cell.settingLabel.text = "Your Profile"
        case 1:
            cell.settingLabel.text = "Settings"
        case 2:
            cell.settingLabel.text = "Payment"
        case 3:
            cell.settingLabel.text = "Help"
        case 4:
            cell.settingLabel.text = "Sign Out"
        default:
            print("Error")
        }

    }
    
    func configureHeaderCell( cell: UserProfileHeadViewCell){
        //Configure the main header cell for the profile
        cell.userNameLabel.frame.origin.x = cell.userProfileView.frame.origin.x
        cell.carNameLabel.frame.origin.x = cell.carImageView.frame.origin.x
        cell.editButton.frame.origin.x = cell.userProfileView.frame.origin.x
        cell.changeButton.frame.origin.x = cell.carImageView.frame.origin.x
    }
    
}
