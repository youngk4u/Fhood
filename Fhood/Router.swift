//
//  Router.swift
//  Fhood
//
//  Created by Matias Pequeno on 8/30/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit
import Parse
import SWRevealViewController

struct Router {

    private static var rootViewController: UIViewController {
        if PFUser.currentUser()?.isAuthenticated() == true {
            return self.mainViewController
        } else if PFUser.currentUser() != nil {
            return self.launchViewController
        } else {
            return self.onboardingViewController
        }
    }

    static func route(animated animated: Bool) {
        guard let window = UIApplication.sharedApplication().delegate?.window! else { return }
        let rootViewController = self.rootViewController

        if !animated || window.rootViewController == nil {
            return window.rootViewController = rootViewController
        }

        let snapshotView = window.snapshotViewAfterScreenUpdates(true)
        rootViewController.view.addSubview(snapshotView)
        window.rootViewController = rootViewController

        UIView.animateWithDuration(0.5, animations: {
            snapshotView.layer.opacity = 0
            snapshotView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }, completion: { _ in
            snapshotView.removeFromSuperview()
        })
    }
}

// MARK: - View Controllers

extension Router {

    private static var onboardingViewController: UIViewController {
        let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        return onboardingStoryboard.instantiateInitialViewController()!
    }

    private static var mainViewController: UIViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let revealStoryboard = UIStoryboard(name: "Reveal", bundle: nil)
        let tabBarController = mainStoryboard.instantiateInitialViewController()
        let accountViewController = revealStoryboard.instantiateInitialViewController()
        return SWRevealViewController(rearViewController: accountViewController, frontViewController: tabBarController)!
    }

    private static var launchViewController: LaunchViewController {
        return LaunchViewController(nibName: "LaunchScreen", bundle: nil)
    }
}
