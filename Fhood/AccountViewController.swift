//
//  AccountViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/2/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class AccountViewController: UIViewController  {


    
    @IBOutlet weak var fhooderSwitch: UISwitch!
    @IBOutlet weak var joinWindow: UIView!
    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet var fhoodiePic: UIImageView!
    @IBOutlet var fhoodiePicBG: UIImageView!
    @IBOutlet var fhoodieName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reload data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadInfo:",name:"loadSettings", object: nil)
        
        loadPicAndName()
                
        // Connect to switch function
        self.fhooderSwitch.addTarget(self, action: "toggleSwitch:", forControlEvents: UIControlEvents.ValueChanged)
    
        // Make join window and sign up button round
        self.joinWindow.layer.cornerRadius = 5
        self.signUpButton.layer.cornerRadius = 5
    }
    
    
    // Reload Picture and name to reload from other controllers
    func loadInfo(notification: NSNotification){
        loadPicAndName()
    }

    // Loading piture and name funciton
    func loadPicAndName() {
        
        // Get first name from Parse
        if PFUser.currentUser()?.objectForKey("firstName") != nil {
            self.fhoodieName.text = "\(PFUser.currentUser()!.objectForKey("firstName")!)"
        }
        else{
            self.fhoodieName.text = PFUser.currentUser()?.username
        }
        if PFUser.currentUser()?.objectForKey("profilePhoto") != nil {
            let userImageFile = PFUser.currentUser()!["profilePhoto"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.fhoodiePic.image = UIImage(data:imageData)
                        self.fhoodiePicBG.image = UIImage(data: imageData)
                        
                        let image = UIImageView(image: self.fhoodiePic.image)
                        self.fhoodiePic.image = nil
                        image.frame = CGRectMake(0, 0, 80, 80)
                        image.layer.masksToBounds = false
                        image.layer.cornerRadius = 13
                        image.layer.cornerRadius = image.frame.size.height/2
                        image.clipsToBounds = true
                        self.fhoodiePic.addSubview(image)
                        
                        // Back ground styling
                        let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
                        let blurView = UIVisualEffectView(effect: lightBlur)
                        blurView.frame = self.view.bounds
                        self.fhoodiePicBG.addSubview(blurView)
                        
                    }
                }
            }
        }
        // Get picture from Facebook(Parse)
        else {
            if PFUser.currentUser()?.objectForKey("pictureUrl") != nil {
                if let picURL = NSURL(string: "\(PFUser.currentUser()!.objectForKey("pictureUrl")!)") {
                    if let data = NSData(contentsOfURL: picURL) {
                        self.fhoodiePic.image = UIImage(data: data)
                        self.fhoodiePicBG.image = UIImage(data: data)
                        
                        // Profile pic becomes round with white border
                        let image = UIImageView(image: self.fhoodiePic.image)
                        self.fhoodiePic.image = nil // Get rid of the duplicate
                        image.frame = CGRectMake(0, 0, 80, 80)
                        image.layer.masksToBounds = false
                        image.layer.cornerRadius = 13
                        image.layer.cornerRadius = image.frame.size.height/2
                        image.clipsToBounds = true
                        self.fhoodiePic.addSubview(image)
                        
                        // Back ground styling
                        let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
                        let blurView = UIVisualEffectView(effect: lightBlur)
                        blurView.frame = self.view.bounds
                        self.fhoodiePicBG.addSubview(blurView)
                    }
                }
            }
        }
    }

    
    @IBAction func logOutButton(sender: AnyObject) {
        
        let alert = UIAlertController(title: "", message:"Are you sure you want to log out?", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { _ in}
        let logout = UIAlertAction(title: "Log out", style: .Default) { (action: UIAlertAction!) -> () in
            PFUser.logOutInBackgroundWithBlock { error in
                Router.route(animated: true)
            }
        }
        alert.addAction(cancel)
        alert.addAction(logout)
        self.presentViewController(alert, animated: true){}
        
    }
    

    func toggleSwitch(sender: UISwitch) {
        UIView.animate(withDuration: 0.5) {
            self.joinWindow.alpha = self.joinWindow.alpha == 0 ? 1 : 0
        }
    }
}
