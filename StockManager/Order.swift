import Foundation


struct Order {
    
    var id: String
    var date: String
    var name: String
    var contact: String
    var sub:String
    var vat:String
    var total:String
    var discount:String
    var grand:String
    var paid:String
    var due:String
    var type:String
    var payment_status:String
    var order_status:String
    
    init (Object:Any){
        let obj = Object as! Dictionary<String,Any>
        self.id = obj["id"] as! String
        self.date = obj["date"] as! String
        self.name = obj["name"] as! String
        self.contact = obj["contact"] as! String
        self.sub = obj["sub"] as! String
        self.vat = obj["vat"] as! String
        self.total = obj["total_amount"] as! String
        self.discount = obj["discount"] as! String
        self.grand = obj["total"] as! String
        self.paid = obj["paid"] as! String
        self.due = obj["due"] as! String
        self.type = obj["type"] as! String
        self.payment_status = obj["payment_status"] as! String
        self.order_status = obj["order_status"] as! String
    }
    
}
