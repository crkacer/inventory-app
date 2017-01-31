import UIKit

var catName:String = ""
var catId:String = ""
var catIndex:Int!
var arrCat = Array<Category>()


class CategoryVC: UIViewController {

    @IBOutlet weak var lblInputCat: UITextField!
    @IBOutlet weak var tblListCat: UITableView!
    var maxIndex:Int = 0
    
    @IBAction func btnEnter(_ sender: Any) {
        if TestCategory(newCategory: lblInputCat.text!) {
            arrCat.append(Category(id: String(maxIndex+1), name: self.lblInputCat.text!, active: "1", status: "1"))
            self.tblListCat.reloadData()
            
            let url:URL = URL(string: "http://dukeio.esy.es/api/addCategory.php")!
            var req:URLRequest = URLRequest(url: url)
            let name:String = lblInputCat.text!
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
                        print("Error reading JSON")
                    }
                }
            }
            session.resume()
            
        } else {
            print("\(lblInputCat.text) already existed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblListCat.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tblListCat.delegate = self
        tblListCat.dataSource = self
        arrCat.removeAll()
        loadCategoryJSON()
        tblListCat.reloadData()
        
        print(arrBrand)
    }
    func loadCategoryJSON(){
        arrCat.removeAll()
        let url:URL = URL(string: "http://dukeio.esy.es/api/loadCategory.php")!
        let session = URLSession.shared.dataTask(with: url) { (data, res, err) in
            if err == nil {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Array<Any>
                    
                    for i in result {
                        let newC = Category(Object: i)
                        if newC.status == "1" {
                            arrCat.append(newC)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tblListCat.reloadData()
                        print(arrCat)
                        if arrCat.isEmpty == false {
                            for i in 0...arrCat.count - 1 {
                                if Int(arrCat[i].id)! > self.maxIndex {
                                    self.maxIndex = Int(arrCat[i].id)!
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
    
    func TestCategory(newCategory:String)->Bool {
        if arrCat.isEmpty == false {
            for i in 0...arrCat.count - 1 {
                if (arrCat[i].name == newCategory && arrCat[i].status == "1") {
                    return false
                }
            }
            return true
        } else {
            return true
        }
        
    }
    
    
    func EditCat(id: Int){
        catName = arrCat[id].name
        catId = arrCat[id].id
        catIndex = id
        print(arrCat[id].id)
        let screen = storyboard?.instantiateViewController(withIdentifier: "UpdateCategoryScr")
        navigationController?.pushViewController(screen!, animated: true)
    }
    
    func DelCat(id: Int){
        
        let url:URL = URL(string: "http://dukeio.esy.es/api/delCategory.php")!
        var req:URLRequest = URLRequest(url: url)
        
        req.httpMethod = "POST"
        let param = "id=\(arrCat[id].id)"
        print(arrCat[id].id)
        print(arrCat)
        print("=======================================")
        arrCat.remove(at: id)
        tblListCat.reloadData()
        print(arrCat)
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




extension CategoryVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCat.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CCell", for: indexPath) as! CategoryCell
        cell.lblCat.text = arrCat[indexPath.row].name
        cell.imgCat.image = UIImage(named: arrCat[indexPath.row].active)
        cell.imgCat.contentMode = .scaleAspectFit
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let btnDelete:UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Delete") { (btn, index) in
            print(indexPath.row)
            self.DelCat(id: indexPath.row)
        }
        btnDelete.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        let btnUpdate:UITableViewRowAction = UITableViewRowAction(style: .default, title: "Update") { (btn, index) in
            print(indexPath.row)
            self.EditCat(id: indexPath.row)
        }
        btnUpdate.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return [btnDelete]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.EditCat(id: indexPath.row)
    }
}




