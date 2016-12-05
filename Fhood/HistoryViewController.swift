//
//  HistoryViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 6/8/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

final class HistoryViewController: UIViewController {

    @IBOutlet weak var fhooderImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]
        
        self.title = "History"
        
        let imageData = UIImage(named: "cutoBento")
        let image = UIImageView(image: imageData)
        image.frame = CGRectMake(0, 0, 50, 50)
        image.layer.masksToBounds = false
        image.layer.cornerRadius = 13
        image.layer.cornerRadius = image.frame.size.height/2
        image.clipsToBounds = true
        self.fhooderImage.addSubview(image)
        
    }
    
    
    
    
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
