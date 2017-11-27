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
import PopupDialog

class DriverPostSectionController : ListSectionController, PostActionDelegate{

    
    var post: Post!
    var trip: Trip!
    var user: User!
    
    var tripBooked : Bool = false
    
    override init(){
        super.init()
        inset =  UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
}

extension DriverPostSectionController  {
    
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
            let cellClass : String = DriverButtonCollectionViewCell.reuseIdentifier
            let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
            configureDriverButtonCell( cell: cell )
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
        self.tripBooked = self.trip.passengerKeys.contains( RealmManager.shared.selfUser!.key ) ? true : false
    }
    
    override func didSelectItem(at index: Int) {
        switch index{
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier :"FriendProfile") as! FriendProfileViewController
            vc.user = self.post?.user
            vc.profileArray.append( self.post?.user as AnyObject )
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
            //Show Reserve Seat Popup Over
            vc.reserveSeat(price: self.trip.ratePerSeat!, postKey: self.post.postKey)
        }
    }
    
    func notifyRider() {
        if let vc = viewController as? IGListFeedViewController{
            
        }
    }
    
    func showKeyboard() {
        //show keyboard
    }
    
    func configureHeaderCell(cell: UICollectionViewCell) {
        
        if let cell = cell as? PostHeaderCollectionViewCell{
            cell.usernameLabel.text = "@username"
            cell.fullNameLabel.text = self.user.fullName
            
            //Set the profile image
            cell.profileImageView.sd_setImage(with: URL(string: self.user.profileUrl) ) //TODO: Change to with placeholder
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
            let dollarAmount : Int = self.trip.ratePerSeat / 100
            cell.priceLabel.text = "$\(dollarAmount)"
            cell.priceLabel.textColor = .green
            cell.seatsAvailableLabel.text = "\(self.trip.seatsAvailable!)"
        }
    }
    
    func configureDriverButtonCell(cell : UICollectionViewCell){
        if let cell = cell as? DriverButtonCollectionViewCell{
            cell.delegate = self
            if ( self.trip.seatsAvailable > 0 ){
                cell.driverButton.setTitle("Reserve Seat", for: .normal)
            }
            else if( self.tripBooked ){
                cell.driverButton.setTitle("Trip Booked", for: .normal)
            }
            else{
                cell.driverButton.setTitle("Join Waitlist", for: .normal)
            }
        }
    }
    
    func configureTimeStampCell(cell: UICollectionViewCell){
        let date = self.post.createdAt.dateFromISO8601 //.description(with: Locale.current )
        if let cell = cell as? TimeStampCollectionViewCell{
            cell.timeStampLabel.text = self.post.createdAt
        }
    }
    
    func configureLikeCommentCell(cell: UICollectionViewCell){
        if let cell = cell as? LikeCommentCollectionViewCell{
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
            cell.post = self.post
            cell.delegate = self
        }
    }

}
