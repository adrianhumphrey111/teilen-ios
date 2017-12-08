
//
//  FriendProfileHeadSectionController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/27/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import IGListKit
import Reusable
import SDWebImage

class SelfProfileSectionController : ListSectionController, ProfileActionDelegate, StartTripDelegate{

    var user : loggedInUser!
    
    override init(){
        super.init()
        inset =  UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func showSettings(){
        let vc = SettingsViewController()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPayments(){
        if let vc = viewController as? ProfileViewController{
            vc.showPayment()
        }
    }
}


extension SelfProfileSectionController  {
    
    override func numberOfItems() -> Int {
        return 4
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let cellWidth = ((collectionContext?.containerSize.width)! - 20)
        switch index {
        case 0:
            return CGSize(width: cellWidth, height: 120)
        case 1:
            return CGSize(width: cellWidth, height: 65)
        case 2:
            if let car = self.user.car{
                return CGSize(width: cellWidth, height: 150)
            }
            else{
                return CGSize(width: cellWidth, height: 0)
            }
        case 3:
            if let currentTrip = self.user.currentTripKey {
                return CGSize(width: cellWidth, height: 65)
            }
            else{
                return CGSize(width: cellWidth, height: 0)
            }
        default:
            return CGSize(width: 100, height: 100)
        }
        
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        switch index {
        case 0:
            let cellClass : String = FriendHeadCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureFriendHeadCell( cell: cell )
            return cell
        case 1:
            let cellClass : String = FriendInfoCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureFriendInfoCell( cell: cell )
            return cell
        case 2:
            let cellClass : String = FriendCarCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureFriendCarCell( cell: cell )
            return cell
        case 3:
            let cellClass : String = StartTripButtonCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureStartTripButtonCell( cell: cell )
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    override func didUpdate(to object: Any) {
       //Dont do anything
        self.user = object as? loggedInUser
    }
    
    override func didSelectItem(at index: Int) {
        //Nothing
    }
    
    func startTrip() {
        //Sho the start trip view controller
        if let vc = self.viewController as? ProfileViewController{
            vc.showActiveTrip()
        }
    }
    
    func configureStartTripButtonCell(cell: UICollectionViewCell){
        if let cell = cell as? StartTripButtonCell{
            cell.delegate = self
            if let city = self.user.currentTripDestinationCity {
                cell.startButton.setTitle("Start Your Trip to \(city)", for: .normal)
            }
            
        }
    }
    
    func configureFriendHeadCell(cell: UICollectionViewCell){
        if let cell = cell as? FriendHeadCollectionViewCell{
            
            cell.numberOfTripsLabel.text = "\(self.user.numberOfTrips)"
            cell.numberOfFriendsLabel.text = "\(self.user.numberOfFriends)"
            cell.numberOfPostsLabel.text = "\(self.user.numberOfPosts)"
            cell.profileImageView.sd_setImage(with: URL(string: (self.user.profileUrl)), placeholderImage: UIImage(named: "Profile_Placeholder"))
            
            cell.userKey = self.user.key
            
            //Configure the look of the profile page
            cell.isOwnProfile = true
            cell.delegate = self
            
            //Change add friend to edit profile
            cell.addFrindButton.layer.borderColor = UIColor.black.cgColor
            cell.addFrindButton.layer.cornerRadius = 8
            cell.addFrindButton.layer.borderWidth = 1
            cell.addFrindButton.setTitleColor(.black, for: .normal)
            cell.addFrindButton.setTitle("Settings", for: .normal)
            cell.addFriendImageView.image = nil
            cell.addFrindButton.contentHorizontalAlignment = .center
            cell.addFrindButton.titleEdgeInsets.left = 0
            
            //Change message button to settings button
            cell.messageButton.setImage( UIImage(named: "Gray_Card"), for: .normal)
        }
    }
    
    func configureFriendInfoCell(cell: UICollectionViewCell){
        if let cell = cell as? FriendInfoCollectionViewCell{
            cell.fullNameLabel.text = self.user.fullName()
            
            //Set the current trip
            if let dest = self.user.currentTripDestinationCity as? String{
                cell.currentTripLabel.text = "Headed to \(self.user.currentTripDestinationCity!) on \(self.user.currentTripDate!)"
            }
            
            //Check if the user has a car
            if let car = self.user.car {
                //Do what ever
            }
            else{
                cell.roundBackgroundView.layer.cornerRadius = 8
            }
        }
    }
    
    func configureFriendCarCell(cell: UICollectionViewCell){
        if let cell = cell as? FriendCarCollectionViewCell{
            
        }
    }
    
}

