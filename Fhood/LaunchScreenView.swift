//
//  LaunchScreenView.swift
//  Fhood
//
//  Created by Matias Pequeno on 8/30/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit
import SnapKit
import ClosureKit

final class LaunchScreenView: UIView {

    private weak var connectionTimer: NSTimer?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.createLayout()
        self.startConnectionTimer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        self.cancelConnectionTimer()
    }

    func dismiss() {
        self.cancelConnectionTimer()
        UIView.animateWithDuration(0.5, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    // MARK: - Private functions

    private func createLayout() {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicatorView.hidesWhenStopped = false
        activityIndicatorView.startAnimating()

        self.addSubview(activityIndicatorView)
        activityIndicatorView.snp_makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-32)
        }

        activityIndicatorView.alpha = 0
        UIView.animateWithDuration(0.5) {
            activityIndicatorView.alpha = 1
        }
    }

    private func startConnectionTimer() {
        self.connectionTimer = NSTimer.scheduledTimerWithTimeInterval(5, repeats: false) { [weak self] _ in
            self?.cancelConnectionTimer()
            self?.showBadConnectionMessage()
            self?.showLogoutButton()
        }
    }

    private func cancelConnectionTimer() {
        self.connectionTimer?.invalidate()
    }

    private func showBadConnectionMessage() {
        let badConnectionLabel = UILabel()
        badConnectionLabel.text = "Poor network connectivity"
        badConnectionLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        badConnectionLabel.font = UIFont.systemFontOfSize(16)

        self.addSubview(badConnectionLabel)
        badConnectionLabel.snp_makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-50)
        }

        badConnectionLabel.alpha = 0
        UIView.animateWithDuration(0.5) {
            badConnectionLabel.alpha = 1
        }
    }

    private func showLogoutButton() {
        let logoutButton = UIButton()
        logoutButton.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        logoutButton.setTitle("Log out", forState: .Normal)
        logoutButton.addEventHandler(forControlEvents: .TouchUpInside) { _ in
            // TODO: logout
        }

        self.addSubview(logoutButton)
        logoutButton.snp_makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-14)
        }

        logoutButton.alpha = 0
        UIView.animateWithDuration(1, delay: 1, options: [], animations: {
            logoutButton.alpha = 1
        }, completion: nil)
    }
}
