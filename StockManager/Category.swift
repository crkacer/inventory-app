import Foundation


struct Category {
    var id: String
    var name: String
    var active: String
    var status: String
    
    init (Object:Any){
        let obj = Object as! Dictionary<String,Any>
        self.id = obj["id"] as! String
        self.name = obj["name"] as! String
        self.active = obj["active"] as! String
        self.status = obj["status"] as! String
    }
    
    init(id:String, name:String, active:String, status:String) {
        self.id = id
        self.name = name
        self.active = active
        self.status = status
    }
}
