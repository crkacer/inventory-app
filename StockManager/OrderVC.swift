import UIKit

var orderName:String = ""
var orderId:String = ""
var orderDate, orderContact, orderSub, orderVAT, orderTotal, orderDiscount, orderGrand, orderPaid, orderDue, orderType:String!
var orderIndex:Int!
var arrOrder = Array<Order>()

class OrderVC: UIViewController {

    
    @IBOutlet weak var tblOrder: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOrder.delegate = self
        tblOrder.dataSource = self
        loadOrderJSON()
    }

    
    func ViewOrder(id: Int) {
        orderName = arrOrder[id].name
        orderId = arrOrder[id].id
        orderDate = arrOrder[id].date
        orderContact = arrOrder[id].contact
        orderSub = arrOrder[id].sub
        orderVAT = arrOrder[id].vat
        orderTotal = arrOrder[id].total
        orderDiscount = arrOrder[id].discount
        orderGrand = arrOrder[id].grand
        orderPaid = arrOrder[id].paid
        orderDue = arrOrder[id].due
        orderType = arrOrder[id].payment_status
        orderIndex = id
        print(arrOrder[id].id)
        let screen = storyboard?.instantiateViewController(withIdentifier: "UpdateOrderScr")
        navigationController?.pushViewController(screen!, animated: true)
    }
    
    func loadOrderJSON(){
        arrOrder.removeAll()
        let url:URL = URL(string: "http://dukeio.esy.es/api/loadOrder.php")!
        let session = URLSession.shared.dataTask(with: url) { (data, res, err) in
            if err == nil {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Array<Any>
                    
                    for i in result {
                        let newO = Order(Object: i)
                        if newO.order_status == "1" {
                            arrOrder.append(newO)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tblOrder.reloadData()
                        print(arrOrder)
                    }
                }
                catch {
                    print("Error reading JSON")
                }
                
            }
        }
        session.resume()
    }

}

extension OrderVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OCell", for: indexPath) as! OrderCell
        cell.lblDate.text = arrOrder[indexPath.row].date
        cell.lblAmount.text = "$"+arrOrder[indexPath.row].grand
        cell.lblAmount.font = UIFont(name: "Times New Roman", size: 20.0)
        cell.lblName.text = arrOrder[indexPath.row].name
        if arrOrder[indexPath.row].payment_status == "1" {
            cell.lblPayment.text = "Full Payment"
            cell.lblPayment.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            
        } else if arrOrder[indexPath.row].payment_status == "2" {
            cell.lblPayment.text = "Advance Payment"
            cell.lblPayment.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            
        } else {
            cell.lblPayment.text = "No Payment"
            cell.lblPayment.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        cell.lblPayment.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.lblPayment.font = UIFont(name: "Times New Roman", size: 15.0)
        cell.lblPayment.textAlignment = NSTextAlignment.center
        cell.lblPayment.layer.masksToBounds = true
        cell.lblPayment.layer.cornerRadius = 7
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.ViewOrder(id: indexPath.row)
    }
}
