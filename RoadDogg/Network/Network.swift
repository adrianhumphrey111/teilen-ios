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
    let user_key = "ag1kZXZ-Z29hbC1yaXNlchELEgRVc2VyGICAgICAgMAKDA"
    var loginEndpoint : String = "10.0.0.6/api/login"
    var searchEndpoint : String = "10.0.0.6/api/search"
    var likePostEndpoint : String = "10.0.0.6/api/likePost"
    var createPostEndpoint : String = "10.0.0.6/api/createPost"
    var fetchPostEndpoint : String = "10.0.0.6/api/fetchPost"
    
    static let shared = Network(baseURL: "http:localhost:8080")
    
    init(baseURL: String) {
        self.baseurl = baseURL
    }
    
    func getFeed(user_key: String) -> Promise<Feed> {
        let url = "\(self.baseurl)/api/fetchPost?user_key=\(user_key)"
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
        let url = "\(self.baseurl)/api/commentPost?post_key=\(postKey)&user_key=\(self.user_key)&comment=\(comment)"
        return Promise { fulfill, reject in
            Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                switch response.result {
                case .success:
                    //get response
                    if let result = response.result.value{
                        let json = result as! [String:Any]
                        var jsonComment = json["comment"] as! [String: Any]
                        print(jsonComment)
                        var comment = Comment(comment: jsonComment)
                        fulfill(comment)
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
