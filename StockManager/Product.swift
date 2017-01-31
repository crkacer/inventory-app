//
//  Product.swift
//  StockManager
//
//  Created by MGXA2 on 1/7/17.
//  Copyright © 2017 Duc Nguyen. All rights reserved.
//

import Foundation


struct Product {
    //$id, $name, $image, $b_id, $c_id, $p_quant, $p_rate, $p_active, $p_status
    var id: String
    var name: String
    var image: String
    var b_id: String
    var c_id: String
    var p_quant: String
    var p_rate: String
    var p_active: String
    var p_status: String
    
    init (Object:Any){
        let obj = Object as! Dictionary<String,Any>
        self.id = obj["id"] as! String
        self.name = obj["name"] as! String
        self.image = obj["image"] as! String
        self.b_id = obj["b_id"] as! String
        self.c_id = obj["c_id"] as! String
        self.p_quant = obj["p_quant"] as! String
        self.p_rate = obj["p_rate"] as! String
        self.p_active = obj["p_active"] as! String
        self.p_status = obj["p_status"] as! String
    }
    
    init(id:String, name:String, image: String, b_id:String, c_id:String, p_quant:String, p_rate:String, p_active:String, p_status:String) {
        self.id = id
        self.name = name
        self.image = image
        self.b_id = b_id
        self.c_id = c_id
        self.p_quant = p_quant
        self.p_rate = p_rate
        self.p_active = p_active
        self.p_status = p_status
    }
}
