//
//  Address.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/6/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation

public struct Address {
    
    var address1 : String!
    var address2 : String?
    var city : String!
    var state : String!
    var zipCode : String?
    var terms : [[String: AnyObject]]?
    var latitude : Float?
    var longitude : Float?
    
    
    init(prediction: [String: AnyObject]){
        //Nothing right now
        self.address1 = prediction["structured_formatting"]!["main_text"] as! String
        self.terms = prediction["terms"]! as! [[String: AnyObject]]
        if 0...(self.terms?.count)! ~= (self.terms?.count)! - 3 {
            self.city = self.terms![(self.terms?.count)! - 3]["value"] as! String
        }
        if 0...(self.terms?.count)! ~= (self.terms?.count)! - 2 {
            self.state = self.terms![(self.terms?.count)! - 2]["value"] as! String
        }
    }
    
    init(address: [String: AnyObject]){
        if let one = address["address1"] as? String{
            self.address1 = one
        }
        if let two = address["address2"] as? String{
            self.address2 = two
        }
        
        if let city = address["city"] as? String{
            self.city = city
        }
        if let state = address["state"] as? String{
            self.state = state
        }
        if let lat = address["latitude"] as? Float {
            self.latitude = lat
        }
        if let lon = address["longitude"] as? Float {
            self.longitude = lon
        }
    }
    
    func to_dict() -> [String : Any] {
        var dict : [String : Any] = [:]
        dict["address1"] = self.address1 != nil ? self.address1 : ""
        dict["address2"] = self.address2 != nil ? self.address2 : ""
        dict["city"] = self.city != nil ? self.city : ""
        dict["state"] = self.state != nil ? self.state : ""
        dict["zipCode"] = self.zipCode != nil ? self.zipCode : ""
        return dict
    }
    
    func to_string() -> String{
        var _return = true
        if (self.address1 == nil){
            print("self.address is nil")
            _return = false
        }
        if (self.city == nil){
            print("city is nil")
            _return = false
        }
        
        if (self.state == nil){
            print("state is nil")
            _return = false
        }
        
        return _return ? self.address1 + " " + self.city + " " + self.state : ""
    }
}
