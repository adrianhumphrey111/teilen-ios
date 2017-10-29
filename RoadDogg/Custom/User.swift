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
    var profileUrl : String = ""
    var key : String = ""
    
    init(user: [String : Any] ) {
        self.firstName = user["first_name"] as! String
        self.lastName = user["last_name"] as! String
        //self.profileUrl = user["profile_pic_url"] as! String
        self.key = user["user_key"] as! String
    }
}

/*

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
 
 */
