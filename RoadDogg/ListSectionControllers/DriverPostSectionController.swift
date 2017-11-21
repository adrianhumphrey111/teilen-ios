//
//  DriverPostSectionController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/20/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import IGListKit
import Reusable
import SDWebImage

class DriverPostSectionController : ListSectionController{
    
    var post: Post!
    var trip: Trip!
    var user: User!
    
    override init(){
        super.init()
        inset =  UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
}

extension DriverPostSectionController  {
    
    override func numberOfItems() -> Int {
        return 6
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let cellWidth = ((collectionContext?.containerSize.width)! - 20)
        switch index{
        case 0, 1:
            return CGSize(width: cellWidth, height: 65)
        case 2:
            //Get estimation of the height of the cell
            let text = self.post.text
            let size = CGSize(width: cellWidth, height: 1000)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: self.post.fontSize )]
            let estiamtedFrame = NSString( string: text ).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            return CGSize(width: cellWidth, height: estiamtedFrame.height + 15)
        case 3, 4, 5:
            return CGSize(width: cellWidth, height: 35)
        default:
            return CGSize(width: 100, height: 100)
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        
        switch index{
        case 0:
            let cellClass : String = PostHeaderCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureHeaderCell( cell: cell )
            return cell
        case 1:
            let cellClass : String = RideInformationCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureRideInformationCell( cell: cell )
            return cell
        case 2:
            let cellClass : String = PostTextViewCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureTextCell( cell: cell )
            return cell
        case 3:
            let cellClass : String = TimeStampCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureTimeStampCell( cell: cell )
            return cell
        case 4:
            let cellClass : String = LikeCommentCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureLikeCommentCell( cell: cell )
            return cell
        case 5:
            let cellClass : String = ActionCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureActionCell( cell: cell )
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    override func didUpdate(to object: Any) {
        self.post = object as? Post
        self.trip = self.post.trip
        self.user = self.post.user
    }
    
    override func didSelectItem(at index: Int) {
        //Nothing
    }
    
    func configureHeaderCell(cell: UICollectionViewCell) {
        
        if let cell = cell as? PostHeaderCollectionViewCell{
            cell.usernameLabel.text = "@username"
            cell.fullNameLabel.text = self.user.fullName
            
            //Make profile image round
            cell.profileImageView.layer.borderWidth = 1
            cell.profileImageView.layer.masksToBounds = false
            cell.profileImageView.backgroundColor = .black
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2
            cell.profileImageView.clipsToBounds = true
            
            //Set the profile image
            cell.profileImageView.sd_setImage(with: URL(string: self.user.profileUrl) ) //TODO: Change to with placeholder
            cell.backgroundColor = .red
        }
    }
    
    func configureTextCell(cell : UICollectionViewCell){
        if let cell = cell as? PostTextViewCollectionViewCell{
            cell.textView.text = self.post.text
            cell.textView.font = UIFont.systemFont(ofSize: self.post.fontSize)
        }
    }
    
    func configureRideInformationCell(cell: UICollectionViewCell){
        if let cell = cell as? RideInformationCollectionViewCell{
            cell.startToEndLabel.text = "Isla Vista -> San Francisco"
            cell.priceLabel.text = "$25"
            cell.backgroundColor = .white
        }
    }
    
    func configureTimeStampCell(cell: UICollectionViewCell){
        if let cell = cell as? TimeStampCollectionViewCell{
            cell.backgroundColor = .blue
        }
    }
    
    func configureLikeCommentCell(cell: UICollectionViewCell){
        if let cell = cell as? LikeCommentCollectionViewCell{
            cell.backgroundColor = .red
        }
    }
    
    func configureActionCell(cell: UICollectionViewCell){
        if let cell = cell as? ActionCollectionViewCell{
            cell.backgroundColor = .black
        }
    }

    
}
