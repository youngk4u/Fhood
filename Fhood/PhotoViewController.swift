//
//  PhotoViewController.swift
//  Fhood
//
//  Created by YOUNG on 11/22/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit
import Parse

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    let rootViewController: UIViewController = UIApplication.sharedApplication().windows[1].rootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile photo"
        self.saveButton.enabled = false
        
        // Get picture from file(Parse)
        if PFUser.currentUser()?.objectForKey("profilePhoto") != nil {
            let userImageFile = PFUser.currentUser()!["profilePhoto"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.imageView.image = UIImage(data:imageData)
                    }
                }
            }
        }
        else {
            // Get picture from Facebook(Parse)
            if PFUser.currentUser()?.objectForKey("pictureUrl") != nil {
                if let picURL = NSURL(string: "\(PFUser.currentUser()!.objectForKey("pictureUrl")!)") {
                    if let data = NSData(contentsOfURL: picURL) {
                        self.imageView.image = UIImage(data: data)
                        
                    }
                }
            }
        }

    }

    @IBAction func cameraButton(sender: UIButton) {
        
        // Check if the device has a camera
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            // Device has a camera, now create the image picker controller
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func libraryButton(sender: UIButton) {
        
        // Check if the device has a photo library
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            
            // Device has a photo library
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // To dismiss the image picker
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.saveButton.enabled = true
        
    }

    @IBAction func photoSaveButton(sender: UIBarButtonItem) {
        
        if self.imageView.image != nil {
            let imageData = imageView.image!.lowestQualityJPEGNSData
            let imageFile = PFFile(name:"profile.png", data:imageData)
            
            let user = PFUser.currentUser()
            user!["profilePhoto"] = imageFile
            user!.saveInBackground()
            
            NSNotificationCenter.defaultCenter().postNotificationName("loadSettings", object: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("loadProfileViewPic", object: nil)
            
            let alert = UIAlertController(title: "", message:"Your new photo has been saved!", preferredStyle: .Alert)
            let saved = UIAlertAction(title: "Ok!", style: .Default) { _ in}
            alert.addAction(saved)
            rootViewController.presentViewController(alert, animated: true, completion: nil)
            
            
            navigationController?.popViewControllerAnimated(true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}

extension UIImage {
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)! }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)!}
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)! }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)!}
    var lowestQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.0)! }
}
