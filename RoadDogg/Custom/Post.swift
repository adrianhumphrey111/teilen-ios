//
//  Post.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/29/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation

struct Post{
    
    var user : User!
    var text = ""
    var postKey = ""
    var likeCount : Int = 0
    var commentCount : Int = 0
    var likeCountString : String {
        get{
            return "\(likeCount) Likes"
        }
    }
    var commentCountString : String {
        get{
            return "\(commentCount) Comments"
        }
    }
    var isLiked : Bool = false
    var comments = [Comment]()
    var liked = false
    
    init(post: [String: Any]){
        self.user = User( user: post["user"] as! [String : Any] )
        self.text = post["text"] as! String
        self.postKey = post["post_key"] as! String
        self.likeCount = post["like_count"] as! Int
        self.commentCount = post["comment_count"] as! Int
        if ( post["user_liked"] as! Bool == true ){
            self.isLiked = true
        }
        for comment in comments{
            self.comments.append( Comment( comment: comment as! [String : Any]) )
        }
    }
    
    mutating func unlike(){
        isLiked = false
        likeCount-=1
    }
    
    mutating func like(){
        isLiked = true
        likeCount+=1
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
