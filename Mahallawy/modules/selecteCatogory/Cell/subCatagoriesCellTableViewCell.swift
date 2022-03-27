//
//  subCatagoriesCellTableViewCell.swift
//  Mahallawy
//
//  Created by youssef on 3/27/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Cosmos

class subCatagoriesCellTableViewCell: UITableViewCell {
    @IBOutlet weak var nameOfSubCata: UILabel!
    
    @IBOutlet weak var pricseLbl: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var nameOfRating: UILabel!
    @IBOutlet weak var imageOfSubCatagores: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        nameOfSubCata.textAlignment = .right
        nameOfRating.textAlignment = .right
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
