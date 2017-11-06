//
//  Trip.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/6/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation

struct Trip {
    
    var startLocation: String?
    var endLocation: String?
    var role: String? //Driving or Looking for Ride
    var eta: String? //Departure or Arrival
    var time: Date? //Date Object
    var postText: String?
    
    init() {
        //Do Nothing
    }
    
}
