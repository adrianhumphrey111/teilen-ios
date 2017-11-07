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
    var zipCode : String!
    var terms : [[String: AnyObject]]
    
    init(prediction: [String: AnyObject]){
        //Nothing right now
        self.address1 = prediction["structured_formatting"]!["main_text"] as! String
        self.terms = prediction["terms"]! as! [[String: AnyObject]]
        if 0...self.terms.count ~= self.terms.count - 3 {
          self.city = self.terms[self.terms.count - 3]["value"] as! String
        }
        if 0...self.terms.count ~= self.terms.count - 2 {
            self.state = self.terms[self.terms.count - 2]["value"] as! String
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
        return self.address1 + " " + self.city + " " + self.state
    }
}
