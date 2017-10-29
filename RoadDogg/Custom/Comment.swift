//
//  Comment.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/29/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation

struct Comment{
    
    var user_key: String?
    var text = ""
    var commentKey = ""
    //var createdAt
    
    init(comment: [String : Any] ){
        self.user_key = comment["user_key"] as! String
        self.text = comment["text"] as! String
        self.commentKey = comment["comment_key"] as! String
    }
}
