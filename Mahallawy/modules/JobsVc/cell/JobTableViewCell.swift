//
//  JobTableViewCell.swift
//  Mahallawy
//
//  Created by jooo on 3/25/22.
//  Copyright © 2022 youssef. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {

    @IBOutlet weak var nameOfJob: UILabel!
    @IBOutlet weak var statusOfJob: UILabel!
    @IBOutlet weak var describtionOfJob: UILabel!
    @IBOutlet weak var numberOfViews: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
