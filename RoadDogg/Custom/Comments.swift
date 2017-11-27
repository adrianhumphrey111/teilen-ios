//
//  Comments.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/26/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import IGListKit

/*
 Class that is diffable for IGListKit
 */

final class Comments {
    
    var comments : [AnyObject] = []
    var count : Int = 0
    var key : String = NSUUID().uuidString
    
    init() {
    }
    
    public func addComment(comment: Comment){
        self.comments.append( comment )
        count+=1
    }
    
}

extension Comments : ListDiffable{
    public func diffIdentifier() -> NSObjectProtocol {
        return key as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Comments else{
            return false
        }
        
        for (ndx, comment) in object.comments.enumerated(){
            if ( self.comments[ndx] !== comment){
                return false
            }
        }
        
        return ( self.count == object.count )
    }
}
