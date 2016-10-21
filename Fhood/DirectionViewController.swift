//
//  DirectionViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/12/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

final class DirectionViewController: UIViewController {

    @IBOutlet weak var notificationView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Animate mylocation and time
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.85)
        self.notificationView.alpha = 1
        
    }

}
