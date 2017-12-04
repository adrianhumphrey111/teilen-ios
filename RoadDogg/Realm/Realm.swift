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
    
    //Docuemnts path
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    init() {
        self.realm = try! Realm()
        
        //Check if there is loggedin user for the app
        getLoggedInUser()
        
        //If there is, set logged in
        if  ( selfUser != nil ) {
            self.loggedIn = true
        }
        else{
            self.selfUser = loggedInUser()
        }

    }
    
    //Save profile image
    func saveImage(image: UIImage, fileName: String) -> String? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
            return fileName // ----> Save fileName
        }
        print("Error saving image")
        return nil
    }
    
    func loadImage(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    
    @objc func isLoggedin() -> Bool{
        return ( self.loggedIn || ( FBSDKAccessToken.current() != nil ) )
    }
    
    @objc func getLoggedInUser() {
        if( self.realm.objects(loggedInUser.self).count > 0 ) {
           self.selfUser = self.realm.objects( loggedInUser.self )[0]  //There should only be one
        }else{
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
                //Network.shared.updateNotificationToken(token: user.notificationToken)
            }
        }
        getLoggedInUser()
        
    }
    
     func updateLoggedInUser(loggedInUser: loggedInUser, user: User) {
        
        try! realm.write {
            if ( self.selfUser != nil ){
                //We are updating the logged in User in the database.
                if ( user != nil ){
                    loggedInUser.numberOfPosts = user.numberOfPosts
                    loggedInUser.numberOfFriends = user.numberOfFriends
                    loggedInUser.numberOfTrips = user.numberOfTrips
                }
                realm.add(loggedInUser)
            }
        }
        getLoggedInUser()
    }
    
    @objc func paymentVerified(){
        try! realm.write {
            if ( self.selfUser != nil ){
                //We are updating the logged in User in the database.
                self.selfUser?.paymentVerified = true
                realm.add( self.selfUser! )
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
    
    func userKey() -> String{
        return self.selfUser != nil ? (self.selfUser?.key)! : ""
    }
    
    func getNotifications() ->[realmNotification] {
        return Array( realm.objects(realmNotification.self) )
    }
    
    func updateNotification(notification: realmNotification, accepted: String){
        try! realm.write {
            notification.accepted = accepted
            realm.add( notification )
        }
    }
    
    func saveNotifications(notifications: [realmNotification]){
        try! realm.write {
            for not in notifications{
                if let existingCategory = realm.object(ofType: realmNotification.self, forPrimaryKey: not.createdAt) {
                    //Notification already exist
                }else{
                    realm.add( not )
                }
            }
        }
    }
    
    func saveSettings(first: String, last: String, email: String){
        try! realm.write {
            self.selfUser?.firstName = first
            self.selfUser?.lastName = last
            self.selfUser?.email = email
            realm.add( self.selfUser! )
        }
    }
    
    func logout(){
        try! realm.write {
            realm.deleteAll()
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

