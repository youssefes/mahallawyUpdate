//
//  addvertismentCCollectionViewCell.swift
//  Mahallawy
//
//  Created by youssef on 4/16/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Cosmos
class addvertismentCCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewOfActiveOrNot: UIView!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var nameOfSubCata: UILabel!
    
     @IBOutlet weak var nameOfAddvertisement: UILabel!
     
     @IBOutlet weak var numberOfLikes: UILabel!
     @IBOutlet weak var priceLbl: UILabel!
     @IBOutlet weak var imageOfSubCatagores: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
