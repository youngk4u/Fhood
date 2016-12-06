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

    fileprivate var mainButtons = [UIButton]()
    fileprivate let sections: [FilterMenuSectionInfo]
    
    fileprivate weak var navController: UINavigationController?
    fileprivate weak var delegate: FilterMenuDelegate?
    
    fileprivate var subMenuView: UIView?
    fileprivate var activeSubMenu = -1

    init(navigationController: UINavigationController, sections: [FilterMenuSectionInfo], delegate: FilterMenuDelegate) {
        self.navController = navigationController
        self.sections = sections
        self.delegate = delegate

        super.init(frame: navigationController.view.bounds)

        self.configureView()
        self.isHidden = true
        navigationController.view.insertSubview(self, belowSubview: navigationController.navigationBar)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    func show() {
        self.isHidden = false
        self.setMainButtonsHidden(false, completion: nil)
    }
    
    func hide() {
        if self.activeSubMenu > 0 {
            self.hideActiveSubmenuView {
                self.setMainButtonsHidden(true) {
                    self.isHidden = true
                }
            }
        } else {
            self.setMainButtonsHidden(true) {
                self.isHidden = true
            }
        }
    }

    func triggerSubMenu(_ sender: UIButton) {
        if subMenuView?.tag == sender.tag {
            self.hideActiveSubmenuView()
            return
        }
        
        let block: (() -> Void) = {
            self.subMenuView = self.submenuViewForSectionButton(sender)
            self.insertSubview(self.subMenuView!, belowSubview: sender)
            let frame = self.subMenuView?.frame
            var startFrame = frame
            startFrame!.origin.y = frame!.origin.y - (frame!.size.height + sender.frame.height)

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
    
    func submenuItemAction(_ sender: UIButton) {
        self.delegate?.filterMenuViewDidSelect(activeSubMenu, subMenu: sender.tag)
        self.hideActiveSubmenuView()
    }
    
    // MARK: - Private methods

    fileprivate func hideActiveSubmenuView(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.subMenuView?.alpha = 0
        }, completion: { finished in
            self.subMenuView?.removeFromSuperview()
            self.subMenuView = nil
            self.activeSubMenu = -1
            completion?()
        })
    }
    
    func submenuViewForSectionButton(_ button: UIButton) -> UIView {
        let info = self.sections[button.tag - 1]
        
        let view = UIView(frame: CGRect(x: button.frame.origin.x, y: button.frame.maxY, width: button.frame.size.width, height: button.frame.size.height * CGFloat(info.itemTitles.count)))
        view.alpha = 0
        view.tag = button.tag
        view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.11, alpha: 0.7)
        
        var btn : UIButton
        var yOrigin : CGFloat = 0
        
        for i in 1...info.itemTitles.count {
            btn = UIButton(frame: CGRect(x: 0, y: yOrigin, width: button.frame.width, height: button.frame.height))
            btn.titleLabel?.textColor = UIColor.white
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            btn.setTitle(info.itemTitles[i - 1], for: UIControlState())

            view.addSubview(btn)
            yOrigin += button.frame.height

            btn.tag = i
            btn.addTarget(self, action: #selector(FilterMenu.submenuItemAction(_:)), for: .touchUpInside)
        }

        return view
    }
    
    fileprivate func setMainButtonsHidden(_ hidden: Bool, completion: (() -> Void)?) {
        var frame: CGRect
        
        if !hidden {
            for button in self.mainButtons {
                frame = button.frame
                frame.origin.y -= frame.size.height
                button.alpha = 1
                button.frame = frame
            }
        }

        UIView.animate(withDuration: 0.5, animations: {
            for button in self.mainButtons {
                var frame = button.frame
                frame.origin.y = hidden ? frame.origin.y - button.frame.height : 64
                button.frame = frame
                button.isEnabled = !hidden
            }
        }, completion: { _ in
            completion?()
        }) 
    }
    
    // MARK: - Configurations
    
    fileprivate func configureView() {
        var button: UIButton
        let buttonWidth = (self.frame.width - CGFloat(self.sections.count + 1) * kButtonSidePadding) / CGFloat(self.sections.count)
        let yOrigin = self.navController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        var origin = kButtonSidePadding

        for i in 1...self.sections.count {
            button = UIButton (frame: CGRect(x: origin, y: yOrigin, width: buttonWidth, height: kButtonHeight))
            button.backgroundColor = UIColor.darkGray
            button.alpha = 1
            button.titleLabel?.textColor = UIColor.white
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            
            if i == 1 {
                button.setTitle("Price", for: UIControlState())
            } else if i == 2 {
                button.setTitle("Rating", for: UIControlState())
            } else if i == 3 {
                button.setTitle("Time", for: UIControlState())
            } else {
                button.setTitle("Type", for: UIControlState())
            }

            button.addTarget(self, action: #selector(FilterMenu.triggerSubMenu(_:)), for: .touchUpInside)
            button.tag = i
            button.alpha = 0
            button.isEnabled = false

            self.addSubview(button)
            origin += buttonWidth + kButtonSidePadding

            self.mainButtons.append(button)
        }
    }
}

struct FilterMenuSectionInfo {
    fileprivate let itemTitles: [String]
    
    init(titles: [String]) {
        itemTitles = titles
    }
}

protocol FilterMenuDelegate: class {
    func filterMenuViewDidSelect(_ section: Int, subMenu: Int)
}
