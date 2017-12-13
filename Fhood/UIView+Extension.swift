//
//  UIView+Extension.swift
//  Fhood
//
//  Created by Matias Pequeno on 9/1/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

public let kDefaultFadeDuration = 0.5

extension UIView {
    
    
    /**
    Animate changes to one or more views using the specified duration, delay, options. Adds defaults and
    allows for trailing closures. `delay` and `options` parameters are optional.

    :param: duration   The total duration of the animations, measured in seconds.
    :param: delay      The amount of time (measured in seconds) to wait before beginning the animations.
    :param: options    A mask of options indicating how you want to perform the animations. For a list of
                       valid constants, see UIViewAnimationOptions.
    :param: animations A closure containing the changes to commit to the views. This parameter must not be nil
    */
    public class func animate(withDuration duration: TimeInterval = kDefaultFadeDuration,
        delay: TimeInterval = 0, options: UIViewAnimationOptions = [], animations: @escaping () -> Void)
    {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations,
            completion: nil)
    }
}
