//
//  SharedPosts.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/21/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation

class Posts {
    
    static let shared = Posts()
    
    var feedPosts : [Post] = []
    
    init(){
        
    }
}
