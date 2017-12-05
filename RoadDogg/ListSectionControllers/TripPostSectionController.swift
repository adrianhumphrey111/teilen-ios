//
//  TripPostSectionController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/26/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation


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

class TripPostSectionController : ListSectionController, PostActionDelegate{
    
    var post: Post!
    var trip: Trip!
    var user: User!
    
    var tripBooked : Bool = false
    
    override init(){
        super.init()
        inset =  UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
}

extension TripPostSectionController  {
    
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
            if (self.trip.postedBy == "driver"){
                let cellClass : String = RideInformationCollectionViewCell.reuseIdentifier
                let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
                configureRideInformationCell( cell: cell )
                return cell
            }
            else{
                let cellClass : String = RiderInformationCollectionViewCell.reuseIdentifier
                let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
                configureRiderInformationCell( cell: cell )
                return cell
            }
            
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
            if (self.trip.postedBy == "driver"){
                let cellClass : String = DriverButtonCollectionViewCell.reuseIdentifier
                let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
                configureDriverButtonCell( cell: cell )
                return cell
            }
            else{
                let cellClass : String = RideButtonCollectionViewCell.reuseIdentifier
                let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
                configureRiderButtonCell( cell: cell )
                return cell
            }
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
            print("The profile should be shown now")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier :"FriendProfile") as! FriendProfileViewController
            vc.user = self.post?.user
            vc.profileArray.append( self.post?.user as AnyObject )
            viewController?.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    func pushPostViewController(vc: UIViewController) {
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func performUpdatesForLike() {
        if let vc = viewController as? TripViewController{
            vc.adapter.collectionView?.reloadData()
        }
    }
    
    func reserveSeat() {
        if let vc = viewController as? TripViewController{
            //Show Reserve Seat Popup Over
            vc.reserveSeat(price: self.trip.ratePerSeat!, postKey: self.post.postKey)
        }
    }
    
    func notifyRider() {
        if let vc = viewController as? TripViewController{
            
        }
    }
    
    func showKeyboard() {
        if let vc = viewController as? TripViewController{
            vc.showKeyboard()
        }
    }
    
    func showOptions() {
        //Show options
        //Show options
        var message = ""
        
        if ( self.post.user.key == RealmManager.shared.selfUser!.key ){
            //If this is the users own post, ask to delete it
            message = "Are you sure that you want to delete this post?"
        }else{
            //If this is someone else post, ask to report it
            message = "Are you sure that you want to report this post?"
        }
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let reportAction = UIAlertAction(title: "Report Post", style: .default) { action in
            // ... Report this post pop up
        }
        
        let deleteAction = UIAlertAction(title: "Delete Post", style: .default){ action in
            print("Delete this post")
            Network.shared.deletePost(postKey: self.post.postKey).then{ success -> Void in
                //Call a refresh on the page
                if let vc = self.viewController as? IGListFeedViewController{
                    vc.fetchFeed()
                }
            }
        }
        
        if ( self.post.user.key == RealmManager.shared.selfUser!.key ){
            //If this is the users own post, ask to delete it
            alertController.addAction(deleteAction)
        }else{
            //If this is someone else post, ask to report it
            alertController.addAction(reportAction)
        }
        
        
        
        viewController?.present(alertController, animated: true) {
            // ...
    }
    }
    
    func configureHeaderCell(cell: UICollectionViewCell) {
        
        if let cell = cell as? PostHeaderCollectionViewCell{
            let eta = self.post.trip!.eta
            cell.etaLabel.text = self.post.trip?.chosenTime == "departure" ? "Est. Dpt: \(eta!)" : "Est. Arv: \(eta!)"
            cell.fullNameLabel.text = self.user.fullName
            
            //Make profile image round
            cell.profileImageView.layer.masksToBounds = false
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2
            cell.profileImageView.clipsToBounds = true
            
            //Set the profile image
            cell.profileImageView.sd_setImage(with: URL(string: self.user.profileUrl), placeholderImage: UIImage(named: "Profile_Placeholder") ) //TODO: Change to with placeholder
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
            let dollarAmount : Int = self.trip.ratePerSeat / 100
            cell.priceLabel.text = "$\(dollarAmount)"
            cell.priceLabel.textColor = .green
            cell.seatsAvailableLabel.text = "\(self.trip.seatsAvailable!)"
        }
    }
    
    func configureRiderInformationCell(cell: UICollectionViewCell){
        if let cell = cell as? RiderInformationCollectionViewCell{
            cell.startEndLabel.text = "\(self.trip.startLocation.city!) -> \(self.trip.endLocation.city!)"
            cell.backgroundColor = .white
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
    
    func configureRiderButtonCell(cell : UICollectionViewCell){
        if let cell = cell as? RideButtonCollectionViewCell{
            cell.delegate = self
        }
    }
    
    func configureTimeStampCell(cell: UICollectionViewCell){
        let date = self.post.createdAt.dateFromISO8601 //.description(with: Locale.current )
        if let cell = cell as? TimeStampCollectionViewCell{
            cell.timeStampLabel.text = self.post.timeStamp
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
            cell.feed = false
        }
    }
    
    func shareAction() {
        // text to share
        let text = "This is some text that I want to share."
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController?.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    
}
