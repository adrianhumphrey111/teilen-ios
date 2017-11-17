//
//  AppDelegate.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/22/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import Onboard
import Stripe
import Firebase
import UserNotifications
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UITabBarControllerDelegate, MessagingDelegate {
    
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Facebook SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Stripe SDK
        STPPaymentConfiguration.shared().publishableKey = "pk_live_1SGsf48hM8JYS40mgge6CR8l"
        
        //Firebase SDK
        FirebaseApp.configure()
        
        //Firebase Messaging
        Messaging.messaging().delegate = self as! MessagingDelegate
        
        //Initialize realm singleton
        RealmManager.shared
        
        //Register for push notifications
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        application.registerForRemoteNotifications()
        
        //Check if the user is logged in
        if ( RealmManager.shared.isLoggedin() ) {
            print("This user is already logged in, show the main page.")
        }
        else{
            //print("Either have the user log in or sign in through facebook")
            let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier :"onboard1") as! OnBoardTestViewController
            //Set up onBoarding experience
            let firstPage = OnboardingContentViewController(title: "Welcome to Teilen!", body: "Automated and Social Ride Sharing", image: nil, buttonText: "Next") { () -> Void in
                
            }
            firstPage.movesToNextViewController = true
            firstPage.bodyLabel.font = firstPage.bodyLabel.font.withSize(18)
            //Customize button firstPage.actionButton =
            let secondPage = OnboardingContentViewController(title: "Ride Along With Friends", body: "Save your $$$ and time by riding around w/ friends. No more unreliable Ubers or pesky public transportation.", image: nil, buttonText: "Next") { () -> Void in
            }
            secondPage.movesToNextViewController = true
            secondPage.bodyLabel.font = secondPage.bodyLabel.font.withSize(18)
            
            let thirdPage = OnboardingContentViewController(title: "Automatically Notified", body: "Teilen will notify you when a friend is heading in your preferred direction.", image: nil, buttonText: "Next") { () -> Void in
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
                print("Third Button")
            }
            thirdPage.movesToNextViewController = true
            thirdPage.bodyLabel.font = thirdPage.bodyLabel.font.withSize(18)
            
            let fourthPage = OnboardingContentViewController(title: "Get Paid at Your Convenience !", body: "Make some extra cash driving others going your way.", image: nil, buttonText: "Get Started") { () -> Void in
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
                print("Fourth Button")
                
                //Login View
                let login = InitialViewController()
                
                //Set the root view controller
                self.window?.rootViewController = login
            }
            
            //Customize the last button. What is the functionality? Get sTarted on What?
            fourthPage.actionButton.layer.borderColor = UIColor.white.cgColor
            fourthPage.actionButton.layer.borderWidth = 1.0
            fourthPage.actionButton.layer.backgroundColor = UIColor.blue.cgColor
            fourthPage.actionButton.layer.cornerRadius = 25
            
            //Create the final view controller
            var onboardingVC = OnboardingViewController(backgroundImage: nil, contents: [firstPage, secondPage, thirdPage, fourthPage])
            onboardingVC?.view.backgroundColor = .blue
            onboardingVC?.allowSkipping = true;
            
            //Set the root view controller
            self.window?.rootViewController = onboardingVC
        }
        return true
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo["gcmMessageIDKey"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo["gcmMessageIDKey"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        return handled
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (viewController is NewPostViewController) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPost")
            tabBarController.present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "RoadDogg")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

