//
//  OrderCell.swift
//  StockManager
//
//  Created by MGXA2 on 12/10/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
