//
//  ListViewController.swift
//  Fhood
//
//  Created by Young-hu Kim on 5/17/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController, UISearchBarDelegate, FilterMenuDelegate, UITableViewDelegate, UITableViewDataSource {

    // Put Fhooder lists in array
    private let array : [String] = ["", "", "", "", "", "", "", "", "", ""]
    private let searchBars = UISearchBar()
    private let formatter = NSNumberFormatter()

    @IBOutlet private var TableView: UITableView!

    private var filterMenu: FilterMenu?
    private var filterShown = false
    
    private var selectedRow = -1
    
    private var arrPrice = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Custom Back button -> Cancel button
        let backItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        // Search Bar
        self.searchBars.delegate = self
        let navBarButton = UIBarButtonItem(customView: searchBars)
        self.navigationItem.titleView = navBarButton.customView
        self.searchBars.placeholder = "Sandwich"
        
        // Search Bar with no rim
        UISearchBar.appearance().backgroundImage = UIImage(named: "")

        // Configure reveal for this view
        let revealController = self.revealViewController()
        revealController.panGestureRecognizer()
        revealController.tapGestureRecognizer()

        // Account Icon
        let accountIcon = UIImage(named: "userCircle2")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: accountIcon, style: UIBarButtonItemStyle.Plain,
            target: revealController, action: "revealToggle:")

        // Filter Icon
        let filterIcon = UIImage(named: "Filter 2")
        let rightBarButton = UIBarButtonItem(image: filterIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "filterAction:")
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // Swipe to left only
        let swipeLeft = UISwipeGestureRecognizer(target: self.revealViewController(), action: "revealToggle:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

        self.TableView.delegate = self
        self.TableView.dataSource = self
        self.TableView.layoutMargins = UIEdgeInsetsZero

        // Currency formatter
        self.formatter.numberStyle = .CurrencyStyle
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func filterAction(sender: AnyObject) {
        if filterMenu == nil {
            let sections = [
                FilterMenuSectionInfo(titles: ["Less than $5", "$5 ~ $10", "More than $10"]),
                FilterMenuSectionInfo(titles: ["Highest rated", "Most reviewed"]),
                FilterMenuSectionInfo(titles: ["Open now", "Reserve"]),
                FilterMenuSectionInfo(titles: ["Pick up", "Eat in", "Delivery"])
            ]
            
            filterMenu = FilterMenu(navigationController: self.navigationController!, sections: sections, delegate: self)
        }
        
        if filterShown {
            filterMenu?.hide()
        } else {
            filterMenu?.show()
        }
        
        filterShown = !filterShown
    }
    
    func filterMenuViewDidSelect(section: Int, subMenu: Int) {
        print("Did select: \nsection: \(section)\nsubMenu:\(subMenu)")

        if (section == 1 && subMenu == 1) {
            
        } else if (section == 1 && subMenu == 2) {
            
        }
    }

    // Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Try to get a cell to reuse
        let cell = tableView.dequeueReusableCellWithIdentifier("Tablecell") as! ListTableViewCell

        // Customize cell
        for (var i = 0; i < self.array.count; i++) {
            if indexPath.row == 0 {
                fhooderOne()
            }
            else if indexPath.row == 1 {
                fhooderTwo()
            }
            else if indexPath.row == 2 {
                fhooderThree()
            }
            else if indexPath.row == 3 {
                fhooderFour()
            }
            else if indexPath.row == 4 {
                fhooderFive()
            }
            else if indexPath.row == 5 {
                fhooderSix()
            }
            else if indexPath.row == 6 {
                fhooderSeven()
            }
            else if indexPath.row == 7 {
                fhooderEight()
            }
            else if indexPath.row == 8 {
                fhooderNine()
            }
            else if indexPath.row == 9 {
                fhooderTen()
            }
            
            self.arrPrice = variables.itemPrices!

            cell.fhooderPic.image = UIImage(named: variables.fhooderPic!)
            cell.fhooderPrice.text = formatter.stringFromNumber(arrPrice[0])
            cell.fhooderName.text = variables.name!
            cell.fhooderSpoon.image = UIImage(named: variables.ratingInString!)
            cell.fhooderReview.text = "\(variables.reviews!) Reviews"
            cell.fhooderPickup.hidden = !variables.pickup!
            cell.fhooderEatin.hidden = !variables.eatin!
            cell.fhooderDelivery.hidden = !variables.delivery!
            cell.fhooderType.text = "\(variables.foodType![0]), \(variables.foodType![1]), \(variables.foodType![2])"
            cell.fhooderOpen.hidden = !variables.isOpen!
            cell.fhooderClosed.hidden = !variables.isClosed!
            cell.fhooderDistance.text = "\(variables.distance!) miles"
        }
        
        // Cell Marginal lines on the left to stretch all the way to the left screen
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedRow = indexPath.row
        
        if self.selectedRow == 0 {
            fhooderOne()
        }
        else if self.selectedRow == 1 {
            fhooderTwo()
        }
        else if self.selectedRow == 2 {
            fhooderThree()
        }
        else if self.selectedRow == 3 {
            fhooderFour()
        }
        else if self.selectedRow == 4 {
            fhooderFive()
        }
        else if self.selectedRow == 5 {
            fhooderSix()
        }
        else if self.selectedRow == 6 {
            fhooderSeven()
        }
        else if self.selectedRow == 7 {
            fhooderEight()
        }
        else if self.selectedRow == 8 {
            fhooderNine()
        }
        else if self.selectedRow == 9 {
            fhooderTen()
        }

        TableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
