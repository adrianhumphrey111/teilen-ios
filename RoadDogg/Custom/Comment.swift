//
//  Comment.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/29/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import UIKit

struct Comment{
    
    var userKey: String?
    var text = ""
    //var commentKey = ""
    var createdAt = ""
    var fontSize : CGFloat = 12
    var postKey: String?

    
    init(comment: [String : Any] ){
        self.userKey = comment["user_key"] as! String
        self.text = comment["text"] as! String
        self.text = self.text.decoded()
        self.createdAt = comment["created_at"] as! String
        self.postKey = comment["post_key"] as! String
        //self.commentKey = comment["comment_key"] as! String
    }
    
    init(comment: String) {
        self.text = comment
        //self.user_key = self user key
    }
    
    func getEstimatedTextViewSize(width: CGFloat) -> CGFloat{
        let size = CGSize(width: width, height: 1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: self.fontSize)]
        let estimatedFrame = NSString(string: self.text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return estimatedFrame.height
    }
}
