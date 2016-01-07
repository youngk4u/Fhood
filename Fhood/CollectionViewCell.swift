//
//  CollectionViewCell.swift
//  Fhoode
//
//  Created by Young-hu Kim on 6/21/15.
//  Copyright (c) 2015 Fhood LLC. All rights reserved.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var fhoodImage: UIImageView!
    
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPrice: UILabel!

    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var foodQuantity: UILabel!
    
    @IBOutlet var soldOutLabel: UILabel!
    
}
