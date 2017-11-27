//
//  FriendProfileHeadSectionController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/27/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import IGListKit

class FriendProfileHeadSectionController : ListSectionController{
    
    var user: User!
    
    override init(){
        super.init()
        inset =  UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
}


extension FriendProfileHeadSectionController  {

    override func numberOfItems() -> Int {
        return 3
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let cellWidth = ((collectionContext?.containerSize.width)! - 20)
        switch index {
        case 0:
            return CGSize(width: cellWidth, height: 120)
        case 1:
            return CGSize(width: cellWidth, height: 50)
        case 2:
            if let car = self.user.car{
                return CGSize(width: cellWidth, height: 150)
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
        default:
            return UICollectionViewCell()
        }
        
    }
    
    override func didUpdate(to object: Any) {
        self.user = object as? User
    }
    
    override func didSelectItem(at index: Int) {
        //Nothing
    }
    
    func configureFriendHeadCell(cell: UICollectionViewCell){
        if let cell = cell as? FriendHeadCollectionViewCell{
            cell.profileImageView.sd_setImage(with: URL(string: self.user.profileUrl))
            
            //Add friend cell
            if (user.isFriend){
                cell.addFrindButton.setTitle("Unfriend", for: .normal)
                cell.addFrindButton.setTitleColor(.white, for: .normal)
                cell.addFrindButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
                cell.addFrindButton.layer.cornerRadius = 8
            }
        }
    }
    
    func configureFriendInfoCell(cell: UICollectionViewCell){
        if let cell = cell as? FriendInfoCollectionViewCell{
            cell.fullNameLabel.text = self.user.fullName
            
            //Check if the user has a car
            if let car = self.user.car {
                //Do what ever
            }
            else{
                cell.layer.cornerRadius = 8
            }
        }
    }
    
    func configureFriendCarCell(cell: UICollectionViewCell){
        if let cell = cell as? FriendCarCollectionViewCell{
            
        }
    }
    
}
