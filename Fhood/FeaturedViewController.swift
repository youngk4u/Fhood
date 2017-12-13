//
//  FeaturedViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 5/18/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import Parse

final class FeaturedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet fileprivate var tableView: UITableView!
    
    var fhooderPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reload Parse data
        NotificationCenter.default.addObserver(self, selector: #selector(FeaturedViewController.getImage(_:)), name: NSNotification.Name(rawValue: "getImage"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "getImage"), object: nil)

        
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layoutMargins = UIEdgeInsets.zero

        // Configure reveal for this view
        let revealController = self.revealViewController()
        _ = revealController?.panGestureRecognizer()
        _ = revealController?.tapGestureRecognizer()

        // Account Icon
        let accountIcon = UIImage(named: "userCircle2")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.plain,
                                                                target: revealController, action: #selector(revealViewController().revealToggle(_:)))
        
        
    }
    
    @objc func getImage(_ notification: Notification) {
        
        let query = PFQuery(className: "Fhooder")
        
        // Featured Fhooder ID
        Fhooder.objectID = "oCWrWgSv4h"
        
        query.getObjectInBackground(withId: Fhooder.objectID!) { (object: PFObject?, error: Error?) -> Void in
            if error == nil && object != nil {
                
                
                Fhooder.shopName = object?.value(forKey: "shopName") as? String
                Fhooder.foodTypeOne = object?.value(forKey: "foodTypeOne") as? String
                Fhooder.rating = object?.value(forKey: "ratings") as? Double
                Fhooder.ratingInString = String(Fhooder.rating!)
                Fhooder.reviews = object?.value(forKey: "reviews") as? Int
                
                let pic = object?.value(forKey: "itemPic") as! PFFile
                
                pic.getDataInBackground {
                    (imageData: Data?, error: Error?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            Fhooder.itemPic = UIImage(data:imageData)
                            let image = UIImageView(image: Fhooder.itemPic)
                            image.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
                            image.layer.masksToBounds = false
                            image.layer.cornerRadius = 13
                            image.layer.cornerRadius = image.frame.size.height/2
                            image.clipsToBounds = true
                            
                            self.fhooderPic = image
       
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }

        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "featuredTableCell") as! FeaturedTableViewCell
        
        cell.layoutMargins = UIEdgeInsets.zero
        
        
        cell.featuredName.text = Fhooder.shopName!
        cell.featuredType.text = Fhooder.foodTypeOne!
        cell.featuredSpoon.image = UIImage(named: Fhooder.ratingInString!)
        cell.featuredReviewCount.text = "\(Int(Fhooder.reviews!)) Reviews"
        if self.fhooderPic != nil {
            cell.featuredImage.addSubview(self.fhooderPic)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Fhooder.objectID = "oCWrWgSv4h"
        self.performSegue(withIdentifier: "toFhooderView", sender: tableView)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
