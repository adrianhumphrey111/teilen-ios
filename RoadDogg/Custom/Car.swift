//
//  Car.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/9/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation

struct Car {
    var make: String!
    var model: String!
    var year: String!
    var milesPerGallon: Float!
    var mpgString: String{
        get{
            return "\(milesPerGallon) MPG"
        }
    }
    
    init(car: [String: AnyObject]){
        
    }
    
    init(make: String, model: String, year: String, mpg: Float){
        self.make = make
        self.model = model
        self.year = year
        self.milesPerGallon = mpg
    }
}
