//
//  DirectionViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/12/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

class DirectionViewController: UIViewController {
    
    @IBOutlet weak var myLocation: UIImageView!
    @IBOutlet weak var guideLine: UIImageView!
    
    @IBOutlet weak var directionIcon: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var time: UILabel!

    @IBOutlet weak var dimView3: UIView!
    @IBOutlet weak var notificationView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        
        
        // Animate mylocation and time
        UIView.animateWithDuration(3, animations: { () -> Void in
            
            self.myLocation.frame = CGRect(x: 94, y: -100, width: 30, height: 30)
            self.guideLine.frame = CGRect(x: 94, y: 151, width: 30, height: -250)
            
        }) { (Bool) -> Void in
            
            self.distance.text = "                   0 feet"
            self.time.text = "Arrived"
            self.time.textAlignment = NSTextAlignment.Center
            self.directionIcon.image = UIImage(named: "FhooderOn")
            
            self.dimView3.alpha = 0.5
            self.notificationView.alpha = 1
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }
    
    

    @IBAction func segmentControl(sender: AnyObject) {
        
        switch sender.selectedSegmentIndex
        {
        case 0:
            return
        case 1:
            performSegueWithIdentifier("toMessagesView", sender: self)
        case 2:
            performSegueWithIdentifier("toMainView", sender: self)
        default:
            break
        }
        
    }
    
}
