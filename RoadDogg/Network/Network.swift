//
//  Constants.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/25/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import FBSDKCoreKit
import RealmSwift

class Network {
    
    var GooglePlacesApiWebServiceKey = "AIzaSyCL418H5jo-xpF2t3-1YmWsJktr48dU1Ho"
    
    var baseurl = ""
    var basedev = "http://localhost:8080/api"
    var baseProd = "https:teilen-ride.com/api"
    
    private var user_key = ""
    var prodKey = "agtzfmdvYWwtcmlzZXIRCxIEVXNlchiAgICAhLSKCgw"  //Production Adrian key
    var devKey = "ag1kZXZ-Z29hbC1yaXNlchELEgRVc2VyGICAgICAgPAKDA" //Development Key Adrian
    
    static let shared = Network(baseURL: "http://localhost:8080", dev: false) //https://goal-rise.appspot.com
    
    init(baseURL: String, dev: Bool) {
        
        if ( dev ){
           self.baseurl = basedev
            self.user_key = devKey
        }
        else{
            self.baseurl = baseProd
        }
        
        if let user = RealmManager.shared.selfUser{
            self.user_key = user.key
        }
        else{
            print("No calls will work, because there is no logged in user")
            //Handle this situation
        }
    }
    
    public func setUserKey()
    {
        self.user_key = RealmManager.shared.userKey()
    }
    
