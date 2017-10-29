//
//  Feed.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/29/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation


struct Feed{
    var posts = [Post]()
    
    init(feed: [[String:Any]]){
        for post in feed{
            self.posts.append( Post(post: post) )
        }
    }
    
}
