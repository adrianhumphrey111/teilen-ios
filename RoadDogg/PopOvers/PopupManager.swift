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
    
    var user : loggedInUser!
    
    init(){
        self.user = RealmManager.shared.selfUser!
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
    
    public func deleteAccount() -> PopupDialog{
        // Prepare the popup
        let vc = DeleteAccountPopupViewController(nibName: "DeleteAccountPopupViewController", bundle: nil)
        // Create the dialog
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        return popup
    }
    
    public func logout() -> PopupDialog{
        // Prepare the popup
        let vc = LogoutPopupViewController(nibName: "LogoutPopupViewController", bundle: nil)
        // Create the dialog
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        return popup
    }
    
    public func pilot() -> PopupDialog{
        // Prepare the popup
        let vc = PilotCheckViewController(nibName: "PilotCheckViewController", bundle: nil)
        // Create the dialog
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        return popup
    }
    
}





