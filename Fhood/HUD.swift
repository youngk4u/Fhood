//
//  HUD.swift
//  Fhood
//
//  Created by Matias Pequeno on 8/30/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import JGProgressHUD

struct HUD {
    private static var currentHUD: JGProgressHUD?

    static func show(withText text: String? = nil) {
        guard let window = UIApplication.sharedApplication().delegate?.window! else { return }

        self.dismiss()

        self.currentHUD = JGProgressHUD(style: .Dark)
        self.currentHUD?.textLabel.text = text
        self.currentHUD?.textLabel.font = UIFont.systemFontOfSize(15.0)
        self.currentHUD?.animation = JGProgressHUDFadeZoomAnimation()
        self.currentHUD?.showInView(window, animated: true)
    }

    static func dismiss(afterDelay delay: NSTimeInterval? = nil) {
        guard let currentHUD = self.currentHUD else { return }

        guard let delay = delay else {
            return currentHUD.dismiss()
        }

        currentHUD.dismissAfterDelay(delay)
    }
}
