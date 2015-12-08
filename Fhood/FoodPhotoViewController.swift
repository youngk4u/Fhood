//
//  FoodPhotoViewController.swift
//  Fhood
//
//  Created by YOUNG on 12/1/15.
//  Copyright © 2015 YOUNG&YOUM. All rights reserved.
//

import UIKit

final class FoodPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    let rootViewController: UIViewController = UIApplication.sharedApplication().windows[1].rootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveButton.enabled = false
        

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
//            let imageData = imageView.image!.lowestQualityJPEGNSData
//
//            let imageFile = PFFile(name:"profile.png", data:imageData)
//            
//            let user = PFUser.currentUser()
//            user!["profilePhoto"] = imageFile
//            user!.saveInBackground()
//            
//            NSNotificationCenter.defaultCenter().postNotificationName("loadProfileViewPic", object: nil)
            
            let alert = UIAlertController(title: "", message:"Your new photo has been saved!", preferredStyle: .Alert)
            let saved = UIAlertAction(title: "Ok!", style: .Default) { _ in}
            alert.addAction(saved)
            rootViewController.presentViewController(alert, animated: true, completion: nil)
            
            
            navigationController?.popViewControllerAnimated(true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    @IBAction func closeView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
}

