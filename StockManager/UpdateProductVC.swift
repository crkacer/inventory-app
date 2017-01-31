//
//  UpdateProductVC.swift
//  StockManager
//
//  Created by MGXA2 on 12/10/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//
import UIKit
class UpdateProductVC: UIViewController {
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var txtProduct: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtQuantity: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtProduct.text = productName
        txtPrice.text = arrProduct[productIndex].p_rate
        txtQuantity.text = arrProduct[productIndex].p_quant
        loadImage()
    }
    
    func loadImage() {
        let queue = DispatchQueue(label: "LoadImage")
        queue.async {
            var newString:String = arrProduct[productIndex].image
            newString.remove(at: newString.startIndex)
            newString.remove(at: newString.startIndex)
            print("http://dukeio.esy.es" + newString)
            let url:URL = URL(string: "http://dukeio.esy.es" + newString)!
            do
            {
                let data:Data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.imgProduct.image = UIImage(data: data)
                    self.imgProduct.contentMode = .scaleAspectFit
                }
            }
            catch
            {
                print("Error download image")
            }
        }

    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        let name:String = txtProduct.text!
        let active:String = "1"
        
        let status:String = "1"
        arrBrand[brandIndex] = Brand(id: brandId, name: name, active: active, status: status)
        print(arrBrand)
        let url:URL = URL(string: "http://dukeio.esy.es/api/updateProduct.php")!
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
    
}




