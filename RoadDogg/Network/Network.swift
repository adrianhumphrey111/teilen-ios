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

class Network {
    
    var GooglePlacesApiWebServiceKey = "AIzaSyCL418H5jo-xpF2t3-1YmWsJktr48dU1Ho"
    
    var baseurl = ""
    var basedev = "http://localhost:8080/api"
    var baseProd = "https:goal-rise.appspot.com/api"
    
    var user_key = ""
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
            self.user_key = prodKey
        }
        
        if let user = RealmManager.shared.selfUser{
            self.user_key = user.key
        }
        else{
            print("No calls will work, because there is no logged in user")
            //Handle this situation
        }
    }
    
    func getFeed() -> Promise<Feed> {
        let url = "\(self.baseurl)/fetchFeed?user_key=\(self.user_key)"
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
    
    func getUserFeed(user_key: String) -> Promise<Feed> {
        let url = "\(self.baseurl)/fetchUserFeed?user_key=\(self.user_key)"
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
        let url = "\(self.baseurl)/createPost"
        let params : [String : Any] = ["user_key": self.user_key,
                      "post_text": trip.postText!.encoded(),
                      "trip": trip.to_dict()
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
                        keys.append(post_key)
                        keys.append(trip_key)
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
                    print(data)
                    fulfill(user)
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
    
    

    
    func url(endpoint: String) -> String{
        return self.baseurl + endpoint
    }
    
}
