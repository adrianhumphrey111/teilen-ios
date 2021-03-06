//
//  Post.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/29/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

class Post{
    
    var user : User!
    var text = ""
    var postKey = ""
    var likeCount : Int = 0
    var commentCount : Int = 0
    var isLiked : Bool = false
    var comments = Comments()
    var liked = false
    var createdAt = ""
    var timeStamp = ""
    public var fontSize : CGFloat = 20
    var textHeight : CGFloat = 0.0
    var trip : Trip? = nil
    var likeCountString : String {
        get{
            if ( likeCount == 1){
                return "\(likeCount) Like"
            }
            else{
               return "\(likeCount) Likes"
            }
            
        }
    }
    var commentCountString : String {
        get{
            if ( commentCount == 1){
                return "\(commentCount) Comment"
            }
            else{
                return "\(commentCount) Comments"
            }
        }
    }
    
    init(post: [String: Any]){
        //Create a user object
        self.user = User( user: post["user"] as! [String : Any] )
        
        //Set the post text
        self.text = post["text"] as! String
        if ( self.text.containsEmoji() ){
            self.text = self.text.decoded()
        }
        self.postKey = post["post_key"] as! String
        self.likeCount = post["like_count"] as! Int
        self.commentCount = post["comment_count"] as! Int
        self.createdAt = post["created_at"] as! String
        self.timeStamp = post["time_stamp"] as! String
        if ( post["user_liked"] as! Bool == true ){
            self.isLiked = true
        }
        var comments = post["comments"] as! [[String:Any]]
        for comment in comments{
            self.comments.addComment( comment: Comment( comment: comment) )
        }
        
        //Create a trip object
        let trip = post["trip"] as! [String : AnyObject]
        let tripObj = Trip(trip: trip)
        self.trip = tripObj
    }
    
    func unlike(){
        self.isLiked = false
        likeCount-=1
    }
    
    func like(){
        self.isLiked = true
        likeCount+=1
    }
    
    func getEstimatedTextViewSize(width: CGFloat) -> CGFloat{
        let size = CGSize(width: width, height: 1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: self.fontSize)]
        let estimatedFrame = NSString(string: self.text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return estimatedFrame.height
    }
    
}

extension Post: Equatable{
    
    static public func ==(rhs: Post, lhs: Post) -> Bool{
        return rhs.postKey == lhs.postKey
    }
}

extension Post : ListDiffable{
    public func diffIdentifier() -> NSObjectProtocol {
        return postKey as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Post else{
            return false
        }
        
        return ( self.postKey == object.postKey && self.likeCount == object.likeCount && self.commentCount == object.commentCount && self.text == object.text && self.trip?.seatsAvailable == object.trip?.seatsAvailable && self.createdAt == object.createdAt)
    }
}

/*
 
 {
 "text": "Hello everyone my name is Jackie and I would like a ride to SF",
 "created_at": "2017-10-29T01:27:06.103295",
 "comments": [],
 "post_key": "ag1kZXZ-Z29hbC1yaXNlchELEgRQb3N0GICAgICAgMAJDA",
 "user": {
 "created_at": "2017-10-29T01:26:16.203784",
 "last_name": "Johnson",
 "profile_pic_url": null,
 "planned_trip_ids": [],
 "completed_trip_ids": [],
 "status": null,
 "location": null,
 "school": null,
 "car": null,
 "rating": 5,
 "current_trip_id": null,
 "first_name": "Jackie",
 "user_key": "ag1kZXZ-Z29hbC1yaXNlchELEgRVc2VyGICAgICAgMAKDA"
 },
 "comment_count": 0,
 "like_count": 5
 }
 
 */
