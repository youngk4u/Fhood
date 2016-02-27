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
    @IBOutlet var signupMessage: UILabel!

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
        
    
        if Fhooder.fhooderSignedIn == true {
            self.fhooderSwitch.on = true
        }
        else {
            self.fhooderSwitch.on = false
        }
        
        
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

    

    
    // Animate join window for toggle switch
    func animate () {
        UIView.animate(withDuration: 0.5) {
            self.joinWindow.alpha = self.joinWindow.alpha == 0 ? 1 : 0
        }
    }
    
    
    func toggleSwitch(sender: UISwitch) {
        
        
        if PFUser.currentUser()?.objectForKey("isFhooder") != nil {
            
            let fhooder = PFUser.currentUser()!.objectForKey("isFhooder")
            
            if self.fhooderSwitch.on == true {
                
                if fhooder != nil {
                    
                    if fhooder as! NSObject == true {
                        Fhooder.fhooderSignedIn = true
                        Router.route(animated: true)
                        
                    }

                    else {
                        animate()
                    }
                    
                }
                else {
                    animate()
                }
            }
            else {
                if fhooder as! NSObject == false {
                    animate()
                }
                else {
                    
                    Fhooder.fhooderSignedIn = false
                    Fhooder.isOpen = false
                    
                    // Turn off the badge notification timer
                    NSNotificationCenter.defaultCenter().postNotificationName("load3", object: nil)
                    
                    
                    let query = PFQuery(className: "Fhooder")
                    query.getObjectInBackgroundWithId(Fhooder.objectID!) { (fhooder: PFObject?, error: NSError?) -> Void in
                        if error == nil && fhooder != nil {
                            
                            fhooder!["isOpen"] = Fhooder.isOpen
                            fhooder?.saveInBackground()
                            
                        }
                        
                        
                    }
                    Router.route(animated: true)
                }
            }
        }
        else {
            if PFUser.currentUser()?.objectForKey("applied") != nil {
                let didApplied = PFUser.currentUser()!.objectForKey("applied") as! Bool
                if didApplied {
                    self.signUpButton.hidden = true
                    self.signupMessage.text = "You've already submitted your application. One of our representatives will contact you shortly!"
                }
            }
            else {
                self.signUpButton.hidden = false
            }
            animate()
        }
    }
    
}
