//
//  LaunchViewController.swift
//  Fhood
//
//  Created by Matias Pequeno on 8/30/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class LaunchViewController: UIViewController {

    @IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate var badConnectionLabel: UILabel!
    @IBOutlet fileprivate var logoutButton: UIButton!

    fileprivate weak var connectionTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.alpha = 0
        self.badConnectionLabel.alpha = 0
        self.logoutButton.alpha = 0
        
        if #available(iOS 10.0, *) {
            self.connectionTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
                guard self != nil else { return }
                
                self?.connectionTimer?.invalidate()
                
                UIView.animate {
                    self?.badConnectionLabel.alpha = 1
                }
                
                UIView.animate(delay: 1) {
                    self?.logoutButton.alpha = 1
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }

    deinit {
        self.connectionTimer?.invalidate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate {
            self.activityIndicator.alpha = 1
        }
    }

    @IBAction fileprivate func logoutTapped() {
        PFUser.logOutInBackground { error in
            Router.route(true)
        }
    }
}
