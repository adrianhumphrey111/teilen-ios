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

class Network {
    
    var baseurl = ""
    var GooglePlacesApiWebServiceKey = "AIzaSyCL418H5jo-xpF2t3-1YmWsJktr48dU1Ho"
    let user_key = "ag1kZXZ-Z29hbC1yaXNlchELEgRVc2VyGICAgICAgIAKDA" //Production Perla key => agtzfmdvYWwtcmlzZXIRCxIEVXNlchiAgICAgICACgw
    var loginEndpoint : String = "10.0.0.6/api/login"
    var searchEndpoint : String = "10.0.0.6/api/search"
    var likePostEndpoint : String = "10.0.0.6/api/likePost"
    var createPostEndpoint : String = "10.0.0.6/api/createPost"
    var fetchPostEndpoint : String = "10.0.0.6/api/fetchPost"
    
    static let shared = Network(baseURL: "http://localhost:8080") //https://goal-rise.appspot.com
    
    init(baseURL: String) {
        self.baseurl = baseURL
    }
    
    func getFeed(user_key: String) -> Promise<Feed> {
        let url = "\(self.baseurl)/api/fetchFeed?user_key=\(self.user_key)"
        return Promise { fulfill, reject in
            //Make call to the API
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let posts = result as! [[String:Any]]
                        var feed = Feed(feed: posts)
                        fulfill(feed)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func getUserFeed(user_key: String) -> Promise<Feed> {
        let url = "\(self.baseurl)/api/fetchUserFeed?user_key=\(self.user_key)"
        return Promise { fulfill, reject in
            //Make call to the API
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let posts = result as! [[String:Any]]
                        var feed = Feed(feed: posts)
                        fulfill(feed)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func likePost(postKey: String){
        let url = "\(self.baseurl)/api/likePost?post_key=\(postKey)&user_key=\(self.user_key)"
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { response in
            print("Success: \(response.result.isSuccess)")
            print("Response String: \(response.result.value!)")
        }
    }
    
    func unLikePost(postKey: String){
        let url = "\(self.baseurl)/api/unlikePost?post_key=\(postKey)&user_key=\(self.user_key)"
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { response in
            print("Success: \(response.result.isSuccess)")
            print("Response String: \(response.result.value!)")
        }
    }
    
    func commentPost(postKey: String, comment: String) -> Promise<Comment> {
        let escapedCommentString = comment.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = "\(self.baseurl)/api/commentPost?post_key=\(postKey)&user_key=\(self.user_key)&comment=\(escapedCommentString!)"
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
        let escapedTextString = trip.postText?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = "\(self.baseurl)/api/createPost"
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
        var results : [String] = []
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
    
    
    
    
    func url(endpoint: String) -> String{
        return self.baseurl + endpoint
    }
    
}
