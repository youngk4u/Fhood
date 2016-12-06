//
//  FoodPhotoViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 12/1/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

final class FoodPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveButton.isEnabled = false
        

    }

    @IBAction func cameraButton(_ sender: UIButton) {
        
        // Check if the device has a camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            // Device has a camera, now create the image picker controller
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func libraryButton(_ sender: UIButton) {
        
        // Check if the device has a photo library
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            // Device has a photo library
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // To dismiss the image picker
        self.dismiss(animated: true, completion: nil)
        
        self.imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.imageView.image = cropToSquare(self.imageView.image!)
        self.saveButton.isEnabled = true
        
    }
    
    
    // Crops image to square
    func cropToSquare(_ image: UIImage) -> UIImage {

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
        
        let cropSquare = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let imageRef = image.cgImage!.cropping(to: cropSquare)
        return UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: image.imageOrientation)
    }
    
    @IBAction func photoSaveButton(_ sender: UIBarButtonItem) {
        if self.imageView.image != nil {
            //self.imageView.image = self.cropToSquare(self.imageView.image!)
            let imageData = imageView.image!.lowestQualityJPEGNSData
            Fhooder.itemPic = UIImage(data: imageData as Data)

            NotificationCenter.default.post(name: Notification.Name(rawValue: "loadInfoView"), object: nil)
            
            let alert = UIAlertController(title: "", message:"Your new photo has been saved!", preferredStyle: .alert)
            let saved = UIAlertAction(title: "Ok!", style: .default) { _ in}
            alert.addAction(saved)
            rootViewController.present(alert, animated: true, completion: nil)
            
            
            _ = navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func closeView(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    
}

