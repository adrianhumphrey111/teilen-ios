//
//  InitialViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/12/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {


    lazy var loginCoordinator: LoginCoordinator = {
        return LoginCoordinator(rootViewController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginCoordinator.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMainViewController(){
        //Dismiss the keyboard
        self.view.endEditing( true )
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "maintabview") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
    }

}
