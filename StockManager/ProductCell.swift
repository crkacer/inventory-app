//
//  ProductCell.swift
//  StockManager
//
//  Created by MGXA2 on 12/6/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgActive: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
