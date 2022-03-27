//
//  SliderCell.swift
//  PizzaWorld
//
//  Created by Osama on 10/14/20.
//

import UIKit

class SliderCell: UICollectionViewCell {

    @IBOutlet weak var sliderImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configure()
    }
    
    func configure(){
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

}
