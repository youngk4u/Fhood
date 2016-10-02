//
//  RateViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 7/16/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
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
        
        let blackBorder : UIColor = UIColor.blackColor()
        self.commentBox.delegate = self
        self.commentBox.layer.borderWidth = 1
        self.commentBox.layer.borderColor = blackBorder.CGColor
        
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(RateViewController.dismissKeyboard))
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipe)
    
        
        self.spoonOne.addTarget(self, action: #selector(RateViewController.onePressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.spoonTwo.addTarget(self, action: #selector(RateViewController.twoPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.spoonThree.addTarget(self, action: #selector(RateViewController.threePressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.spoonFour.addTarget(self, action: #selector(RateViewController.fourPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.spoonFive.addTarget(self, action: #selector(RateViewController.fivePressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
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
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.bottomConstraint.constant = 250
            self.tellCommentLabel.textColor = UIColor.whiteColor()
            self.commentBox.textColor = UIColor.blackColor()
            self.commentBox.backgroundColor = UIColor.whiteColor()
            self.thanks.alpha = 0
            self.fhooderImage.alpha = 0
            self.fhooderName.alpha = 0
            self.view.backgroundColor = UIColor.darkGrayColor()
            self.view.layoutIfNeeded()
        })
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)

        self.dismissKeyboard()
    }

    // called when 'return' key pressed. return NO to ignore.
    func textViewShouldReturn(textView: UITextView) -> Bool {
        self.dismissKeyboard()
        textView.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        self.view.layoutIfNeeded()
        self.commentBox.resignFirstResponder()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.bottomConstraint.constant = 40
            self.tellCommentLabel.textColor = UIColor.darkGrayColor()
            self.commentBox.textColor = UIColor.blackColor()
            self.thanks.alpha = 1
            self.fhooderImage.alpha = 1
            self.fhooderName.alpha = 1
            self.view.backgroundColor = UIColor.whiteColor()
        })
    }

    func onePressed (sender: UIButton!) {
        self.spoonOne.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonTwo.setImage(badSpoon, forState: UIControlState.Normal)
        self.spoonThree.setImage(badSpoon, forState: UIControlState.Normal)
        self.spoonFour.setImage(badSpoon, forState: UIControlState.Normal)
        self.spoonFive.setImage(badSpoon, forState: UIControlState.Normal)
    }
    
    func twoPressed (sender: UIButton) {
        self.spoonOne.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonTwo.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonThree.setImage(badSpoon, forState: UIControlState.Normal)
        self.spoonFour.setImage(badSpoon, forState: UIControlState.Normal)
        self.spoonFive.setImage(badSpoon, forState: UIControlState.Normal)
    }
    
    func threePressed (sender: UIButton) {
        self.spoonOne.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonTwo.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonThree.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonFour.setImage(badSpoon, forState: UIControlState.Normal)
        self.spoonFive.setImage(badSpoon, forState: UIControlState.Normal)
    }
    
    func fourPressed (sender: UIButton) {
        self.spoonOne.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonTwo.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonThree.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonFour.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonFive.setImage(badSpoon, forState: UIControlState.Normal)
    }
    
    func fivePressed (sender: UIButton) {
        self.spoonOne.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonTwo.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonThree.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonFour.setImage(goodSpoon, forState: UIControlState.Normal)
        self.spoonFive.setImage(goodSpoon, forState: UIControlState.Normal)
    }
}
