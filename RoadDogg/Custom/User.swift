//
//  User.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/29/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import IGListKit


final class User{
    var firstName : String = ""
    var lastName : String = ""
    var email : String = ""
    var facebookId : String = ""
    var profileUrl : String = ""
    var password : String = ""
    var key : String = ""
    var notification_token : String = ""
    var posts : [AnyObject] = []
    var car : Car?
    var currentTrip : Trip?
    var rating: Float!
    var numberOfTrips: Int = 0
    var numberOfFriends : Int = 0
    var numberOfPosts : Int = 0
    var isFriend : String!
    
    var fullName : String {
        get{
            return "\(firstName) \(lastName)"
        }
    }
    
    var ratingString : String {
        get{
            return "\(rating!) Stars"
        }
    }
    
    var numberOfTripsString : String {
        get{
            return "\(numberOfTrips)"
        }
    }
    
    init(user: [String : Any] ) {
        self.firstName = user["first_name"] as! String
        self.lastName = user["last_name"] as! String
        self.rating = user["rating"] as! Float
        self.numberOfTrips = user["numberOfCompletedTrips"] != nil ? 0 : user["numberOfCompletedTrips"] as! Int
        self.numberOfPosts = user["numberOfPost"] as! Int
        self.numberOfFriends = user["numberOfFriends"] as! Int
        self.profileUrl = user["profile_pic_url"] as! String
        if let is_friend = user["is_friend"] as? String {
            self.isFriend = is_friend
        }
        if let key = user["user_key"] as? String{
            self.key = key
        }
        if let car = user["car"] as? [String: AnyObject]{
            self.car = Car( car: car)
        }
        
        if let trip = user["current_trip"] as? [String: AnyObject]{
            self.currentTrip = Trip(trip: trip)
        }
    }
    
    init(){
        
    }
    
    func to_dict() -> [String: Any]{
        var dict : [String: Any] = [:]
        dict["first_name"] = self.firstName != "" ? self.firstName : ""
        dict["last_name"] = self.lastName != "" ? self.lastName : ""
        dict["email"] = self.email != "" ? self.email : ""
        dict["profile_pic_url"] = self.profileUrl != "" ? self.profileUrl : ""
        dict["facebook_id"] = self.facebookId != "" ? self.facebookId : ""
        dict["password"] = self.password != "" ? self.password : ""
        dict["notification_token"] = self.notification_token != "" ? self.notification_token : ""
        return dict
    }
}

extension User: Equatable{
    
    static public func ==(rhs: User, lhs: User) -> Bool{
        return rhs.key == lhs.key
    }
}

extension User : ListDiffable{
    public func diffIdentifier() -> NSObjectProtocol {
        return key as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? User else{
            return false
        }
        
        return ( self.key == object.key && self.posts.count == object.posts.count && self.isFriend == object.isFriend && self.numberOfPosts == object.numberOfPosts && self.numberOfFriends == self.numberOfFriends && self.numberOfTrips == object.numberOfTrips)
    }
}


/*

 "user":
 {
 "last_name": "Johnson",
 "current_trip_id": null,
 "planned_trip_ids": [],
 "numberOfCompletedTrips": null,
 "school": null,
 "location": null,
 "car": null,
 "first_name": "Adrian",
 "user_key": "ag1kZXZ-Z29hbC1yaXNlchELEgRVc2VyGICAgICAgIAKDA",
 "rating": 5,
 "profile_pic_url": null,
 "completed_trip_ids": [],
 "status": null,
 "created_at": "2017-11-08T08:35:47.839990"
 }
 
 */
