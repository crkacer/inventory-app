import UIKit

class CreateProductVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtQuant: UITextField!
    @IBOutlet weak var dataPicker: UIPickerView!
    
    var arrData:Array<Array<String>> = [[],[]]
    var newBrand:String = ""
    var newCategory:String = ""
    var arrB:Array<String> = []
    var arrC:Array<String> = []
    var isCamera:Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        loadBrandCategory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.text = newProduct
        imgProduct.image = UIImage(named: "new")
        imgProduct.contentMode = .scaleAspectFit
        arrB.removeAll()
        arrC.removeAll()
        arrData.removeAll()
    }
    
    func loadBrandCategory(){
        arrB.removeAll()
        arrC.removeAll()
        arrData.removeAll()
        
        let url:URL = URL(string: "http://dukeio.esy.es/api/loadBrand.php")!
        let session = URLSession.shared.dataTask(with: url) { (data, res, err) in
            if err == nil {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Array<Any>
//                    let a = String.init(data: data!, encoding: String.Encoding.utf8)
//                    print(a)
                    for i in result {
                        let newB = Brand(Object: i)
                        print(newB)
                        if newB.status == "1" {
                            self.arrB.append(newB.name)
                        }
                    }
                    DispatchQueue.main.async {
                        self.arrData.insert(self.arrB, at: 0)
                        self.newBrand = self.arrData[0][0]
                        print(self.arrData)
                        self.dataPicker.delegate = self
                        self.dataPicker.dataSource = self
                        self.dataPicker.reloadAllComponents()
                    }
                    

                }
                catch {
                    print("Error reading JSON")
                }
                
            }
        }
        session.resume()
        //=====================================================
        let newUrl:URL = URL(string: "http://dukeio.esy.es/api/loadCategory.php")!
        let newSession = URLSession.shared.dataTask(with: newUrl) { (data, res, err) in
            if err == nil {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Array<Any>
                    
                    for i in result {
                        let newC = Category(Object: i)
                        if newC.status == "1" {
                            self.arrC.append(newC.name)
                        }
                    }
                    DispatchQueue.main.async {
//                        self.arrData.insert(self.arrC, at: 1)
                        self.arrData.append(self.arrC)
                        self.newCategory = self.arrData[1][0]
                        print(self.arrData[1][0])
                        print(self.arrData)
                        self.dataPicker.delegate = self
                        self.dataPicker.dataSource = self
                        self.dataPicker.reloadAllComponents()
                    }
                    
                }
                catch {
                    print("Error reading JSON")
                }
                
            }
        }
        
        newSession.resume()
        DispatchQueue.main.async {
            print(self.arrC)
            print(self.arrB)
    
        }

    }
    
    //=======================================================================//
    //Uploading Image
    
    @IBAction func uploadPressed(_ sender: UITapGestureRecognizer) {
        let pickerImage:UIImagePickerController = UIImagePickerController()
        pickerImage.delegate = self
        
        let alert:UIAlertController = UIAlertController(title: "Alert choice", message: "Take or Review photos", preferredStyle: .alert)
        let btnCamera:UIAlertAction = UIAlertAction(title: "Camera", style: .cancel) { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                self.isCamera = true
                pickerImage.sourceType = .camera
                pickerImage.allowsEditing = false
                pickerImage.cameraCaptureMode = .photo
                pickerImage.modalPresentationStyle = .fullScreen
                self.present(pickerImage, animated: true, completion: nil)
            } else {
                print("No Camera")
            }
        }
        let btnPhoto:UIAlertAction = UIAlertAction(title: "Photo", style: .destructive) { (UIAlertAction) in
            self.isCamera = false
            pickerImage.sourceType = .photoLibrary
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.photoLibrary)!
            pickerImage.allowsEditing = false
            pickerImage.modalPresentationStyle = .fullScreen
            self.present(pickerImage, animated: true, completion: nil)
            
        }
        alert.addAction(btnPhoto)
        alert.addAction(btnCamera)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func tappedImage(_ sender: UITapGestureRecognizer) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imgProduct.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func uploadImage() {
        
        let myUrl = NSURL(string: "http://dukeio.esy.es/api/uploadImage.php");
        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = [
            "firstName"  : "Duc",
            "lastName"    : "Nguyen",
            "userId"    : "9"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(imgProduct.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                if let sJSON = json { print(sJSON)}
                
                DispatchQueue.main.async(execute: {
                    self.imgProduct.image = nil;
                });
                
            }catch
            {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    


    //=======================================================================//

    
    @IBAction func btnConfirm(_ sender: Any) {
        
        arrProduct.append(Product(id: String(maxPIndex+1), name: newProduct, image: "image", b_id: newBrand, c_id: newCategory, p_quant: txtQuant.text!, p_rate: txtPrice.text!, p_active: "1", p_status: "1"))
        
        let url:URL = URL(string: "http://dukeio.esy.es/api/addProduct.php")!
        var req:URLRequest = URLRequest(url: url)
        let name:String = newProduct
        let active:String = "1"
        let status:String = "1"
        req.httpMethod = "POST"
        let param = "name=\(name)&&b_id=\(newBrand)&&c_id=\(newCategory)&&p_quant=\(txtQuant.text)&&p_rate=\(txtPrice.text)&&p_active=\(active)&&p_status=\(status)"
        req.httpBody = param.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared.dataTask(with: req) { (data, res, err) in
            if err == nil {
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, String>
                    print(result)
                }
                catch {
                    print("Error loading JSON")
                }
            }
        }
        session.resume()
        uploadImage()
        switchProductScr()
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        switchProductScr()
    }
    
    func switchProductScr () {
        //        let manhinh = storyboard?.instantiateViewController(withIdentifier: "BrandScr")
        //        navigationController?.pushViewController(manhinh!, animated: true)
        navigationController!.popViewController(animated: true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return arrData.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrData[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            newBrand = arrData[component][row]
        } else {
            newCategory = arrData[component][row]
        }
        print("\(newBrand)+\(newCategory)")
    }
    
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
//        guard let label = view as? UILabel else {
//            preconditionFailure ("Expected a Label")
//        }
//        label.text = arrData[component][row]
//        label.font = UIFont(name: "Times New Roman", size: 1.0)
//        return label
//    }

}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension CreateProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            if isCamera {
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            }
            imgProduct.image = image
            dismiss(animated: true, completion: nil)
        } else {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
                imgProduct.image = image
                dismiss(animated: true, completion: nil)
            } else {
                print("Wrong image type")
            }
            
        }
    }

}
