//
//  UpdateBrandVC.swift
//  StockManager
//
//  Created by MGXA2 on 12/7/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import UIKit
let arrActive:Array<String> = ["Available", "Unavailable"]

class UpdateBrandVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerActive: UIPickerView!
    @IBOutlet weak var txtBrand: UITextField!
    
    
    var str_active:String = "Available"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtBrand.text = brandName
        pickerActive.dataSource = self
        pickerActive.delegate = self
        
    }
    @IBAction func btnConfirm(_ sender: Any) {
        let name:String = txtBrand.text!
        var active:String = "1"
        if str_active == "Available" {
            active = "1"
        } else{
            active = "2"
        }
        let status:String = "1"
        arrBrand[brandIndex] = Brand(id: brandId, name: name, active: active, status: status)
        print(arrBrand)
        let url:URL = URL(string: "http://dukeio.esy.es/api/updateBrand.php")!
        var req:URLRequest = URLRequest(url: url)
        req.httpMethod = "POST"
        let param = "id=\(brandId)&&name=\(name)&&active=\(active)&&status=\(status)"
        print(param)
        req.httpBody = param.data(using: String.Encoding.utf8)

        let session = URLSession.shared.dataTask(with: req) { (data, res, err) in
            if err == nil {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, String>
                    print(result)
                }
                catch {
                    print("Error reading JSON")
                }
            }
        }
        session.resume()
        switchBrandScr()
    }

    @IBAction func btnCancel(_ sender: Any) {
        switchBrandScr()
    }
    
    func switchBrandScr () {
//        let manhinh = storyboard?.instantiateViewController(withIdentifier: "BrandScr")
//        navigationController?.pushViewController(manhinh!, animated: true)
        navigationController!.popViewController(animated: true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrActive.count
    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return arrActive[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        str_active = arrActive[row]
        print(str_active)
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        if row == 1 {
            label.textColor = .red
        } else {
            label.textColor = .green
        }
        
        label.textAlignment = .center
        label.font = UIFont(name: "SanFranciscoText-Light", size: 18)
        
        // where data is an Array of String
        label.text = arrActive[row]
        
        return label
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20.0
    }
}


