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

class RiderPostSectionContoller : ListSectionController, PostActionDelegate{
    
    
    var post: Post!
    var trip: Trip!
    var user: User!
    
    override init(){
        super.init()
        inset =  UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
}

extension RiderPostSectionContoller  {
    
    override func numberOfItems() -> Int {
        return 7
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let cellWidth = ((collectionContext?.containerSize.width)! - 20)
        switch index{
        case 0:
            return CGSize(width: cellWidth, height: 65)
        case 1:
            return CGSize(width: cellWidth, height: 50)
        case 2:
            //Get estimation of the height of the cell
            let text = self.post.text
            let size = CGSize(width: cellWidth, height: 1000)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: self.post.fontSize )]
            let estiamtedFrame = NSString( string: text ).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            return CGSize(width: cellWidth, height: estiamtedFrame.height + 10)
        case 3:
            return CGSize(width: cellWidth, height: 45)
        case 4, 5, 6:
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
            let cellClass : String = RideButtonCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureRiderButtonCell( cell: cell )
            return cell
        case 5:
            let cellClass : String = LikeCommentCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureLikeCommentCell( cell: cell )
            return cell
        case 6:
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
        switch index{
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier :"FriendProfile") as! FriendProfileViewController
            vc.user = self.post?.user
            viewController?.navigationController?.pushViewController(vc, animated: true)
        case 1,2:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier :"Trip") as! TripViewController
            vc.tripArray.append( self.post )
            vc.tripArray += self.post.comments.comments
            viewController?.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    func pushPostViewController(vc: UIViewController) {
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func performUpdatesForLike() {
        if let vc = viewController as? IGListFeedViewController{
            vc.adapter.collectionView?.reloadData()
        }
    }
    
    func reserveSeat() {
        if let vc = viewController as? IGListFeedViewController{
            
        }
    }
    
    func notifyRider() {
        if let vc = viewController as? IGListFeedViewController{
            
        }
    }
    
    func configureHeaderCell(cell: UICollectionViewCell) {
        
        if let cell = cell as? PostHeaderCollectionViewCell{
            cell.usernameLabel.text = "@username"
            cell.fullNameLabel.text = self.user.fullName
            
            //Make profile image round
            cell.profileImageView.layer.masksToBounds = false
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2
            cell.profileImageView.clipsToBounds = true
            
            //Set the profile image
            cell.profileImageView.sd_setImage(with: URL(string: self.user.profileUrl) ) //TODO: Change to with placeholder
            cell.backgroundColor = .clear
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
            cell.startToEndLabel.text = "\(self.trip.startLocation.city!) -> \(self.trip.endLocation.city!)"
            cell.backgroundColor = .white
            
            if ( self.post.trip?.postedBy == "ridker"){
                print("Why in the fuck are these being hidden!!")
                cell.priceLabel.isHidden = true
                cell.seatsAvailableLabel.isHidden = true
                cell.seatsAvailableIcon.isHidden = true
            }
        }
    }
    
    func configureRiderButtonCell(cell : UICollectionViewCell){
        if let cell = cell as? RideButtonCollectionViewCell{
            cell.delegate = self
            
        }
    }
    
    func configureTimeStampCell(cell: UICollectionViewCell){
        if let cell = cell as? TimeStampCollectionViewCell{
            cell.backgroundColor = .white
            cell.timeStampLabel.text = self.post.createdAt
        }
    }
    
    func configureLikeCommentCell(cell: UICollectionViewCell){
        if let cell = cell as? LikeCommentCollectionViewCell{
            cell.backgroundColor = .white
            //Like Label
            switch self.post.likeCount{
            case 1:
                cell.likeLabel.text = "1 Like"
            default:
                cell.likeLabel.text = "\(self.post.likeCount) Likes"
            }
            
            //Coment Label
            switch self.post.commentCount{
            case 1:
                cell.commentLabel.text = "1 Comment"
            default:
                cell.commentLabel.text = "\(self.post.commentCount) Comments"
            }
        }
    }
    
    func configureActionCell(cell: UICollectionViewCell){
        if let cell = cell as? ActionCollectionViewCell{
            cell.backgroundColor = .clear
            cell.likeButton.setTitle("Like", for: .normal)
            cell.likeButton.setTitleColor(.gray, for: .normal)
            cell.commentButton.setTitle("Comment", for: .normal)
            cell.commentButton.setTitleColor(.gray, for: .normal)
            cell.shareButton.setTitle("Share", for: .normal)
            cell.shareButton.setTitleColor(.gray, for: .normal)
            cell.post = self.post
            cell.delegate = self
        }
    }
    
    func showKeyboard() {
        //Show keyboard
    }
    
}
