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
    var postedBy : String! //"driver" or "rider"
    var postedByKey : String! //Key of the person that submited the post, could be a driver or rider
    var tripType : String! //Driving look for Riders, or Riders looking for drivers
    var driverKey : String! //User that is currently looking for riders
    var passengerKeys : [String]!
    var ratePerSeat : Int!
    var seatsAvailable : Int!
    var radius: Int = 5     //Set this as a default value
    
    init() {
        //Do Nothing
    }
    
    init(trip: [String: AnyObject]){
        if let driverKey = trip["driver_key"] as? String{
            self.driverKey = driverKey
        }
        
        if let rate = trip["rate_per_seat"] as? Int{
            self.ratePerSeat = rate
        }
        
        if let passKeys = trip["passenger_keys"] as? [String]{
            self.passengerKeys = passKeys
        }

        if let seats = trip["seats_available"] as? Int {
            self.seatsAvailable = seats
        }
        
        if let postedBy = trip["posted_by"] as? String{
            self.postedBy = postedBy
        }
        
        if let key = trip["posted_by_key"] as? String{
            self.postedByKey = key
        }
        
        if let radius = trip["radius"] as? Int{
            self.radius = radius
        }
        
        if let seats = trip["seats_available"] as? Int{
            self.seatsAvailable = seats
        }
        
        //Start Address
        self.startLocation = Address(address: trip["start_location"] as! [String : AnyObject])
        
        //End location
        self.endLocation = Address(address: trip["end_location"] as! [String : AnyObject])
    }
    
    func to_dict() -> [String: Any]{
        var dict : [String: Any] = [:]
        dict["startAddress"] = self.startLocation != nil ? self.startLocation.to_dict() : ""
        dict["endAddress"] = self.endLocation != nil ? self.endLocation.to_dict() : ""
        dict["role"] = self.role != nil ? self.role : ""
        dict["eta"] = self.eta != nil ? self.eta : ""
        dict["time"] = self.time != nil ? self.time.to_string() : ""
        dict["post_text"] = self.postText != nil ? self.postText : ""
        dict["posted_by"] = self.postedBy != nil ? self.postedBy : ""
        dict["posted_by_key"] = RealmManager.shared.userKey()
        dict["radius"] = self.radius != nil ? self.radius : ""
        dict["seats_available"] = self.seatsAvailable != nil ? self.seatsAvailable : ""
        dict["rate_per_seat"] = self.ratePerSeat != nil ? self.ratePerSeat * 100 : ""
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
