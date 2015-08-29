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
    
    
    @IBOutlet weak var fhooderImage: UIImageView!
    @IBOutlet weak var fhooderName: UILabel!
    
    @IBOutlet weak var commentBox: UITextView!
    //@IBOutlet weak var commentBox: UITextField! = nil
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var tellCommentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blackBorder : UIColor = UIColor.blackColor()
        self.commentBox.delegate = self
        self.commentBox.layer.borderWidth = 1
        self.commentBox.layer.borderColor = blackBorder.CGColor
        
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipe)
    
        
        self.spoonOne.addTarget(self, action: "onePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.spoonTwo.addTarget(self, action: "twoPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.spoonThree.addTarget(self, action: "threePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.spoonFour.addTarget(self, action: "fourPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.spoonFive.addTarget(self, action: "fivePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        self.fhooderImage.image = UIImage(named: variables.fhooderPic!)
        self.fhooderName.text = variables.name!
        
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.bottomConstraint.constant = 320
            self.tellCommentLabel.textColor = UIColor.whiteColor()
            self.commentBox.textColor = UIColor.blackColor()
            self.commentBox.backgroundColor = UIColor.whiteColor()
            self.dimView.alpha = 0.8
            self.view.layoutIfNeeded()
        })
    }


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
            self.bottomConstraint.constant = 60
            self.tellCommentLabel.textColor = UIColor.darkGrayColor()
            self.commentBox.textColor = UIColor.blackColor()
            self.dimView.alpha = 0
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
