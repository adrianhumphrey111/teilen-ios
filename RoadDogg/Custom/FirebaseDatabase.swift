//
//  FirebaseDatabase.swift
//  Teilen
//
//  Created by Adrian Humphrey on 1/6/18.
//  Copyright © 2018 Adrian Humphrey. All rights reserved.
//

import Foundation
import Firebase


struct FirebaseDB{
    
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("messages")
    }
    
}

