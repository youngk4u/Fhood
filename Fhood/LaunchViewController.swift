//
//  LaunchViewController.swift
//  Fhood
//
//  Created by Matias Pequeno on 8/30/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit
import Parse
import LambdaKit

final class LaunchViewController: UIViewController {

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var badConnectionLabel: UILabel!
    @IBOutlet private var logoutButton: UIButton!

    private weak var connectionTimer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.alpha = 0
        self.badConnectionLabel.alpha = 0
        self.logoutButton.alpha = 0
        
        self.connectionTimer = NSTimer.scheduledTimerWithTimeInterval(5, repeated: false) { [weak self] _ in
            guard self != nil else { return }

            self?.connectionTimer?.invalidate()

            UIView.animate {
                self?.badConnectionLabel.alpha = 1
            }

            UIView.animate(delay: 1) {
                self?.logoutButton.alpha = 1
            }
        }
    }

    deinit {
        self.connectionTimer?.invalidate()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate {
            self.activityIndicator.alpha = 1
        }
    }

    @IBAction private func logoutTapped() {
        PFUser.logOutInBackgroundWithBlock { error in
            Router.route(animated: true)
        }
    }
}
