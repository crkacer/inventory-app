//
//  BrandCell.swift
//  StockManager
//
//  Created by MGXA2 on 12/6/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import UIKit

class BrandCell: UITableViewCell {

    @IBOutlet weak var imgActive: UIImageView!
    @IBOutlet weak var lblBrand: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
