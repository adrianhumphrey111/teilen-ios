//
//  Models.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/10/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import RealmSwift
import Stripe
import IGListKit

class user: Object {
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var imageFileName = ""
    @objc dynamic var profileUrl = ""
    @objc dynamic var key = ""
    @objc dynamic var email = ""
    @objc dynamic var facebookId = ""
    @objc dynamic var numberOfFriends = 0
    @objc dynamic var numberOfPosts = 0
    @objc dynamic var notificationToken = ""
    @objc dynamic var numberOfTrips = 0
    @objc dynamic var userName = ""
    @objc dynamic var profilePicture: Data? = nil
    @objc dynamic var car: car? = nil
   // let posts = List<Task>()
    
    override static func primaryKey() -> String {
        return "key"
    }
}

final class loggedInUser: user{
    @objc dynamic var stripeAccountId : String? = nil
    @objc dynamic var customerId : String? = nil
    @objc dynamic var currentTripKey : String? = nil
    @objc dynamic var currentTripDestinationCity : String? = nil
    @objc dynamic var currentTripDate : String? = nil
    @objc dynamic var isOnCurrentTrip = false
    @objc dynamic var lastFour : String? = nil
    @objc dynamic var studentEmail : String? = nil
    @objc dynamic var dateOfBirth : String? = nil
    @objc dynamic var billingAddress : address? = nil
    @objc dynamic var paymentVerified = false
    @objc dynamic var cardId : String? = nil
    @objc dynamic var currentCard : card? = nil
    let posts = List<post>()
    
    func fullName() -> String{
        return "\(self.firstName) \(self.lastName)"
    }
    
}


extension loggedInUser : ListDiffable{
    public func diffIdentifier() -> NSObjectProtocol {
        return key as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? loggedInUser else{
            return false
        }
        
        return ( self.firstName == object.firstName && self.userName == object.userName && self.currentTripDestinationCity == object.currentTripDestinationCity && self.numberOfPosts == object.numberOfPosts
        && self.numberOfFriends == object.numberOfFriends && self.numberOfTrips == object.numberOfTrips)
    }
    
}

final class token: Object{
    @objc dynamic var id :  String = ""
    
    convenience init(token: String){
        self.init()
        self.id = token
    }
}

final class realmNotification: Object {
    @objc dynamic var key :  String = NSUUID().uuidString
    @objc dynamic var message : String = ""
    @objc dynamic var type : String = ""
    @objc dynamic var createdAt : String = ""
    @objc dynamic var fromUserKey : String = ""
    @objc dynamic var tripKey : String = ""
    @objc dynamic var userProlfileUrl : String = ""
    @objc dynamic var accepted : String = ""
    @objc dynamic var timeStamp : String = ""
    
    convenience init(notification: [String: AnyObject]) {
        self.init()
        self.message = notification["message"] as! String
        self.type = notification["type"] as! String
        self.createdAt = notification["created_at"] as! String
        if let timeStamp = notification["time_stamp"] as? String{
            self.timeStamp = timeStamp
        }
        self.fromUserKey = notification["from_user_key"] as! String
        if let key = notification["trip_key"] as? String{
            self.tripKey = key
        }
        
        if let user = notification["user"] as? [String : AnyObject]{
            self.userProlfileUrl = user["profile_pic_url"] as! String
        }
    }
    
    override static func primaryKey() -> String {
        return "createdAt"
    }
}

extension realmNotification{
    static public func ==(rhs: realmNotification, lhs: realmNotification) -> Bool{
        return ( rhs.message == lhs.message && rhs.createdAt == lhs.createdAt && rhs.type == lhs.type && rhs.tripKey == lhs.tripKey )
    }
}

extension realmNotification : ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return createdAt as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? realmNotification else {
            return false
        }
        
        return ( self.message == object.message && self.tripKey == object.tripKey )
    }
}

final class car: Object {
    @objc dynamic var make = ""
    @objc dynamic var model = ""
    @objc dynamic var year = ""
    @objc dynamic var mpg: Float = 0.0
}

final class card: Object {
    @objc dynamic var number = ""
    @objc dynamic var cvv = ""
    @objc dynamic var exp = ""
}

final class post: Object {
    @objc dynamic var text = ""
    @objc dynamic var user : user? = nil
    @objc dynamic var numberOfLikes : Int = 0
    @objc dynamic var numberOfComments : Int = 0
}

final class address: Object {
    @objc dynamic var address1 = ""
    @objc dynamic var address2 = ""
    @objc dynamic var city = ""
    @objc dynamic var state = ""
    @objc dynamic var postalCode = ""
}

final class trip: Object {
    @objc dynamic var startAddress: address? = nil
    @objc dynamic var endAddress: address? = nil
    @objc dynamic var driver: user? = nil
    @objc dynamic var postText = ""
    @objc dynamic var postedBy : user? = nil
    let riders = List<user>()
    
}

