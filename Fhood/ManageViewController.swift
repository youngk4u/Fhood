//
//  ManageViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 8/30/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class ManageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var fhooderTitle: UILabel!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var TableView: UITableView!
    
    
    // CollectionView Right insets for Iphone 6 plus = 195.0, Iphone 6 = 234.0, Iphone 5 = 290
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 234.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Logo
        let logo = UIImage(named: "FhoodLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        // TableView Delegate
        self.TableView.delegate = self
        self.TableView.dataSource = self
        
        self.TableView.layoutMargins = UIEdgeInsetsZero

    }
    

    // CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell", forIndexPath: indexPath) as! ManageCollectionViewCell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ManageCollectionViewCell
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: 150, height: 150)
    }
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    
    // TableView  (iPhone 6 plus: set Width to 414, iPhone 6: 375, iPhone 5/5s: 320)
    func tableView(tableView3: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    
    func tableView(tableView3: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Try to get a cell to reuse
        let cell = TableView.dequeueReusableCellWithIdentifier("Tablecell") as! ManageTableViewCell
        
        // Make the insets to zero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView3: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        TableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


}
