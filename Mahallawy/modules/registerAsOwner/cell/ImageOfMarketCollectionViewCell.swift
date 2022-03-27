//
//  ImageOfMarketCollectionViewCell.swift
//  Mahallawy
//
//  Created by youssef on 3/16/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

class ImageOfMarketCollectionViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var imageOfMarket: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        imageOfMarket.image = #imageLiteral(resourceName: "ic_gallery")
    }

}
