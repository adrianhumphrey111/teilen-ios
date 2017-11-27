//
//  TabBarViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/3/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        tabBar.tintColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
