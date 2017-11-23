//
//  PopupManager.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/22/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import PopupDialog

class PopupManager {
    
    
    static let shared = PopupManager()
    
    init(){
        
    }
    
    public func reserveSeat(price: Int, postKey: String) -> PopupDialog{
        // Create a custom view controller
        let vc = ReserveSeatPopupViewController(nibName: "ReserveSeatPopupViewController", bundle: nil)
        vc.price = price
        vc.postKey = postKey
        // Create the dialog
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        return popup
    }
    
}
