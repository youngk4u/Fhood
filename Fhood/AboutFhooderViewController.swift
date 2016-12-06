//
//  AboutFhooderViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 12/16/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

class AboutFhooderViewController: UIViewController {

    @IBOutlet var fhooderPic: UIImageView!
    @IBOutlet var aboutMeText: UITextView!
    @IBOutlet var fhooderName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "About me"
        
        let image = UIImageView(image: Fhooder.fhooderPicture)
        image.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        image.layer.masksToBounds = false
        image.layer.cornerRadius = 13
        image.layer.cornerRadius = image.frame.size.height/2
        image.clipsToBounds = true
        
        self.fhooderPic.addSubview(image)
        self.aboutMeText.text = Fhooder.fhooderAboutMe
        self.fhooderName.text = Fhooder.fhooderFirstName
    }
    

}
