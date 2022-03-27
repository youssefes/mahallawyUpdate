//
//  FooterCollectionViewCell.swift
//  Mahallawy
//
//  Created by jooo on 3/19/22.
//  Copyright © 2022 youssef. All rights reserved.
//

import UIKit

protocol FooterCollectionViewCellProtocal {
    func openJobs()
    func openAdvertisment()
}
class FooterCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var containerOfCell: UIView!
    var deleget : FooterCollectionViewCellProtocal?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func advertisment(_ sender: Any) {
        deleget?.openAdvertisment()
    }
    @IBAction func jobsBtn(_ sender: Any) {
        deleget?.openJobs()
    }
}
