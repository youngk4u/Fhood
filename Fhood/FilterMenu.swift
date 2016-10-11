//
//  FilterMenu.swift
//  Fhood
//
//  Created by Teodor Patras on 6/29/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit

private let kButtonHeight: CGFloat = 35
private let kButtonSidePadding: CGFloat = 0.5

final class FilterMenu: UIView {

    private var mainButtons = [UIButton]()
    private let sections: [FilterMenuSectionInfo]
    
    private weak var navController: UINavigationController?
    private weak var delegate: FilterMenuDelegate?
    
    private var subMenuView: UIView?
    private var activeSubMenu = -1

    init(navigationController: UINavigationController, sections: [FilterMenuSectionInfo], delegate: FilterMenuDelegate) {
        self.navController = navigationController
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

    func show() {
        self.hidden = false
        self.setMainButtonsHidden(false, completion: nil)
    }
    
    func hide() {
        if self.activeSubMenu > 0 {
            self.hideActiveSubmenuView {
                self.setMainButtonsHidden(true) {
                    self.hidden = true
                }
            }
        } else {
            self.setMainButtonsHidden(true) {
                self.hidden = true
            }
        }
    }

    func triggerSubMenu(sender: UIButton) {
        if subMenuView?.tag == sender.tag {
            self.hideActiveSubmenuView()
            return
        }
        
        let block: (() -> Void) = {
            self.subMenuView = self.submenuViewForSectionButton(sender)
            self.insertSubview(self.subMenuView!, belowSubview: sender)
            let frame = self.subMenuView?.frame
            var startFrame = frame
            startFrame!.origin.y = frame!.origin.y - (frame!.size.height + CGRectGetHeight(sender.frame))

            self.subMenuView?.alpha = 1
            self.subMenuView?.frame = startFrame!

            UIView.animate {
                self.subMenuView!.frame = frame!
            }

            self.activeSubMenu = sender.tag
        }
        
        if self.subMenuView != nil {
            self.hideActiveSubmenuView(block)
        } else {
            block()
        }
    }
    
    func submenuItemAction(sender: UIButton) {
        self.delegate?.filterMenuViewDidSelect(activeSubMenu, subMenu: sender.tag)
        self.hideActiveSubmenuView()
    }
    
    // MARK: - Private methods

    private func hideActiveSubmenuView(completion: (() -> Void)? = nil) {
        UIView.animateWithDuration(0.2, animations: {
            self.subMenuView?.alpha = 0
        }, completion: { finished in
            self.subMenuView?.removeFromSuperview()
            self.subMenuView = nil
            self.activeSubMenu = -1
            completion?()
        })
    }
    
    func submenuViewForSectionButton(button: UIButton) -> UIView {
        let info = self.sections[button.tag - 1]
        
        let view = UIView(frame: CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame), button.frame.size.width, button.frame.size.height * CGFloat(info.itemTitles.count)))
        view.alpha = 0
        view.tag = button.tag
        view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.11, alpha: 0.7)
        
        var btn : UIButton
        var yOrigin : CGFloat = 0
        
        for i in 1...info.itemTitles.count {
            btn = UIButton(frame: CGRectMake(0, yOrigin, CGRectGetWidth(button.frame), CGRectGetHeight(button.frame)))
            btn.titleLabel?.textColor = UIColor.whiteColor()
            btn.titleLabel?.font = UIFont.systemFontOfSize(11)
            btn.setTitle(info.itemTitles[i - 1], forState: .Normal)

            view.addSubview(btn)
            yOrigin += CGRectGetHeight(button.frame)

            btn.tag = i
            btn.addTarget(self, action: #selector(FilterMenu.submenuItemAction(_:)), forControlEvents: .TouchUpInside)
        }

        return view
    }
    
    private func setMainButtonsHidden(hidden: Bool, completion: (() -> Void)?) {
        var frame: CGRect
        
        if !hidden {
            for button in self.mainButtons {
                frame = button.frame
                frame.origin.y -= frame.size.height
                button.alpha = 1
                button.frame = frame
            }
        }

        UIView.animateWithDuration(0.5, animations: {
            for button in self.mainButtons {
                var frame = button.frame
                frame.origin.y = hidden ? frame.origin.y - CGRectGetHeight(button.frame) : 64
                button.frame = frame
                button.enabled = !hidden
            }
        }) { _ in
            completion?()
        }
    }
    
    // MARK: - Configurations
    
    private func configureView() {
        var button: UIButton
        let buttonWidth = (CGRectGetWidth(self.frame) - CGFloat(self.sections.count + 1) * kButtonSidePadding) / CGFloat(self.sections.count)
        let yOrigin = CGRectGetHeight(self.navController!.navigationBar.frame) + CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
        var origin = kButtonSidePadding

        for i in 1...self.sections.count {
            button = UIButton (frame: CGRectMake(origin, yOrigin, buttonWidth, kButtonHeight))
            button.backgroundColor = UIColor.darkGrayColor()
            button.alpha = 1
            button.titleLabel?.textColor = UIColor.whiteColor()
            button.titleLabel?.font = UIFont.systemFontOfSize(13)
            
            if i == 1 {
                button.setTitle("Price", forState: .Normal)
            } else if i == 2 {
                button.setTitle("Rating", forState: .Normal)
            } else if i == 3 {
                button.setTitle("Time", forState: .Normal)
            } else {
                button.setTitle("Type", forState: .Normal)
            }

            button.addTarget(self, action: #selector(FilterMenu.triggerSubMenu(_:)), forControlEvents: .TouchUpInside)
            button.tag = i
            button.alpha = 0
            button.enabled = false

            self.addSubview(button)
            origin += buttonWidth + kButtonSidePadding

            self.mainButtons.append(button)
        }
    }
}

struct FilterMenuSectionInfo {
    private let itemTitles: [String]
    
    init(titles: [String]) {
        itemTitles = titles
    }
}

protocol FilterMenuDelegate: class {
    func filterMenuViewDidSelect(section: Int, subMenu: Int)
}
