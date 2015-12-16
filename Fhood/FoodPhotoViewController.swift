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
    
    
    // Crops image to square
    func cropToSquare(image: UIImage) -> UIImage {
        var positionX: CGFloat = 0.0
        var positionY: CGFloat = 0.0
        var width: CGFloat = image.size.width
        var height: CGFloat = image.size.height
        
        if width > height {
            //Landscape
            positionX = -((height - width) / 2.0)
            width = height
        }
        else if width < height {
            //Portrait
            positionY = ((height - width) / 2.0)
            height = width
        }
        else{
            //Already Square
        }
        
        let cropSquare = CGRectMake(positionX, positionY, width, height)
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare)
        return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
    }
    
    @IBAction func photoSaveButton(sender: UIBarButtonItem) {
        
        if self.imageView.image != nil {
            self.imageView.image = self.cropToSquare(self.imageView.image!)
            let imageData = imageView.image!.lowestQualityJPEGNSData
            Fhooder.itemPic = UIImage(data: imageData)

            NSNotificationCenter.defaultCenter().postNotificationName("loadInfoView", object: nil)
            
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

