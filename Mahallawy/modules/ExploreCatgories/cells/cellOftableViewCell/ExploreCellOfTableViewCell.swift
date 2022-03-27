//
//  ExploreCellOfTableViewCell.swift
//  Mahallawy
//
//  Created by youssef on 3/28/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Cosmos

class ExploreCellOfTableViewCell: UICollectionViewCell {

    @IBOutlet weak var brandNameLbl: UILabel!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var imageOfBrand: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        ratingView.rating = 0.0
        ratingView.text = ""
        imageOfBrand.image = nil
        brandNameLbl.text = ""
        
    }

}
