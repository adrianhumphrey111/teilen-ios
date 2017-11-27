//
//  Comment.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/29/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

final class Comment{
    
    var userKey: String?
    var userProfileUrl: String?
    var text = ""
    //var commentKey = ""
    var createdAt = ""
    var fontSize : CGFloat = 12
    var postKey: String?
    var key : String = NSUUID().uuidString
    var user : User?

    
    init(comment: [String : Any] ){
        self.userKey = comment["user_key"] as? String
        self.createdAt = comment["created_at"] as! String
        self.postKey = comment["post_key"] as? String
        self.userProfileUrl = comment["user_url"] as? String
        self.text = comment["text"] as! String
        if ( self.text.containsEmoji() ){
            self.text = self.text.decoded()
        }
        if let user = comment["user"] as? [String: Any] {
            self.user = User(user: user)
        }

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

extension Comment: Equatable{
    
    static public func ==(rhs: Comment, lhs: Comment) -> Bool{
        return rhs.text == lhs.text && rhs.userKey == lhs.userKey
    }
}

extension Comment : ListDiffable{
    public func diffIdentifier() -> NSObjectProtocol {
        return key as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Comment else{
            return false
        }
        
        return ( self.createdAt == object.createdAt && self.text == object.text && self.userKey == object.userKey && self.postKey == object.postKey)
    }
    
}
