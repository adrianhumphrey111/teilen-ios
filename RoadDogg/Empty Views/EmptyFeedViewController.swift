//
//  EmptyFeedViewController.swift
//  Teilen
//
//  Created by Computer Science on 12/4/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class EmptyFeedViewController: UIViewController {

    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var snapchatButton: UIButton!
    
    @IBOutlet weak var instagramButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondView.backgroundColor = .white
        secondView.layer.borderWidth = 1
        secondView.layer.borderColor = UIColor.lightGray.cgColor
        secondView.layer.cornerRadius = 8
        
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .lightGray
        
        shareButton.setTitle("Share Teilen!", for: .normal)
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        shareButton.layer.cornerRadius = 8
        
        
        snapchatButton.setTitle("Add Us on Snapchat!", for: .normal)
        snapchatButton.setTitleColor(.black, for: .normal)
        snapchatButton.backgroundColor = .yellow
        snapchatButton.layer.cornerRadius = 8
        
        instagramButton.setTitle("Add Us on Instagram!", for: .normal)
        instagramButton.setTitleColor(.black, for: .normal)
        instagramButton.backgroundColor = UIColor().colorWithHexString(hex: "#fb3958", alpha: 0.8)
        instagramButton.layer.cornerRadius = 8
        
    
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
    @IBAction func instagramAction(_ sender: Any) {
        
        let instagramHooks = "instagram://user?username=teilenapp"
        let instagramUrl = URL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl!)
        {
            UIApplication.shared.open(instagramUrl!, options: [:], completionHandler: nil)
            
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.open(URL(string: "http://instagram.com/")!, options: [:], completionHandler: nil)
        }
        
    }
    
    @IBAction func snapchatAction(_ sender: Any) {
        let snapchathooks = "snapchat://add/teilenrideshare"
        let snapchatUrl = URL(string: snapchathooks)
        if UIApplication.shared.canOpenURL(snapchatUrl!)
        {
            UIApplication.shared.open(snapchatUrl!, options: [:], completionHandler: nil)
            
        } else {
            //redirect to safari because the user doesn't have snapchat
            UIApplication.shared.open(URL(string: "http://snapchat.com/")!, options: [:], completionHandler: nil)
        }
    }
    
    
}
