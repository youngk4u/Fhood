    //
//  AppDelegate.swift
//  Fhood
//
//  Created by Young-hu Kim on 5/17/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Initiailize Vendor modules like Parse, Stripe, etc.
        self.loadVendorLibraries()

        // Since we are not using any default XIB we have to create the window.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        Router.route(animated: false)
        self.window?.makeKeyAndVisible()

        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // Instantiate rootview to test Fhooder Storyboard
        //let storyboard = UIStoryboard(name: "Fhooder", bundle: nil)
        //self.window?.rootViewController = storyboard.instantiateInitialViewController()
        

        return true
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