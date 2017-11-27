//
//  SelfProfileSectionController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/24/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//
import Foundation
import IGListKit
import Reusable
import SDWebImage

class SelfProfileSectionController : ListSectionController{
    
    
    var user : loggedInUser!
    
    override init(){
        super.init()
        inset =  UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
}

extension SelfProfileSectionController  {
    
    override func numberOfItems() -> Int {
        return 8
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let cellWidth = ((collectionContext?.containerSize.width)! - 20)
        switch index{
        case 0:
            return CGSize(width: cellWidth, height: 260) //Height of top main square
        default:
            return CGSize(width: cellWidth, height: 50) //Every other cell for the users settings
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        switch index{
        case 0:
            let cellClass : String = ProfileHeaderCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureProfileHeaderCell( cell: cell )
            return cell
        default:
            //Use the index to configure the cell
            let cellClass : String = ProfileSettingCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureSettingCell( cell: cell, ndx: index )
            return cell
        }
        
    }
    
    override func didUpdate(to object: Any) {
        self.user = object as? loggedInUser
    }
    
    override func didSelectItem(at index: Int) {

    }
    
    
    func configureProfileHeaderCell(cell: UICollectionViewCell) {
        if let cell = cell as? ProfileHeaderCollectionViewCell{
            cell.userProfileImageView.image = RealmManager.shared.loadImage( fileName: self.user.imageFileName )
        }
    }
    
    func configureSettingCell(cell: UICollectionViewCell, ndx: Int){
        if let cell = cell as? ProfileSettingCollectionViewCell{
            switch ndx {
            case 0:
                cell.settingLabel.text = "Your Profile"
            case 1:
                cell.settingLabel.text = "Help"
            case 2:
                cell.settingLabel.text = "Get Paid"
            case 3:
                cell.settingLabel.text = "Payment"
            case 4:
                cell.settingLabel.text = "About"
            case 5:
                cell.settingLabel.text = "Sign Out"
            case 6:
                cell.settingLabel.text = "Delete Account"
            default:
                return
            }
        }
    }

}

