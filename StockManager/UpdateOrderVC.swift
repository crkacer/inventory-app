import UIKit

class UpdateOrderVC: UIViewController {

    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblDue: UILabel!
    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var lblGrand: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblVAT: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblSub: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = orderName
        lblDate.text = orderDate
        lblContact.text = orderContact
        lblSub.text = "$"+orderSub
        lblVAT.text = "$"+orderVAT
        lblTotal.text = "$"+orderTotal
        lblDiscount.text = "$"+orderDiscount
        lblGrand.text = "$"+orderGrand
        lblPaid.text = "$"+orderPaid
        lblDue.text = "$"+orderDue
        if orderType == "1" {
            lblPaymentType.text = "Full Payment"
        } else if orderType == "2" {
            lblPaymentType.text = "Advance Payment"
        } else {
            lblPaymentType.text = "No Payment"
        }
        
    }
    
}
