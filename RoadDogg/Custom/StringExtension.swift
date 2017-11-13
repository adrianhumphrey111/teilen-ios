//
//  StringExtension.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/6/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation

extension String {
    
    func encoded() ->  String{
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    func decoded() -> String{
        let data = self.data(using: .utf8)
        if data == nil{
            print("data is nil")
        }
        
        return ( String(data: data!, encoding: .nonLossyASCII) == nil ) ? self : ""
    }
}

