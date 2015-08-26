//
//  FilterMenu.swift
//  Fhood
//
//  Created by Teodor Patras on 6/29/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

class FilterMenu: UIView {

    
    // MARK:- Properties -
    
    private var mainButtons : [UIButton] = [UIButton]()
    private let sections : [FilterMenuSectionInfo]
    
    private weak var navController : UINavigationController?
    private weak var delegate : FilterMenuDelegate?
    
    private var subMenuView : UIView?
    
    private var activeSubMenu : Int = -1
    
    // MARK:- Constants -
    
    private let buttonHeight : CGFloat = 35
    private let buttonSidePadding : CGFloat = 0.5
    
    // MARK:- Initializer -
    
    init (navigationController : UINavigationController, sections : [FilterMenuSectionInfo], delegate: FilterMenuDelegate) {
        navController = navigationController
        self.sections = sections
        self.delegate = delegate
        super.init(frame: navigationController.view.bounds)
        self.configureView()
        self.hidden = true
        navigationController.view.insertSubview(self, belowSubview: navigationController.navigationBar)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    // MARK:- Public methods -
    
    func show () {
        self.hidden = false
        self.setMainButtonsHidden(false, completion: nil)
    }
    
    func hide () {
        if self.activeSubMenu > 0 {
            self.hideActiveSubmenuView { () -> () in
                self.setMainButtonsHidden(true, completion: { () -> () in
                    self.hidden = true
                })
            }
        } else {
            self.setMainButtonsHidden(true, completion: { () -> () in
                self.hidden = true
            })
        }
    }
    
    
    // MARK:- Callbacks -
    
    func triggerSubMenu(sender : UIButton)
    {
        if subMenuView?.tag == sender.tag {
            
            self.hideActiveSubmenuView(nil)
            return
        }
        
        let block : (()->()) = {
            self.subMenuView = self.submenuViewForSectionButton(sender)
            self.insertSubview(self.subMenuView!, belowSubview: sender)
            let frame = self.subMenuView?.frame
            var startFrame = frame
            startFrame!.origin.y = frame!.origin.y - (frame!.size.height + CGRectGetHeight(sender.frame))
            
            self.subMenuView?.alpha = 1
            self.subMenuView?.frame = startFrame!
            
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.subMenuView!.frame = frame!
            })
            self.activeSubMenu = sender.tag
        }
        
        if let _ = self.subMenuView
        {
            self.hideActiveSubmenuView(block)
        } else {
            block()
        }
    }
    
    func submenuItemAction(sender : UIButton)
    {
        self.delegate?.filterMenuViewDidSelect(activeSubMenu, subMenu: sender.tag)
        self.hideActiveSubmenuView(nil)
    }
    
    // MARK:- Private methods -

    private func hideActiveSubmenuView(completion : (()->())?)
    {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.subMenuView?.alpha = 0
            }, completion: { (finished) -> Void in
                self.subMenuView?.removeFromSuperview()
                self.subMenuView = nil
                self.activeSubMenu = -1
                
                completion?()
        })
    }
    
    func submenuViewForSectionButton(button : UIButton) -> UIView
    {
        let info = self.sections[button.tag - 1]
        
        let view = UIView (frame: CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame), button.frame.size.width, button.frame.size.height * CGFloat(info.itemTitles.count)))
        view.alpha = 0
        view.tag = button.tag
        view.backgroundColor = UIColor(hue:0, saturation:0, brightness:0.11, alpha:0.7)
        
        var btn : UIButton
        var yOrigin : CGFloat = 0
        
        for i in 1...info.itemTitles.count
        {
            btn = UIButton(frame: CGRectMake(0, yOrigin, CGRectGetWidth(button.frame), CGRectGetHeight(button.frame)))
            btn.titleLabel?.textColor = UIColor.whiteColor()
            btn.titleLabel?.font = UIFont.systemFontOfSize(11)
            btn.setTitle(info.itemTitles[i - 1], forState: .Normal)
            
            view.addSubview(btn)
            yOrigin += CGRectGetHeight(button.frame)
            
            btn.tag = i
            btn.addTarget(self, action: "submenuItemAction:", forControlEvents: .TouchUpInside)
            
        }
        
        return view
    }
    
    private func setMainButtonsHidden (hidden : Bool, completion :(()->())?)
    {
        var frame : CGRect
        
        if !hidden {
            for button in self.mainButtons
            {
                frame = button.frame
                frame.origin.y -= frame.size.height
                button.alpha = 1
                button.frame = frame
            }
        }
        
        
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            for button in self.mainButtons
            {
                var frame = button.frame
                
                if hidden {
                    frame.origin.y = frame.origin.y - CGRectGetHeight(button.frame)
                } else {
                    frame.origin.y = 64
                }
                button.frame = frame
                button.enabled = !hidden
            }
            
            }) { (finished) -> Void in
                completion?()
        }
    }
    
    // MARK:- Configurations -
    
    private func configureView ()
    {
        var button : UIButton
        let buttonWidth = (CGRectGetWidth(self.frame) - CGFloat(self.sections.count + 1) * buttonSidePadding) / CGFloat(self.sections.count)
        let yOrigin = CGRectGetHeight(self.navController!.navigationBar.frame) + CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
        var origin = buttonSidePadding
        
        
        for i in 1...self.sections.count
        {
            button = UIButton (frame: CGRectMake(origin, yOrigin, buttonWidth, buttonHeight))
            button.backgroundColor = UIColor.darkGrayColor()
            button.alpha = 1
            button.titleLabel?.textColor = UIColor.whiteColor()
            button.titleLabel?.font = UIFont.systemFontOfSize(13)
            
            if i == 1 {
                button.setTitle("Price", forState: .Normal)
            }
            else if i == 2 {
                button.setTitle("Rating", forState: .Normal)
            }
            else if i == 3 {
                button.setTitle("Time", forState: .Normal)
            }
            else  {
                button.setTitle("Type", forState: .Normal)
            }

            
            button.addTarget(self, action: "triggerSubMenu:", forControlEvents: .TouchUpInside)
            button.tag = i
            
            button.alpha = 0
            button.enabled = false
            
            self.addSubview(button)
            origin += buttonWidth + buttonSidePadding
            
            self.mainButtons.append(button)
        }
    }
}

class FilterMenuSectionInfo {
    private let itemTitles : [String]
    
    init (titles: [String]) {
        itemTitles = titles
    }
}

@objc protocol FilterMenuDelegate {
    func filterMenuViewDidSelect(section: Int, subMenu: Int)
}