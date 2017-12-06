//
//  InitialViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/12/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, PilotDelegate {
    
    
    lazy var loginCoordinator: LoginCoordinator = {
        return LoginCoordinator(rootViewController: self)
    }()
    var vc = FacebookPresentationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addChildViewController(vc)
        vc.view.frame = self.view.frame
        view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginCoordinator.rootViewController = vc
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
        
        let pilotPopup = PopupManager.shared.pilot()
        if let pilotPopupViewController = pilotPopup.viewController as? PilotCheckViewController{
            pilotPopupViewController.delegate = self
        }
        appDelegate.window?.rootViewController?.present(pilotPopup, animated: true, completion: nil)
    }
    
    func showPilotScreen(){
        let vc = PilotExcusionViewController(nibName: "PilotExcusionViewController", bundle: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
    }

}
