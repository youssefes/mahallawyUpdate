//
//  DescriptionTableViewCell.swift
//  Mahallawy
//
//  Created by jooo on 7/2/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var valueOfDescription: UILabel!
    @IBOutlet weak var nameOfDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
