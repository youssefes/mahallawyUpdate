//
//  CartCollectionViewCell.swift
//  Mahallawy
//
//  Created by jooo on 7/29/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import MOLH
protocol CartCollectionViewProtocal {
    func DeleteProdect(cartId : String)
}
class CartCollectionViewCell: UICollectionViewCell {
    var Deleget : CartCollectionViewProtocal?
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameOfProdect: UILabel!
    @IBOutlet weak var nameOfBrand: UILabel!
    
    @IBOutlet weak var nameOfBrandOrQuantity: UILabel!
    @IBOutlet weak var barndContainer: UIStackView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var imageOfProdecgt: UIImageView!
    var CartId : String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            MOLH.setLanguageTo("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }

    @IBAction func DeleteBtn(_ sender: Any) {
        guard let CartId = self.CartId else {
            return
        }
        Deleget?.DeleteProdect(cartId: CartId)
    }
}