    func grabProfileImage(urlString: String) -> Promise<UIImage>{
        return Promise{ fulfill, reject in
            let url = URL(string: urlString)
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                if let image = UIImage(data: imageData){
                    fulfill( image )
                }
            }
            else{
                reject ( "Error" as! Error )
            }
        }
    }
    
    func getFeed() -> Promise<Feed> {
        let url = "\(self.baseurl)/fetchFeed?user_key=\(self.user_key)"
        return Promise { fulfill, reject in
            //Make call to the API
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                print(response.request)
                print(response.request?.httpBody)
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let posts = result as! [[String:Any]]
                        let feed = Feed(feed: posts)
                        Posts.shared.updatesPost(posts: feed.posts as! [Post])
                        fulfill(feed)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func getUserFeed(user_key: String) -> Promise<Feed> {
        let url = "\(self.baseurl)/fetchUserFeed?user_key=\(user_key)"
        return Promise { fulfill, reject in
            //Make call to the API
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let posts = result as! [[String:Any]]
                        let feed = Feed(feed: posts)
                        fulfill(feed)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func likePost(postKey: String){
        let url = "\(self.baseurl)/likePost?post_key=\(postKey)&user_key=\(self.user_key)"
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { response in
            print("Success: \(response.result.isSuccess)")
            print("Response String: \(response.result.value!)")
        }
    }
    
    func unLikePost(postKey: String){
        let url = "\(self.baseurl)/unlikePost?post_key=\(postKey)&user_key=\(self.user_key)"
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { response in
            print("Success: \(response.result.isSuccess)")
            print("Response String: \(response.result.value!)")
        }
    }
    
    func commentPost(postKey: String, comment: String) -> Promise<Comment> {
        let escapedCommentString = comment.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = "\(self.baseurl)/commentPost?post_key=\(postKey)&user_key=\(self.user_key)&comment=\(escapedCommentString!)"
        return Promise { fulfill, reject in
            Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let json = result as! [String:Any]
                        let jsonComment = json["comment"] as! [String: Any]
                        let comment = Comment(comment: jsonComment)
                        fulfill(comment)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func createPost(trip: Trip) -> Promise<[String]> {
        let timeZone : String = String( describing: TimeZone.current )
        let tz = timeZone.components(separatedBy: " ")[0]
        print("TZ = > " , tz)
        let url = "\(self.baseurl)/createPost"
        let params : [String : Any] = ["user_key": self.user_key,
                      "post_text": trip.postText!.encoded(),
                      "trip": trip.to_dict(),
                      "time_zone" : tz
                    ]
        var keys : [String] = []
        return Promise { fulfill, reject in
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let json = result as! [String:Any]
                        let post_key = json["post_key"] as! String
                        let trip_key = json["trip_key"] as! String
                        let eta = json["eta"] as! String
                        keys.append(post_key)
                        keys.append(trip_key)
                        keys.append(eta)
                        fulfill(keys)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func GooglePlacesFetch(address: String) -> Promise<[Address]> {
        var addresses : [Address] = []
        let escapedTextString = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = "https://maps.googleapis.com/maps/api/place/queryautocomplete/json?key=\(self.GooglePlacesApiWebServiceKey)&input=\(escapedTextString!)"
        return Promise { fulfill, reject in
            Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let json = result as! [String:Any]
                        let predictions = json["predictions"] as! [[String : AnyObject]]
                        for prediction in predictions{
                            addresses.append( Address(prediction: prediction ) )
                        }
                        fulfill( addresses )
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func retriveUserFromFacebook() -> Promise<User> {
        
        //Final once we have a app icon "first_name,age,last_name,email,education"
        return Promise { fulfill, reject in
            let request = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields" : "id,first_name,last_name,email,picture"], httpMethod: "GET")
            request?.start(completionHandler: { (connection, result, error) in
                if (error == nil){
                    let data:[String:AnyObject] = result as! [String : AnyObject]
                    let firstName = data["first_name"]!
                    let lastName = data["last_name"]!
                    let facebook_id = data["id"]!
                    let email = data["email"]!
                    var picUrl = ""
                    if let picData = data["picture"]!["data"] as? [String: AnyObject]{
                        picUrl = picData["url"] as! String
                    }
                    var user = User()
                    user.firstName = firstName as! String
                    user.lastName = lastName as! String
                    user.email = email as! String
                    user.profileUrl = picUrl
                    user.facebookId = facebook_id as! String
                    fulfill( user )
                }
                else{
                    print(error as Any)
                    reject(error!)
                }
            })
        }
    }
    
    /*
     Create user sends a user object to the teilen-ride api to create a user in the data base
     For every user created, there is also a customer account created,
     returns dict = {
     "user_key" : "lkjdf983rhkfds09u",
     "stripe_account_id" : "acct_akldjfa08"
    */
    func createUser(user: User) -> Promise<[String: AnyObject]>{
        let url = "\(self.baseurl)/createUser"
        let params : [String : Any] = ["user": user.to_dict()]
        return Promise { fulfill, reject in
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value{
                        let json = result as! [String: AnyObject]
                        fulfill( json )
                    }
                case .failure( let error ):
                    reject(error)
                }
            }
        }
    }
    
    func login(email: String, password: String) -> Promise<[String: AnyObject]>{
        let url = "\(self.baseurl)/login"
        let params : [String : Any] = ["email": email,
                                       "password": password]
        return Promise { fulfill, reject in
            Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value{
                        let json = result as! [String: AnyObject]
                        fulfill( json )
                    }
                case .failure( let error ):
                    reject(error)
                }
            }

        }
    }
    
    func chargeRider(amount: Int) -> Promise<[String: AnyObject]>{
        let url = "\(self.baseurl)/chargeRider"
        let params : [String : Any] = ["user_key": RealmManager.shared.selfUser!.key,
                                       "customer_id": RealmManager.shared.selfUser!.customerId,
                                       "amount": amount]
        return Promise { fulfill, reject in
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value{
                        let json = result as! [String: AnyObject]
                        fulfill( json )
                    }
                case .failure( let error ):
                    reject(error)
                }
            }
            
        }
    }
    
    func updateNotificationToken(token: String){
        let url = "\(self.baseurl)/updateNotificationToken"
        let params : [String : Any] = ["user_key": RealmManager.shared.selfUser!.key,
                                       "token": token]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value{
                    let json = result as! [String: AnyObject]
                }
            case .failure( let error ):
                print( error )
            }
        }
    }
    
    func notifyRider() -> Promise<String>{
        let url = "\(self.baseurl)/notifyRider"
        let params : [String : Any] = [:]
        return Promise { fulfill, reject in
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value{
                        let json = result as! [String: AnyObject]
                        fulfill( "success" )
                    }
                case .failure( let error ):
                    reject(error)
                }
            }
        }
    }
    
    func reserveSeat(postKey: String) -> Promise<[String : AnyObject]>{
        let url = "\(self.baseurl)/reserveSeat"
        let params : [String : Any] = ["user_key": self.user_key,
                                       "post_key": postKey]
        print(params)
        return Promise { fulfill, reject in
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value{
                        let json = result as! [String: AnyObject]
                        
                        fulfill( json )
                    }
                case .failure( let error ):
                    reject(error)
                }
            }
        }
    }
    
    func getNotifications() -> Promise<String> {
        let url = "\(self.baseurl)/fetchNotifications?user_key=\(self.user_key)"
        return Promise { fulfill, reject in
            //Make call to the API
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let notifcations = result as! [[String:Any]]
                        var results : [realmNotification] = []
                        for notification in notifcations{
                            results.append( realmNotification(notification: notification as! [String: AnyObject]) )
                        }
                        RealmManager.shared.saveNotifications( notifications: results )
                        fulfill( "Success" )
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func acceptRider(notification: realmNotification) -> Promise<[String: Any]> {
        let url = "\(self.baseurl)/acceptRider"
        let params : [String : Any] = ["user_key": self.user_key,
                                      "rider_key" : notification.fromUserKey,
                                      "trip_key" : notification.tripKey]
        return Promise { fulfill, reject in
            //Make call to the API
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let success = result as! [String:Any]
                        fulfill( success )
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func denyRider(notification: realmNotification)-> Promise<[String : Any]>{
        let url = "\(self.baseurl)/denyRider"
        let params : [String : Any] = ["user_key": self.user_key,
                                       "rider_key" : notification.fromUserKey,
                                       "trip_key" : notification.tripKey]
        return Promise { fulfill, reject in
            //Make call to the API
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let success = result as! [String:Any]
                        fulfill( success )
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func requestFriend(friendKey: String){
        let url = "\(self.baseurl)/requestFriend"
        let params : [String : Any] = ["user_key": self.user_key,
                                       "friend_key" : friendKey]
        print("reqeustFriedn url => " , url)
        //Make call to the API
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                //get response
                if let result = response.result.value{
                    let success = result as! [String:Any]
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func removeFriend(friendKey: String){
        let url = "\(self.baseurl)/removeFriend"
        let params : [String : Any] = ["user_key": self.user_key,
                                       "friend_key" : friendKey]
        //Make call to the API
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                //get response
                if let result = response.result.value{
                    let success = result as! [String:Any]
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func removeRequest(friendKey: String){
        let url = "\(self.baseurl)/removeRequest"
        let params : [String : Any] = ["user_key": self.user_key,
                                       "friend_key" : friendKey]
        //Make call to the API
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                //get response
                if let result = response.result.value{
                    let success = result as! [String:Any]
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func acceptFriendRequest(friendKey: String){
        let url = "\(self.baseurl)/addFriend"
        let params : [String : Any] = ["user_key": self.user_key,
                                       "friend_key" : friendKey]
        //Make call to the API
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                //get response
                if let result = response.result.value{
                    let success = result as! [String:Any]
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deletePost(postKey: String) -> Promise<Bool>{
        let url = "\(self.baseurl)/deletePost"
        let params : [String : Any] = ["post_key": postKey]
        return Promise { fulfill, reject in
            //Make call to the API
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    //get response
                    fulfill(true)
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    
    func deleteAccount() -> Promise<Bool>{
        let url = "\(self.baseurl)/deleteAccount"
        let params : [String : Any] = ["user_key": self.user_key]
        return Promise { fulfill, reject in
            //Make call to the API
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let json = result as! [String:Any]
                        let success = json["success"] as? Bool
                        fulfill( success! )
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func updateSettings(first: String, last: String, email: String){
        let url = "\(self.baseurl)/updateUser"
        let params : [String : Any] = ["user_key": self.user_key,
                                       "first_name": first,
                                       "last_name": last,
                                       "email": email]
        
        //Make call to the API
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                //get response
                if let result = response.result.value{
                    let json = result as! [String:Any]
                    let success = json["success"] as? Bool
                    print( success )
                }
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    func searchAllUsers(query: String) -> Promise<[User]>{
        var q : NSString = query as NSString
        var cap = q.capitalized
        let url = "\(self.baseurl)/search"
        let params : [String : Any] = ["q" : cap,
                                       "user_key": self.user_key]
        var users : [User] = []
        return Promise { fulfill, reject in
            //Make call to the API
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let json = result as! [[String:Any]]
                       print(json)
                        for user in json{
                            users.append( User(user: (user as? [String : Any])!) )
                        }
                        fulfill( users )
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func checkEmail(email: String) -> Promise<Bool> {
        let url = "\(self.baseurl)/checkPilotEmail"
        let params : [String : Any] = ["email" : email]
        return Promise { fulfill, reject in
            //Make call to the API
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let json = result as! [[String:Any]]
                        fulfill( true )
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func addDriverPayoutInfo(dict: [String : Any], dob: String, creditCardInfo: CreditCardInfo, address:  PostalAddress){
        let url = "\(self.baseurl)/updateDriverPayment"
        //Make call to the API
        
        Alamofire.request(url, method: .post, parameters: dict, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                //get response
                if let result = response.result.value{
                    let json = result as! [String:Any]
                    if let cardId = json["card_id"] as? String{
                        //The card was saved successfully, save the users payout information to the database
                        RealmManager.shared.saveDriverInfo(id: cardId, dob: dob, creditCardInfo: creditCardInfo, addy: address)
                    }
                    
                    
                    print( true )
                }
            case .failure(let error):
                print(error)
                 RealmManager.shared.saveDriverInfo(id: nil, dob: dob, creditCardInfo: creditCardInfo, addy: address)
            }
        }
    }
    
    

    func url(endpoint: String) -> String{
        return self.baseurl + endpoint
    }
    
}
