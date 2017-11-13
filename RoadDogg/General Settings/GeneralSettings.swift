//
//  GeneralSettings.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/11/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation


class GeneralSettings : NSObject{
    
    /**
     Stores a boolean value to set the onboarding was completed
     */
    class func saveOnboardingFinished() {
        UserDefaults.standard.set(true, forKey: "onboarding")
        UserDefaults.standard.synchronize()
    }
    
    /**
     Returns the stored boolean key from NSUserDefaults for checking if the onboarding was completed already or not.
     
     - returns: YES, if the onboarding was already completed before
     */
    class func isOnboardingFinished() -> Bool {
        return UserDefaults.standard.bool(forKey: "onboarding")
    }
    
}
