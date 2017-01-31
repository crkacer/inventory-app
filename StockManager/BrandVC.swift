//
//  BrandVC.swift
//  StockManager
//
//  Created by MGXA2 on 12/5/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import UIKit
var brandName:String = ""
var brandId:String = ""
var brandIndex:Int!
var arrBrand = Array<Brand>()

class BrandVC: UIViewController {

    @IBOutlet weak var txtNewBrand: UITextField!
    @IBOutlet weak var tblListBrand: UITableView!
    var maxIndex:Int = 0
    override func viewWillAppear(_ animated: Bool) {
        tblListBrand.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tblListBrand.delegate = self
        tblListBrand.dataSource = self
        arrBrand.removeAll()
        loadBrandJSON()
        tblListBrand.reloadData()
    
        print(arrBrand)
    }
    func loadBrandJSON(){
        arrBrand.removeAll()
        let url:URL = URL(string: "http://dukeio.esy.es/api/loadBrand.php")!
        let session = URLSession.shared.dataTask(with: url) { (data, res, err) in
            if err == nil {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Array<Any>
                    
                    for i in result {
                        let newB = Brand(Object: i)
                        if newB.status == "1" {
                            arrBrand.append(newB)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tblListBrand.reloadData()
                        print(arrBrand)
                        if arrBrand.isEmpty == false {
                            for i in 0...arrBrand.count - 1 {
                                if Int(arrBrand[i].id)! > self.maxIndex {
                                    self.maxIndex = Int(arrBrand[i].id)!
                                }
                            }
                        }
                    }
                }
                catch {
                    print("Error reading JSON")
                }
                
            }
        }
        session.resume()
    }
    
    func TestBrand(newBrand:String)->Bool {
        if arrBrand.isEmpty == false {
            for i in 0...arrBrand.count - 1 {
                if (arrBrand[i].name == newBrand && arrBrand[i].status == "1") {
                    return false
                }
            }
            return true
        } else {
            return true
        }
        
    }
    
    @IBAction func btnEnterNewBrand(_ sender: Any) {
        if TestBrand(newBrand: txtNewBrand.text!) {
            arrBrand.append(Brand(id: String(maxIndex+1), name: self.txtNewBrand.text!, active: "1", status: "1"))
            self.tblListBrand.reloadData()
            
            let url:URL = URL(string: "http://dukeio.esy.es/api/addBrand.php")!
            var req:URLRequest = URLRequest(url: url)
            let name:String = txtNewBrand.text!
            let active:String = "1"
            let status:String = "1"
            req.httpMethod = "POST"
            let param = "name=\(name)&&active=\(active)&&status=\(status)"
            req.httpBody = param.data(using: String.Encoding.utf8)
            
            let session = URLSession.shared.dataTask(with: req) { (data, res, err) in
                if err == nil {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, String>
                        print(result)
                    }
                    catch {
                        print("Error reading json")
                    }
                }
            }
            session.resume()

        } else {
            print("\(txtNewBrand.text) already existed")
        }
//        if let input = txtNewBrand.text {
//        }
    }
    
    func EditBrand(id: Int){
        brandName = arrBrand[id].name
        brandId = arrBrand[id].id
        brandIndex = id
        print(arrBrand[id].id)
        let screen = storyboard?.instantiateViewController(withIdentifier: "UpdateBrandScr")
        navigationController?.pushViewController(screen!, animated: true)
    }
    
    func DelBrand(id: Int){
        
        let url:URL = URL(string: "http://dukeio.esy.es/api/delBrand.php")!
        var req:URLRequest = URLRequest(url: url)
        
        req.httpMethod = "POST"
        let param = "id=\(arrBrand[id].id)"
        print(arrBrand[id].id)
        print(arrBrand)
        print("=======================================")
        arrBrand.remove(at: id)
        tblListBrand.reloadData()
        print(arrBrand)
        req.httpBody = param.data(using: String.Encoding.utf8)
 
        let session = URLSession.shared.dataTask(with: req) { (data, res, err) in
            if err == nil {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, String>
                    print(result)
//                    self.loadBrandJSON()
                }
                catch {
                    print("Error reading JSON")
                }
            }
        }
        session.resume()
    }
}

extension BrandVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBrand.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BCell", for: indexPath) as! BrandCell
        cell.lblBrand.text = arrBrand[indexPath.row].name
        cell.imgActive.image = UIImage(named: arrBrand[indexPath.row].active)
        cell.imgActive.contentMode = .scaleAspectFit
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        let btnDelete:UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Delete") { (btn, index) in
            print(indexPath.row)
            self.DelBrand(id: indexPath.row)
        }
        btnDelete.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        let btnUpdate:UITableViewRowAction = UITableViewRowAction(style: .default, title: "Update") { (btn, index) in
            print(indexPath.row)
            self.EditBrand(id: indexPath.row)
        }
        btnUpdate.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return [btnDelete]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.EditBrand(id: indexPath.row)
    }
}



