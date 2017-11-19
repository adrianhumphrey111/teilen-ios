//
//  Realm.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/13/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import RealmSwift
import FBSDKCoreKit

//SinlgeTon Realm to handle all data persistence
class RealmManager {
    
    // Get the default Realm
    private let realm : Realm!
    
    //Keep status of login
    private var loggedIn : Bool = false
    
    static let shared = RealmManager()
    
    //The logged in user
    public var selfUser : loggedInUser?
    
    private let tokenNotification : NotificationToken!
    
    
    init() {
        self.realm = try! Realm()
        
        self.tokenNotification = self.selfUser?.addNotificationBlock({ (change) in
            switch change {
            case .change(let properties):
                print("The selfuser has been changed, now you can send the notification key off")
                Network.shared.updateNotificationToken(token: (self.realm?.objects(token.self).first?.id)!)
            case .deleted:
                print("The user object was deleted")
            case .error( let error ):
                print("There was an error on the realm logged in user")
            default:
                print("Realm selfUser object notification ")
            }
        })
        
        //Check if there is loggedin user for the app
        getLoggedInUser()
        
        //If there is, set logged in
        if  ( selfUser != nil ) {
            self.loggedIn = true
        }

    }
    
    @objc func isLoggedin() -> Bool{
        return ( self.loggedIn || ( FBSDKAccessToken.current() != nil ) )
    }
    
    @objc func getLoggedInUser() {
        if( self.realm.objects(loggedInUser.self).count > 0 ) {
            print("There is a logged in user saved to databases")
           self.selfUser = self.realm.objects( loggedInUser.self )[0]  //There should only be one
        }else{
            print("There is no user saved in databses")
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
                Network.shared.updateNotificationToken(token: user.notificationToken)
            }
        }
        getLoggedInUser()
        
    }
    
    @objc func updateLoggedInUser(user: loggedInUser) {
        try! realm.write {
            if ( self.selfUser != nil ){
                //We are updating the logged in User in the database.
                realm.add(user)
            }
        }
        getLoggedInUser()
    }
    
    @objc func getSavedNotificationToken() -> String {
        
        if let token = realm.objects(token.self).first?.id {
            return token
        }
        else{
            //There is no token saved yet
            return ""
        }
    }
    
    @objc func saveNotificationToken(tokenstring: String){
        
        let newToken = token(token: tokenstring)
        let tokenList = realm.objects(token.self)
        if ( tokenList.count > 0){
            //There is already a token here, delete it and save the new one
            try! realm.write {
                realm.delete( tokenList.first! )
                realm.add( newToken )
            }
        }
        else{
            //There is no token in the database, save one
            try! realm.write {
                realm.add( newToken )
            }
        }
        
        //If there is a user saved to the database already, save token on server as well
        if let user = self.selfUser {
            Network.shared.updateNotificationToken(token: tokenstring)
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

