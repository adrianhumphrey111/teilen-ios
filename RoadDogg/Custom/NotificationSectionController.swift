//
//  NotificationSectionController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/23/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import IGListKit
import Reusable
import SDWebImage
import PopupDialog

class NotificationSectionController : ListSectionController {
    
    var notification: realmNotification!
    
    override init(){
        super.init()
        inset =  UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
}

extension NotificationSectionController {
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        //Get estimation of the height of the cell - con10 - imagewidth45 - cont5 - cont5 - button width60 - con10
        let cellWidth = ((collectionContext?.containerSize.width)! - 20 )
        let text = self.notification.message
        var estimatedWidth : CGFloat = cellWidth - 135
        let size = CGSize(width: estimatedWidth, height: 1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18 )]
        let estiamtedFrame = NSString( string: text ).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return CGSize(width: cellWidth, height: estiamtedFrame.height + 20) //10 at top and bottom
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        switch self.notification.type{
        case "seat_request":
            let cellClass : String = RequestNotificationCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureNotificationCell( cell: cell )
            return cell
        default:
            let cellClass : String = RequestNotificationCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureNotificationCell( cell: cell )
            return cell
        }
        
    }
    
    override func didUpdate(to object: Any) {
        self.notification = (object as? realmNotification)!

    }
    
    override func didSelectItem(at index: Int) {
        return
    }
    
    func configureNotificationCell(cell: UICollectionViewCell){
        if let cell = cell as? RequestNotificationCollectionViewCell{
            //Set the profile image
            cell.imageView.sd_setImage(with: URL(string: self.notification.userProlfileUrl) ) //TODO: Change to with placeholder
            cell.messageTextView.text = self.notification.message
            
            //Set notification
            cell.notification = self.notification
            
            cell.configure()
        }
    }
}
