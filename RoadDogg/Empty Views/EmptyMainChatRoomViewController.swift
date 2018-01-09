//
//  EmptyMainChatRoomViewController.swift
//  Teilen
//
//  Created by Adrian Humphrey on 1/9/18.
//  Copyright © 2018 Adrian Humphrey. All rights reserved.
//

import UIKit

class EmptyMainChatRoomViewController: UIViewController {
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
}
