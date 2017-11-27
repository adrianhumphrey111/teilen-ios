//
//  File.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/23/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import IGListKit

class TNotification {
    
    var key : String!
    var message : String!
    var type : String!
    var createdAt : String!
    var user: User!
    var fromUserKey : String!
    var tripKey : String!
    
    init(notification: [String : AnyObject]){
        self.key = notification["key"] as! String
        self.message = notification["message"] as! String
        self.type = notification["type"] as! String
        self.createdAt = notification["created_at"] as! String
        self.fromUserKey = notification["from_user_key"] as! String
        self.user = User(user: notification["user"] as! [String: Any])
        self.tripKey = notification["trip_key"] as! String
    }
}

extension TNotification: Equatable{
    static public func ==(rhs: TNotification, lhs: TNotification) -> Bool{
        return rhs.key == lhs.key
    }
}

extension TNotification : ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return key as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? TNotification else {
            return false
        }
        
        return ( self.key == object.key && self.message == object.message )
    }
}
