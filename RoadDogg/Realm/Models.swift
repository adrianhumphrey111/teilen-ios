//
//  Models.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/10/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import RealmSwift

class user: Object {
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var profileUrl = ""
    @objc dynamic var key = ""
    @objc dynamic var email = ""
    @objc dynamic var facebookId = ""
    @objc dynamic var numberOfTrips = 0
    @objc dynamic var profilePicture: Data? = nil
    @objc dynamic var car: car?
   // let posts = List<Task>()
    
    override static func primaryKey() -> String? {
        return "key"
    }
}

final class loggedInUser: user{
    @objc dynamic var stripeAccountId = ""
    
    let posts = List<post>()
    
}

final class car: Object {
    @objc dynamic var make = ""
    @objc dynamic var model = ""
    @objc dynamic var year = ""
    @objc dynamic var mpg: Float = 0.0
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
}

final class trip: Object {
    @objc dynamic var startAddress: address? = nil
    @objc dynamic var endAddress: address? = nil
    @objc dynamic var driver: user? = nil
    @objc dynamic var postText = ""
    @objc dynamic var postedBy : user? = nil
    let riders = List<user>()
    
}

