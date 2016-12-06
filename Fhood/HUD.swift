//
//  HUD.swift
//  Fhood
//
//  Created by Matias Pequeno on 8/30/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import JGProgressHUD

struct HUD {
    fileprivate static var currentHUD: JGProgressHUD?

    static func show(withText text: String? = nil) {
        guard let window = UIApplication.shared.delegate?.window! else { return }

        self.dismiss()

        self.currentHUD = JGProgressHUD(style: .dark)
        self.currentHUD?.textLabel.text = text
        self.currentHUD?.textLabel.font = UIFont.systemFont(ofSize: 15.0)
        self.currentHUD?.animation = JGProgressHUDFadeZoomAnimation()
        self.currentHUD?.show(in: window, animated: true)
    }

    static func dismiss(afterDelay delay: TimeInterval? = nil) {
        guard let currentHUD = self.currentHUD else { return }

        guard let delay = delay else {
            return currentHUD.dismiss()
        }

        currentHUD.dismiss(afterDelay: delay)
    }
}
