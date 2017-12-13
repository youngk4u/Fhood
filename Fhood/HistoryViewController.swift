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
        
        nav?.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.black,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "HelveticaNeue-Light", size: 20)!]
        
        self.title = "History"
        
        let imageData = UIImage(named: "cutoBento")
        let image = UIImageView(image: imageData)
        image.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        image.layer.masksToBounds = false
        image.layer.cornerRadius = 13
        image.layer.cornerRadius = image.frame.size.height/2
        image.clipsToBounds = true
        self.fhooderImage.addSubview(image)
        
    }
    
    
    
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
