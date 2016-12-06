//
//  Router.swift
//  Fhood
//
//  Created by Matias Pequeno on 8/30/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse
import SWRevealViewController

struct Router {

    fileprivate static var rootViewController: UIViewController {
        if PFUser.current()?.isAuthenticated == true {
            if Fhooder.fhooderSignedIn == true {
                return self.fhooderViewController
            }
            else {
                return self.mainViewController
            }
        } else if PFUser.current() != nil {
            return self.launchViewController
        } else {
            return self.onboardingViewController
        }
    }

    static func route(_ animated: Bool) {
        guard let window = UIApplication.shared.delegate?.window! else { return }
        let rootViewController = self.rootViewController

        if !animated || window.rootViewController == nil {
            return window.rootViewController = rootViewController
        }

        let snapshotView = window.snapshotView(afterScreenUpdates: true)
        rootViewController.view.addSubview(snapshotView!)
        window.rootViewController = rootViewController

        UIView.animate(withDuration: 0.5, animations: {
            snapshotView!.layer.opacity = 0
            snapshotView!.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }, completion: { _ in
            snapshotView!.removeFromSuperview()
        })
    }
}

// MARK: - View Controllers

extension Router {

    fileprivate static var onboardingViewController: UIViewController {
        let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        return onboardingStoryboard.instantiateInitialViewController()!
    }
    
    fileprivate static var fhooderViewController: UIViewController {
        let fhooderStoryboard = UIStoryboard(name: "Fhooder", bundle: nil)
        let revealStoryboard = UIStoryboard(name: "Reveal", bundle: nil)
        let ManageController = fhooderStoryboard.instantiateInitialViewController()!
        let accountViewController = revealStoryboard.instantiateInitialViewController()
                
        return SWRevealViewController(rearViewController: accountViewController, frontViewController: ManageController)!
    }

    fileprivate static var mainViewController: UIViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let revealStoryboard = UIStoryboard(name: "Reveal", bundle: nil)
        let tabBarController = mainStoryboard.instantiateInitialViewController()
        let accountViewController = revealStoryboard.instantiateInitialViewController()
        return SWRevealViewController(rearViewController: accountViewController, frontViewController: tabBarController)!
    }

    fileprivate static var launchViewController: LaunchViewController {
        return LaunchViewController(nibName: "LaunchScreen", bundle: nil)
    }
}
