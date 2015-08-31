//
//  AppDelegate.swift
//  Fhood
//
//  Created by Young-hu Kim on 5/17/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit
import SWRevealViewController
import Parse
import Bolts

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private var onboardingViewController: UIViewController? {
        let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        return onboardingStoryboard.instantiateInitialViewController()
    }

    private var mainViewController: UIViewController? {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let revealStoryboard = UIStoryboard(name: "Reveal", bundle: nil)
        let tabBarController = mainStoryboard.instantiateInitialViewController()
        let accountViewController = revealStoryboard.instantiateInitialViewController()
        return SWRevealViewController(rearViewController: accountViewController, frontViewController: tabBarController)
    }

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.loadVendorLibraries(withLaunchOptions: launchOptions)

        // Since we are not using any default XIB we have to create the window.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let rootViewController: UIViewController?
        if let currentUser = PFUser.currentUser(), token = currentUser.sessionToken {
            rootViewController = self.mainViewController
            // TODO: Show extended launch
            PFUser.becomeInBackground(token, block: { user, error in
                print("becomeInBackground ended with user: \(user) and error: \(error)")
            })
        } else {
            rootViewController = self.onboardingViewController
        }

        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()

        return true
    }

    func loadVendorLibraries(withLaunchOptions launchOptions: [NSObject: AnyObject]?) {
        Parse.enableLocalDatastore()
        Parse.setApplicationId(Constants.Vendor.ParseApplicationID, clientKey: Constants.Vendor.ParseClientKey)
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
