//
//  EmptyTripViewController.swift
//  Teilen
//
//  Created by Adrian Humphrey on 12/7/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class EmptyTripViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var secondView: UIView!
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
