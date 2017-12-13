//
//  AccountViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/2/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
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
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.loadInfo(_:)),name:NSNotification.Name(rawValue: "loadSettings"), object: nil)
        
        loadPicAndName()
                
        // Connect to switch function
        self.fhooderSwitch.addTarget(self, action: #selector(AccountViewController.toggleSwitch(_:)), for: UIControlEvents.valueChanged)
    
        // Make join window and sign up button round
        self.joinWindow.layer.cornerRadius = 5
        self.signUpButton.layer.cornerRadius = 5
        
    
        if Fhooder.fhooderSignedIn == true {
            self.fhooderSwitch.isOn = true
        }
        else {
            self.fhooderSwitch.isOn = false
        }
        
        
    }
    
    
    
    // Reload Picture and name to reload from other controllers
    @objc func loadInfo(_ notification: Notification){
        loadPicAndName()
    }

    // Loading piture and name funciton
    func loadPicAndName() {
        
        // Get first name from Parse
        if PFUser.current()?.object(forKey: "firstName") != nil {
            self.fhoodieName.text = "\(PFUser.current()!.object(forKey: "firstName")!)"
        }
        else{
            self.fhoodieName.text = PFUser.current()?.username
        }
        if PFUser.current()?.object(forKey: "profilePhoto") != nil {
            let userImageFile = PFUser.current()!["profilePhoto"] as! PFFile
            userImageFile.getDataInBackground {
                (imageData: Data?, error: Error?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        
                        self.fhoodiePic.image = UIImage(data:imageData)
                        self.fhoodiePicBG.image = UIImage(data: imageData)
                        
                        let image = UIImageView(image: self.fhoodiePic.image)
                        self.fhoodiePic.image = nil
                        image.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                        image.layer.masksToBounds = false
                        image.layer.cornerRadius = 13
                        image.layer.cornerRadius = image.frame.size.height/2
                        image.clipsToBounds = true
                        self.fhoodiePic.addSubview(image)
                        
                        // Back ground styling
                        let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
                        let blurView = UIVisualEffectView(effect: lightBlur)
                        blurView.frame = self.view.bounds
                        self.fhoodiePicBG.addSubview(blurView)
                        
                    }
                }
            }
        }
        // Get picture from Facebook(Parse)
        else {
            if PFUser.current()?.object(forKey: "pictureUrl") != nil {
                if let picURL = URL(string: "\(PFUser.current()!.object(forKey: "pictureUrl")!)") {
                    if let data = try? Data(contentsOf: picURL) {
                        self.fhoodiePic.image = UIImage(data: data)
                        self.fhoodiePicBG.image = UIImage(data: data)
                        
                        // Profile pic becomes round with white border
                        let image = UIImageView(image: self.fhoodiePic.image)
                        self.fhoodiePic.image = nil // Get rid of the duplicate
                        image.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                        image.layer.masksToBounds = false
                        image.layer.cornerRadius = 13
                        image.layer.cornerRadius = image.frame.size.height/2
                        image.clipsToBounds = true
                        self.fhoodiePic.addSubview(image)
                        
                        // Back ground styling
                        let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
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
        UIView.animate(withDuration: 0.5, animations: {
            self.joinWindow.alpha = self.joinWindow.alpha == 0 ? 1 : 0
        }, completion: nil)
    }
    
    
    @objc func toggleSwitch(_ sender: UISwitch) {
        
        
        if PFUser.current()?.object(forKey: "isFhooder") != nil {
            let fhooder = PFUser.current()!.object(forKey: "isFhooder")

            if self.fhooderSwitch.isOn == true {
                if fhooder != nil {
                    if fhooder as! Bool == true {
                        Fhooder.fhooderSignedIn = true
                        Router.route(true)
                    } else {
                        animate()
                    }
                } else {
                    animate()
                }
            } else {
                if fhooder as! Bool == false {
                    animate()
                } else {
                    if Fhooder.isOpen == true {
                        let alert = UIAlertController(title: "Wait", message: "You have to close the shop before you shop!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.fhooderSwitch.isOn = true
                    } else {
                        Fhooder.fhooderSignedIn = false
                        let query = PFQuery(className: "Fhooder")
                        query.getObjectInBackground(withId: Fhooder.objectID!) { (fhooder: PFObject?, error: Error?) -> Void in
                            if error == nil && fhooder != nil {
                                fhooder!["isOpen"] = Fhooder.isOpen
                                fhooder?.saveInBackground()
                            }
                        }
                    Router.route(true)
                    }
                }
            }
        }
        else {
            if PFUser.current()?.object(forKey: "applied") != nil {
                let didApplied = PFUser.current()!.object(forKey: "applied") as! Bool
                if didApplied {
                    self.signUpButton.isHidden = true
                    self.signupMessage.text = "You've already submitted your application. One of our representatives will contact you shortly!"
                }
            } else {
                self.signUpButton.isHidden = false
            }
            animate()
        }
    }
    
}
