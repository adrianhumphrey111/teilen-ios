//
//  PrivacyViewController.swift
//  Teilen
//
//  Created by Adrian Humphrey on 12/3/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let webV:UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        webV.loadRequest(URLRequest(url: URL(string: "http://www.teilen-ride.com/api/privacy-policy")!))
        self.view.addSubview(webV)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }


}
