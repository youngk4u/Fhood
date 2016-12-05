//
//  PhotoViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 11/22/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import Foundation
import UIKit
import Parse

final class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    let rootViewController: UIViewController = UIApplication.sharedApplication().windows[0].rootViewController!
    
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
        self.imageView.image = cropToSquare(self.imageView.image!)
        self.saveButton.enabled = true
        
    }
    
    
    // Crops image to square
    func cropToSquare(image: UIImage) -> UIImage {

        var xPosition: CGFloat = 0.0
        var yPosition: CGFloat = 0.0
        var width: CGFloat = image.size.width
        var height: CGFloat = image.size.height
        
        if width > height {
            //Landscape
            xPosition = (width - height) / 2
            width = height
        }
        else if width < height {
            //Portrait
            yPosition = (height - width) / 2
            height = width
        }
        else{
            //Already Square
        }
        
        let cropSquare = CGRectMake(xPosition, yPosition, width, height)
        let imageRef = CGImageCreateWithImageInRect(image.CGImage!, cropSquare)
        return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
    }
    

    @IBAction func photoSaveButton(sender: UIBarButtonItem) {
        
        if self.imageView.image != nil {
            //self.imageView.image = self.cropToSquare(self.imageView.image!)
            let imageData = imageView.image!.lowestQualityJPEGNSData
            let imageFile = PFFile(name:"profile.png", data:imageData)
            
            let user = PFUser.currentUser()
            
            let FhooderBool = user!["isFhooder"] as? Bool
            
            if FhooderBool == true {
                
                let query = PFQuery(className: "Fhooder")
                let ID = Fhooder.objectID
                query.getObjectInBackgroundWithId(ID!) { (fhooder: PFObject?, error: NSError?) -> Void in
                    if error == nil && fhooder != nil {
                        
                        fhooder!["profilePic"] = imageFile! as PFFile
                        fhooder!.saveInBackground()
                    }
                }
                
            }
            
            user!["profilePhoto"] = imageFile
            user!.saveInBackground()
            
            NSNotificationCenter.defaultCenter().postNotificationName("loadSettings", object: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("loadProfileView", object: nil)
            
            let alert = UIAlertController(title: "", message:"Your new photo has been saved!", preferredStyle: .Alert)
            let saved = UIAlertAction(title: "Ok!", style: .Default) { _ in}
            alert.addAction(saved)
            rootViewController.presentViewController(alert, animated: true, completion: nil)
            
            
            navigationController?.popViewControllerAnimated(true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}

