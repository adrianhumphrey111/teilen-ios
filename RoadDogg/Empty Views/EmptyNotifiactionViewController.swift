//
//  EmptyNotifiactionViewController.swift
//  Teilen
//
//  Created by Computer Science on 12/4/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class EmptyNotifiactionViewController: UIViewController {

    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondView.backgroundColor = .white
        secondView.layer.borderWidth = 1
        secondView.layer.borderColor = UIColor.lightGray.cgColor
        secondView.layer.cornerRadius = 8
        
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .lightGray
    
        
    }
    
    @IBAction func shareAction(_ sender: Any) {
        //Open this action to share to any where
        print("Why is this not popping up")
        let text = "Hey guys first 1000 people to download this app get half off their entire order at HIWI in Isla Vista on Pardall Rd. This is ridesharing app that connects you with people in your area that are travelin towards your destination. You can pay through the app to provide security and can also get notified on specific trip updates. Takes the entire Facebook Rideshare process of finding a ride and turns into 2 clicks. Download now => https://itunes.apple.com/us/app/teilen/id1320983318?ls=1&mt=8"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.mail  ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

}
