//
//  RateViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/16/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

final class RateViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var spoonOne: UIButton!
    @IBOutlet weak var spoonTwo: UIButton!
    @IBOutlet weak var spoonThree: UIButton!
    @IBOutlet weak var spoonFour: UIButton!
    @IBOutlet weak var spoonFive: UIButton!
    
    let goodSpoon = UIImage(named: "goodSpoon")
    let badSpoon = UIImage(named: "badSpoon")
    
    @IBOutlet weak var thanks: UILabel!
    @IBOutlet weak var fhooderImage: UIImageView!
    @IBOutlet weak var fhooderName: UILabel!
    
    @IBOutlet weak var commentBox: UITextView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tellCommentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blackBorder : UIColor = UIColor.black
        self.commentBox.delegate = self
        self.commentBox.layer.borderWidth = 1
        self.commentBox.layer.borderColor = blackBorder.cgColor
        
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(RateViewController.dismissKeyboard))
        
        swipe.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipe)
    
        
        self.spoonOne.addTarget(self, action: #selector(RateViewController.onePressed(_:)), for: UIControlEvents.touchUpInside)
        self.spoonTwo.addTarget(self, action: #selector(RateViewController.twoPressed(_:)), for: UIControlEvents.touchUpInside)
        self.spoonThree.addTarget(self, action: #selector(RateViewController.threePressed(_:)), for: UIControlEvents.touchUpInside)
        self.spoonFour.addTarget(self, action: #selector(RateViewController.fourPressed(_:)), for: UIControlEvents.touchUpInside)
        self.spoonFive.addTarget(self, action: #selector(RateViewController.fivePressed(_:)), for: UIControlEvents.touchUpInside)
        
        
        fhooderImage.image = Fhooder.itemPics![0]
        let image = UIImageView(image: self.fhooderImage.image)
        self.fhooderImage.image = nil 
        image.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        image.layer.masksToBounds = false
        image.layer.cornerRadius = 13
        image.layer.cornerRadius = image.frame.size.height/2
        image.clipsToBounds = true
        self.fhooderImage.addSubview(image)
        
        self.fhooderName.text = Fhooder.shopName!
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomConstraint.constant = 250
            self.tellCommentLabel.textColor = UIColor.white
            self.commentBox.textColor = UIColor.black
            self.commentBox.backgroundColor = UIColor.white
            self.thanks.alpha = 0
            self.fhooderImage.alpha = 0
            self.fhooderName.alpha = 0
            self.view.backgroundColor = UIColor.darkGray
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        self.dismissKeyboard()
    }

    // called when 'return' key pressed. return NO to ignore.
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        self.dismissKeyboard()
        textView.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        self.view.layoutIfNeeded()
        self.commentBox.resignFirstResponder()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomConstraint.constant = 40
            self.tellCommentLabel.textColor = UIColor.darkGray
            self.commentBox.textColor = UIColor.black
            self.thanks.alpha = 1
            self.fhooderImage.alpha = 1
            self.fhooderName.alpha = 1
            self.view.backgroundColor = UIColor.white
        }, completion: nil)
    }

    @objc func onePressed (_ sender: UIButton!) {
        self.spoonOne.setImage(goodSpoon, for: UIControlState())
        self.spoonTwo.setImage(badSpoon, for: UIControlState())
        self.spoonThree.setImage(badSpoon, for: UIControlState())
        self.spoonFour.setImage(badSpoon, for: UIControlState())
        self.spoonFive.setImage(badSpoon, for: UIControlState())
    }
    
    @objc func twoPressed (_ sender: UIButton) {
        self.spoonOne.setImage(goodSpoon, for: UIControlState())
        self.spoonTwo.setImage(goodSpoon, for: UIControlState())
        self.spoonThree.setImage(badSpoon, for: UIControlState())
        self.spoonFour.setImage(badSpoon, for: UIControlState())
        self.spoonFive.setImage(badSpoon, for: UIControlState())
    }
    
    @objc func threePressed (_ sender: UIButton) {
        self.spoonOne.setImage(goodSpoon, for: UIControlState())
        self.spoonTwo.setImage(goodSpoon, for: UIControlState())
        self.spoonThree.setImage(goodSpoon, for: UIControlState())
        self.spoonFour.setImage(badSpoon, for: UIControlState())
        self.spoonFive.setImage(badSpoon, for: UIControlState())
    }
    
    @objc func fourPressed (_ sender: UIButton) {
        self.spoonOne.setImage(goodSpoon, for: UIControlState())
        self.spoonTwo.setImage(goodSpoon, for: UIControlState())
        self.spoonThree.setImage(goodSpoon, for: UIControlState())
        self.spoonFour.setImage(goodSpoon, for: UIControlState())
        self.spoonFive.setImage(badSpoon, for: UIControlState())
    }
    
    @objc func fivePressed (_ sender: UIButton) {
        self.spoonOne.setImage(goodSpoon, for: UIControlState())
        self.spoonTwo.setImage(goodSpoon, for: UIControlState())
        self.spoonThree.setImage(goodSpoon, for: UIControlState())
        self.spoonFour.setImage(goodSpoon, for: UIControlState())
        self.spoonFive.setImage(goodSpoon, for: UIControlState())
    }
}
