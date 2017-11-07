//
//  Trip.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/6/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation

struct Trip {
    
    var startLocation: Address!
    var endLocation: Address!
    var role: String! //Driving or Looking for Ride
    var eta: String! //Departure or Arrival
    var time: Date! //Date Object
    var postText: String!
    var postedBy : String! //User key
    
    init() {
        //Do Nothing
    }
    
    func to_dict() -> [String: Any]{
        var dict : [String: Any] = [:]
        dict["startAddress"] = self.startLocation.to_dict()
        dict["endAddress"] = self.endLocation.to_dict()
        dict["role"] = self.role != nil ? self.role : ""
        dict["eta"] = self.eta != nil ? self.eta : ""
        dict["time"] = self.time != nil ? self.time.to_string() : ""
        dict["post_text"] = self.postText != nil ? self.postText : ""
        dict["posted_by"] = self.postedBy != nil ? self.postedBy : ""
        return dict
    }
}

extension Date {
    func to_string() -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
