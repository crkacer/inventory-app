//
//  CategoryCell.swift
//  StockManager
//
//  Created by MGXA2 on 12/6/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var imgCat: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
