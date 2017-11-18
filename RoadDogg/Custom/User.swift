//
//  User.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/29/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation


struct User{
    var firstName : String = ""
    var lastName : String = ""
    var email : String = ""
    var facebookId : String = ""
    var profileUrl : String = ""
    var password : String = ""
    var key : String = ""
    var notification_token : String = ""
    var posts : [Post]?
    var car : Car?
    var rating: Float!
    var numberOfTrips: Int!
    
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
            return "\(numberOfTrips!)"
        }
    }
    
    init(user: [String : Any] ) {
        self.firstName = user["first_name"] as! String
        self.lastName = user["last_name"] as! String
        self.rating = user["rating"] as! Float
        self.numberOfTrips = user["numberOfCompletedTrips"] != nil ? 0 : user["numberOfCompletedTrips"] as! Int
        //self.profileUrl = user["profile_pic_url"] as! String
        self.key = user["user_key"] as! String
        if let car = user["car"] as? [String: AnyObject]{
            self.car = Car( car: car)
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
        print(dict)
        return dict
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
