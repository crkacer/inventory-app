import UIKit
var productName:String = ""
var productId:String = ""
var productIndex:Int!
var arrProduct = Array<Product>()
var newProduct:String = ""
var maxPIndex:Int = 0

class ProductVC: UIViewController {
    
    @IBOutlet weak var txtNewProduct: UITextField!
    @IBOutlet weak var tblListProduct: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        tblListProduct.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tblListProduct.delegate = self
        tblListProduct.dataSource = self
        arrProduct.removeAll()
        loadProductJSON()
        tblListProduct.reloadData()
        
    }
    func loadProductJSON(){
        arrProduct.removeAll()
        let url:URL = URL(string: "http://dukeio.esy.es/api/loadProduct.php")!
        let session = URLSession.shared.dataTask(with: url) { (data, res, err) in
            if err == nil {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Array<Any>
                    
                    for i in result {
                        let newP = Product(Object: i)
                        if newP.p_status == "1" {
                            arrProduct.append(newP)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tblListProduct.reloadData()
                        print(arrProduct)
                        if arrProduct.isEmpty == false {
                            for i in 0...arrProduct.count - 1 {
                                if Int(arrProduct[i].id)! > maxPIndex {
                                    maxPIndex = Int(arrProduct[i].id)!
                                }
                            }
                        }
                    }
                    print(arrProduct)
                }
                catch {
                    print("Error reading JSON")
                }
                
            }
        }
        session.resume()
    }
    
    func TestProduct(newProduct:String)->Bool {
        if arrProduct.isEmpty == false {
            for i in 0...arrProduct.count - 1 {
                if (arrProduct[i].name == newProduct && arrProduct[i].p_status == "1") {
                    return false
                }
            }
            return true
        } else {
            return true
        }
        
    }
        
    @IBOutlet weak var btnEnterNewProduct: UIButton!
    
    @IBAction func btnEnterNewProduct(_ sender: Any) {
        if TestProduct(newProduct: txtNewProduct.text!) {
            
            newProduct = txtNewProduct.text!
            let screen = storyboard?.instantiateViewController(withIdentifier: "CreateProductVC")
            navigationController?.pushViewController(screen!, animated: true)
            
        } else {
            print("\(txtNewProduct.text) already existed")
        }
    }
    
    func EditProduct(id: Int){
        productName = arrProduct[id].name
        productId = arrProduct[id].id
        productIndex = id
        print(arrProduct[id].id)
        let screen = storyboard?.instantiateViewController(withIdentifier: "UpdateProductScr")
        navigationController?.pushViewController(screen!, animated: true)
    }
    
    func DelProduct(id: Int){
        
        let url:URL = URL(string: "http://dukeio.esy.es/api/delProduct.php")!
        var req:URLRequest = URLRequest(url: url)
        
        req.httpMethod = "POST"
        let param = "id=\(arrProduct[id].id)"
        print(arrProduct[id].id)
        print(arrProduct)
        print("=======================================")
        arrProduct.remove(at: id)
        tblListProduct.reloadData()
        print(arrProduct)
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

extension ProductVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProduct.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PCell", for: indexPath) as! ProductCell
        cell.lblName.text = arrProduct[indexPath.row].name
        cell.lblPrice.text = "$"+arrProduct[indexPath.row].p_rate
        cell.imgActive.image = UIImage(named: arrProduct[indexPath.row].p_active)
        let queue = DispatchQueue(label: "LoadHinh")
        queue.async {
            
            var newString:String = arrProduct[indexPath.row].image
            newString.remove(at: newString.startIndex)
            newString.remove(at: newString.startIndex)
            print("http://dukeio.esy.es"+newString)
            let url:URL = URL(string: "http://dukeio.esy.es" + newString)!
            do
            {
                let data:Data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    cell.imgProduct.image = UIImage(data: data)
                    cell.imgProduct.contentMode = .scaleAspectFit
                }
            }
            catch
            {
                print("Error download image")
            }
        }

        cell.imgActive.contentMode = .scaleAspectFit
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let btnDelete:UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Delete") { (btn, index) in
            print(indexPath.row)
            self.DelProduct(id: indexPath.row)
        }
        btnDelete.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        let btnUpdate:UITableViewRowAction = UITableViewRowAction(style: .default, title: "Update") { (btn, index) in
            print(indexPath.row)
            self.EditProduct(id: indexPath.row)
        }
        btnUpdate.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return [btnDelete]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.EditProduct(id: indexPath.row)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}




