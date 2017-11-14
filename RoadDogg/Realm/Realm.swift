//
//  Realm.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/13/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import RealmSwift

//SinlgeTon Realm to handle all data persistence
class RealmManager {
    
    // Get the default Realm
    private let realm = try! Realm()
    
    //Keep status of login
    private var loggedIn : Bool = false
    
    static let shared = RealmManager()
    
    //The logged in user
    public var selfUser : loggedInUser?
    
    init() {
        //Check if there is loggedin user for the app
        getLoggedInUser()
        
        //If there is, set logged in
        if  ( selfUser != nil ) {
            self.loggedIn = true
        }
    }
    
    @objc func isLoggedin() -> Bool{
        return self.loggedIn
    }
    
    @objc func getLoggedInUser() {
        if( self.realm.objects(loggedInUser.self).count > 0 ) {
           self.selfUser = self.realm.objects( loggedInUser.self )[0]  //There should only be one
        }
    }
    
    @objc func userLoggedIn() -> loggedInUser?{
        return self.selfUser
    }
    
    @objc func saveLoggedInUser(user: loggedInUser){
        try! realm.write {
            self.loggedIn = true
            if ( self.selfUser == nil ){
                //If there is already a logged in user, no need to save a new one. For right now
                realm.add(user)
            }
        }
    }
    
    @objc func updatedLoggedinUser() {
        if self.loggedIn{
            //Query, the user, update it, save it
        }
    }
    
}

//    // Query and update from any thread
//    DispatchQueue(label: "background").async {
//    autoreleasepool {
//    let realm = try! Realm()
//    let theDog = realm.objects(Dog.self).filter("age == 1").first
//    try! realm.write {
//    theDog!.age = 3
//    }
//    }
//    }

