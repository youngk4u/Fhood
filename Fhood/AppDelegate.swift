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
import OneSignal


@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Initiailize Vendor modules like Parse, Braintree, etc.
        self.loadVendorLibraries()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.getPublicReadAccess = true
        
        PFACL.setDefault(defaultACL, withAccessForCurrentUser:true)
        
//        if application.applicationState != UIApplicationState.background {
//            // Track an app open here if we launch with a push, unless
//            // "content_available" was used to trigger a background push (introduced in iOS 7).
//            // In that case, we skip tracking here to avoid double counting the app-open.
//            
//            let preBackgroundPush = !application.responds(to: #selector(getter: UIApplication.backgroundRefreshStatus))
//            let oldPushHandlerOnly = !self.responds(to: #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
//            var noPushPayload = false;
//            if let options = launchOptions {
//                noPushPayload = options[UIApplicationLaunchOptionsKey.remoteNotification] != nil;
//            }
//            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
//                PFAnalytics.trackAppOpened(launchOptions: launchOptions)
//            }
//        }
        
        
        
        
        // OneSignal Setting
        OneSignal.initWithLaunchOptions(launchOptions, appId: Constants.Vendor.OneSignalID) { (result) in
            
            // This block gets called when the user reacts to a notification received
            
            let payload = result?.notification.payload
            let messageTitle = "OneSignal Example"
            var fullMessage = payload?.title
            
            //Try to fetch the action selected
            if let additionalData = payload?.additionalData, let actionSelected = additionalData["actionSelected"] as? String {
                fullMessage =  fullMessage! + "\nPressed ButtonId:\(actionSelected)"
            }
            
            let alertView = UIAlertController(title: messageTitle, message: fullMessage, preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.window?.rootViewController?.present(alertView, animated: true, completion: nil)
        }

        
        
        
        
//        func registerForPushNotifications(application: UIApplication) {
//            
//            if #available(iOS 10.0, *){
//                UNUserNotificationCenter.current().delegate = self
//                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
//                    if (granted)
//                    {
//                        UIApplication.shared.registerForRemoteNotifications()
//                    }
//                    else{
//                        //Do stuff if unsuccessful...
//                    }
//                })
//            }
//                
//            else{ //If user is not on iOS 10 use the old methods we've been using
//                let types: UIUserNotificationType = [.alert, .badge, .sound]
//                let settings = UIUserNotificationSettings(types: types, categories: nil)
//                application.registerUserNotificationSettings(settings)
//                application.registerForRemoteNotifications()
//            }
//            
//        }
        
        
        // Badge number set to 0 once app is opended
        //UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        



        if PFUser.current() != nil {
            let user = PFUser.current()!
            if user["isFhooder"] != nil {
                let query = PFQuery(className: "Fhooder")
                let id = ((user.value(forKey: "fhooder") as AnyObject).objectId)!! as String
                query.getObjectInBackground(withId: id) { (fhooder: PFObject?, error: Error?) -> Void in
                    if error == nil && fhooder != nil {
                        let openStatus = fhooder!["isOpen"] as! Bool
                        if openStatus == true {
                            Fhooder.fhooderSignedIn = true
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            Router.route(false)
                            self.window?.makeKeyAndVisible()
                        }
                    }
                }
            }
        }
        
    
        self.window = UIWindow(frame: UIScreen.main.bounds)
        Router.route(false)
        self.window?.makeKeyAndVisible()

        PFAnalytics.trackAppOpened(launchOptions: launchOptions)
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)

        return true
    }
    
    
    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------

    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
//        let installation = PFInstallation.current()
//        installation!.setDeviceTokenFrom(deviceToken)
//        installation!.saveInBackground()
//        
//        PFPush.subscribeToChannel(inBackground: "") { (succeeded: Bool, error: Error?) in
//            if succeeded {
//                print("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.\n");
//            } else {
//                print("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.\n", error as Any)
//            }
//        }
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        if error._code == 3010 {
//            print("Push notifications are not supported in the iOS Simulator.\n")
//        } else {
//            print("application:didFailToRegisterForRemoteNotificationsWithError: %@\n", error)
//        }
    }
    
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
//        let id = userInfo["type"] as? String
//        
//        // If the app is closed
//        if application.applicationState == UIApplicationState.inactive {
//            if id == "ordered" {
//                UIApplication.shared.applicationIconBadgeNumber += 1
//                Fhooder.orderQuantity! += 1
//                NotificationCenter.default.post(name: Notification.Name(rawValue: "postBadgeRefresh"), object: nil)
//            }
//            // Refreshing Fhooder's order list
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "fhooderOrderLoad"), object: nil)
//            PFAnalytics.trackAppOpened(withRemoteNotificationPayload: userInfo)
//        } else {
//            if id == "ordered" {
//                UIApplication.shared.applicationIconBadgeNumber += 1
//                Fhooder.orderQuantity! += 1
//                NotificationCenter.default.post(name: Notification.Name(rawValue: "postBadgeRefresh"), object: nil)
//            }
//            else if id == "fhoodieCancelled" {
//            }
//            else if id == "fhooderCancelled" {
//            }
//        }
//        // Refreshing Fhooder's order list
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "fhooderOrderLoad"), object: nil)
//        PFPush.handle(userInfo)
    }
    
    

    

    func loadVendorLibraries() {
        Parse.enableLocalDatastore()
        
        let config = ParseClientConfiguration { (ParseMutableClientConfiguration) in
            ParseMutableClientConfiguration.applicationId = Constants.Vendor.ParseApplicationID
            ParseMutableClientConfiguration.clientKey = Constants.Vendor.ParseClientKey
            ParseMutableClientConfiguration.server = Constants.Vendor.ParseServerURL
        }
        
        Parse.initialize(with: config)

        FBSDKSettings.setAppID(Constants.Vendor.FacebookAppID)
        FBSDKSettings.setLoggingBehavior(Set())
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url,
            sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        application.beginReceivingRemoteControlEvents()
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
}

extension UIImage {
    var highestQualityJPEGNSData: Data { return UIImageJPEGRepresentation(self, 1.0)! }
    var highQualityJPEGNSData: Data    { return UIImageJPEGRepresentation(self, 0.75)!}
    var mediumQualityJPEGNSData: Data  { return UIImageJPEGRepresentation(self, 0.5)! }
    var lowQualityJPEGNSData: Data     { return UIImageJPEGRepresentation(self, 0.25)!}
    var lowestQualityJPEGNSData: Data  { return UIImageJPEGRepresentation(self, 0.0)! }
}

// Turns NSDate to PST formatted string
extension Date {
    func localDate (_ Date: Foundation.Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMM d, yyyy, hh:mm aaa"
        return dateFormatter.string(from: Date)
    }
}
