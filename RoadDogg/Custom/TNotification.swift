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
    
    init(not: [String : AnyObject]){
        self.key = not["key"] as! String
        self.message = not["message"] as! String
        self.type = not["type"] as! String
        self.createdAt = not["created_at"] as! String
    }
}

extension TNotification: Equatable{
    static public func ==(rhs: TNotification, lhs: TNotification) -> Bool{
        return rhs.key = lhs.key
    }
}

extension TNotification : ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return key as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Notif else {
            return false
        }
        
        return self.key == object.key
    }
}
