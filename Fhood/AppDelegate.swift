//
//  AppDelegate.swift
//  Fhood
//
//  Created by Young-hu Kim on 5/17/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import UserNotifications


@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Initiailize Vendor modules like Parse, Stripe, etc.
        self.loadVendorLibraries()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.publicReadAccess = true
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector(Selector("backgroundRefreshStatus"))
            let oldPushHandlerOnly = !self.respondsToSelector(#selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }

        
        func registerForPushNotifications(application: UIApplication) {
            
            if #available(iOS 10.0, *){
                UNUserNotificationCenter.currentNotificationCenter().delegate = self
                UNUserNotificationCenter.currentNotificationCenter().requestAuthorizationWithOptions([.Badge, .Sound, .Alert], completionHandler: {(granted, error) in
                    if (granted)
                    {
                        UIApplication.sharedApplication().registerForRemoteNotifications()
                    }
                    else{
                        //Do stuff if unsuccessful...
                    }
                })
            }
                
            else{ //If user is not on iOS 10 use the old methods we've been using
                let notificationSettings = UIUserNotificationSettings(
                    forTypes: [.Badge, .Sound, .Alert], categories: nil)
                application.registerUserNotificationSettings(notificationSettings)
                application.registerForRemoteNotifications()
            }
            
        }
        
        
        // Badge number set to 0 once app is opended
        //UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
//        let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
//        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
//        application.registerUserNotificationSettings(settings)
//        application.registerForRemoteNotifications()


        if PFUser.currentUser() != nil {
            let user = PFUser.currentUser()!
            let query = PFQuery(className: "Fhooder")
            let id = (user.valueForKey("fhooder")?.objectId)! as String
            query.getObjectInBackgroundWithId(id) { (fhooder: PFObject?, error: NSError?) -> Void in
                if error == nil && fhooder != nil {
                    let openStatus = fhooder!["isOpen"] as! Bool
                    if openStatus == true {
                        Fhooder.fhooderSignedIn = true
                        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                        Router.route(false)
                        self.window?.makeKeyAndVisible()
                    }
                }
            }
        }
        
    
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        Router.route(false)
        self.window?.makeKeyAndVisible()

        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)

        return true
    }
    
    
    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------
    
    
//    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
//        
//        UIApplication.sharedApplication().registerForRemoteNotifications()
//    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation!.setDeviceTokenFromData(deviceToken)
        installation!.saveInBackground()
        
        PFPush.subscribeToChannelInBackground("") { (succeeded: Bool, error: NSError?) in
            if succeeded {
                print("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.\n");
            } else {
                print("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.\n", error)
            }
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.\n")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@\n", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        } else {
            
            let id = userInfo["type"] as? String
            if id == "ordered" {
                
                UIApplication.sharedApplication().applicationIconBadgeNumber = 4
                application.applicationIconBadgeNumber = 9
                
                let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Fhooder", bundle: nil)
                let orderViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("FhooderTabController") as! FhooderTabBarController
                orderViewController.selectedIndex = 1
                //self.window?.rootViewController = orderViewController
            }
            else if id == "fhoodieCancelled" {
                
            }
            else if id == "fhooderCancelled" {
                
                let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let orderViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("orderViewController")
                orderViewController.performSegueWithIdentifier("unwindToViewController", sender: self)
            }
            
            PFPush.handlePush(userInfo)
            NSNotificationCenter.defaultCenter().postNotificationName("OrderListLoad", object: nil)
        }
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        //Handle the notification
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        //Handle the notification
    }
    
    

    func loadVendorLibraries() {
        Parse.enableLocalDatastore()
        Parse.setApplicationId(Constants.Vendor.ParseApplicationID, clientKey: Constants.Vendor.ParseClientKey)

        FBSDKSettings.setAppID(Constants.Vendor.FacebookAppID)
        FBSDKSettings.setLoggingBehavior(Set())
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url,
            sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillResignActive(application: UIApplication) {

    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidEnterBackground(application: UIApplication) {

    }

    func applicationWillTerminate(application: UIApplication) {

    }
}

extension UIImage {
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)! }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)!}
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)! }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)!}
    var lowestQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.0)! }
}

// Turns NSDate to PST formatted string
extension NSDate {
    func localDate (Date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "MMM d, yyyy, hh:mm aaa"
        return dateFormatter.stringFromDate(Date)
    }
}
