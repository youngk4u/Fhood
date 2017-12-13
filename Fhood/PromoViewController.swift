//
//  PromoViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 11/16/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

final class PromoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.black,NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "HelveticaNeue-Light", size: 20)!]

        self.title = "Promotions"
       
        self.textField.delegate = self
        
    }

    @IBAction func closePromo(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
