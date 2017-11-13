//
//  OnBoardTestViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/11/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FacebookCore

class OnBoardTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        
        var button = UIButton(frame: CGRect(x: view.frame.size.width / 2,
                                            y: view.frame.size.height / 2,
                                            width: 200,
                                            height: 100))
        button.backgroundColor = .black
        button.setTitle("FaceBook Log in", for: .normal)
        button.center = self.view.center
        button.addTarget(self, action: #selector(fblogin), for: UIControlEvents.touchUpInside)
        self.view.addSubview( button )
        
    }
    
    @objc private func fblogin(){
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends", "user_education_history"], from: self) { (result , error) in
            if ( error == nil ){
                print( result?.grantedPermissions )
                //This was successful
                print( "Show main view controller" )
                self.showMainViewController()
                Network.shared.retriveUserFromFacebook().then { user -> Void in
                    Network.shared.createUser(user: user).then { result -> Void in
                        //Set this user key
                        print("The user key that was created => " , result)
                        
                        //Show the home screen or more onboarding.
                    }
                }
            }
            else if ( result?.isCancelled )!{
                print( "The user cancelled the request")
            }
            else{
                print(error)
            }
        }
    }
    
    func showMainViewController(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "maintabview") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
    }
    
    
}
