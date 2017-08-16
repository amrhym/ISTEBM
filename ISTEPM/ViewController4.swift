//
//  ViewController4.swift
//  ISTEPM
//
//  Created by amr Elshendidy on 8/14/17.
//  Copyright © 2017 amr Elshendidy. All rights reserved.
//

import UIKit

class ViewController4: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

 
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var SubjectText: UITextField!
    @IBOutlet weak var AddTaskButton: UIButton!
 
    @IBOutlet weak var StatusPicker: UIPickerView!
    @IBOutlet weak var DueDatePicker: UIDatePicker!
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    @IBOutlet weak var pickerProject: UIPickerView!
    var username: String? = nil
    var password: String? = nil
    var gg:[String] = [String]()
    
    var co:[String] = [String]()
    var StartDate = ""
    var DueDate = ""
    var selectedproject = ""
    var Status = ["Not Started","In Progress","Completed","Deferred","Waiting on someone else"]
    var selectedStatus = ""
    lazy var conn: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        return session
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        errorLabel.isHidden = true
        AddTaskButton.isHidden = false
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        AddTaskButton.backgroundColor = UIColor.clear
        AddTaskButton.layer.cornerRadius = 5
        AddTaskButton.layer.borderWidth = 1
        AddTaskButton.layer.borderColor = UIColor.black.cgColor
        backButton.backgroundColor = UIColor.clear
        backButton.layer.cornerRadius = 5
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.black.cgColor
        view.addGestureRecognizer(tap)
        
        pickerProject.delegate = self
        pickerProject.dataSource = self
        pickerProject.tag = 0
        StatusPicker.delegate = self
        StatusPicker.dataSource = self
        StatusPicker.tag = 1
        StartDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        DueDatePicker.addTarget(self, action: #selector(dateChanged2(_:)), for: .valueChanged)
        let preferences = UserDefaults.standard
        
        username = (preferences.object(forKey: "username") as? String)!.trimmingCharacters(in: CharacterSet.whitespaces)
        password  = (preferences.object(forKey: "password") as? String)!.trimmingCharacters(in: CharacterSet.whitespaces)
        co = (preferences.object(forKey: "Projects") as? [String])!
        for f in co {
            print (f)
        }
     
        // Do any additional setup after loading the view.
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func doesHaveCredentials() -> Bool {
        guard let _ = self.username else { return false }
        guard let _ = self.password else { return false }
        return true
    }
    
    func dateChanged(_ sender: UIDatePicker) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            print("\(day) \(month) \(year)")
            StartDate = ""+String(year)+"-"+String(month)+"-"+String(day)
        }
    }
    func dateChanged2(_ sender: UIDatePicker) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            print("\(day) \(month) \(year)")
             DueDate = ""+String(year)+"-"+String(month)+"-"+String(day)
            
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
        return co.count
        }else{
        return Status.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       if pickerView.tag == 0{
        selectedproject = co[row]
        return co[row]
       }else{
        selectedStatus = Status[row]
        return Status[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    
    @IBAction func AddTaskAction(_ sender: Any) {
         let preferences = UserDefaults.standard
        self.username = (preferences.object(forKey: "username") as? String)!.trimmingCharacters(in: CharacterSet.whitespaces)
        self.password  = (preferences.object(forKey: "password") as? String)!.trimmingCharacters(in: CharacterSet.whitespaces)
        print (self.username!  + "   "+self.password!)
        let soapMessage = "<x:Envelope xmlns:x=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:soa=\"http://schemas.microsoft.com/sharepoint/soap/\"><x:Header/><x:Body><soa:UpdateListItems><soa:listName>Project Tasks</soa:listName><soa:updates><Batch  ListVersion=\"1\" OnError=\"Continue\" ViewName=\"6ed80217-dfef-4f27-8937-d76919112727\"><Method ID=\"1\" Cmd=\"New\"> <Field Name=\"ID\">New</Field><Field Name=\"Title\">"+SubjectText.text!+"</Field><Field Name=\"AssignedTo\">"+(preferences.object(forKey: "NameCode") as? String)!+"</Field><Field Name=\"TaskCompanies\">"+selectedproject+"</Field><Field Name=\"BillingInformation\"></Field><Field Name=\"Status\">"+selectedStatus+"</Field><Field Name=\"Priority\">(2) Normal</Field><Field Name=\"PercentComplete\">0</Field><Field Name=\"ActualWork\">0.000000000000</Field><Field Name=\"TotalWork\"></Field><Field Name=\"Body\"></Field><Field Name=\"StartDate\">"+StartDate+"</Field><Field Name=\"DueDate\">"+DueDate+"</Field><Field Name=\"DateCompleted\">2017-08-30</Field><Field Name=\"Role\">240.000000000000</Field></Method></Batch></soa:updates></soa:UpdateListItems></x:Body></x:Envelope>"
        let urlString = "http://emp.istnetworks.com/_vti_bin/Lists.asmx"
        let url = URL(string: urlString)
        print(soapMessage)
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue("http://schemas.microsoft.com/sharepoint/soap/UpdateListItems", forHTTPHeaderField: "SOAPAction")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let task = conn.dataTask(with: theRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print ("error")
                
                return
            }
            print("expectedContentLength", response?.expectedContentLength)
            print(response)
            
            print(error)
            print(String(data: data!, encoding: .utf8))
            var g = String(data: data!, encoding: .utf8)
            if (g?.contains("<ErrorCode>0x00000000</ErrorCode>"))!{
            DispatchQueue.main.async(execute: self.addedsuccessfully)
            }else{
                   DispatchQueue.main.async(execute: self.failedtoadd)
            }
            //  let preferences = UserDefaults.standard
            // preferences.set(companies, forKey: "coo")
           
            guard let server_response = g as? String else
            {
                return
            }
        })
        
        task.resume()
    }
    func addedsuccessfully()
    {
       
            AddTaskButton.isHidden = true
            errorLabel.isHidden = false
            errorLabel.numberOfLines = 0
            errorLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            errorLabel.text = self.SubjectText.text! + " Task has been added successfully"
            errorLabel.textColor = UIColor.green
            
       
        
    
    }
    func failedtoadd(){
        errorLabel.isHidden = false
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        errorLabel.text = "adding Task process failed please try again"
        errorLabel.textColor = UIColor.red
    }
    func parsexml(tagname:String ,xmlstring:String,itemNum:Int)-> String{
        var Num = 0
        let tok =  xmlstring.components(separatedBy: "z:row")
        var NumOfItems = tok.count-1
        var val = ""
        print(tok.count-1)
        var i = 0
        for var str in tok {
            if(i==0){
                
            }else{
                var range = str.range(of: "/>")
                let endPos11 = str.distance(from: str.startIndex, to: (range?.lowerBound)!)
                var indexk1 = str.index(str.startIndex, offsetBy: endPos11)
                print(str.substring(to: indexk1))
                let s2 = str.substring(to: indexk1)
                let tok1 = s2.components(separatedBy: "ows_")
                var y = 0
                for var elem in tok1{
                    if(y==0){
                    }else{
                        
                        var ra11 = elem.range(of: "' ")
                        let endPos111 = elem.distance(from: elem.startIndex, to: (ra11?.lowerBound)!)
                        var indexk11 = elem.index(elem.startIndex, offsetBy: endPos111)
                        print(elem.substring(to: indexk11))
                        var name = elem.substring(to: indexk11)
                        if(name.contains(tagname)){
                            val = elem.substring(to: indexk11)
                        }
                    }
                    y = y+1
                }
            }
            if(Num == itemNum){
                break
            }
            i = i+1
            Num = Num+1
        }
        return val.replacingOccurrences(of: tagname+"='", with: "")
    }
}
extension ViewController4: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("got challenge")
        
        guard challenge.previousFailureCount == 0 else {
            print("too many failures")
            
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM else {
            print("unknown authentication method \(challenge.protectionSpace.authenticationMethod)")
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard self.doesHaveCredentials() else {
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            DispatchQueue.main.async {
                print("Userdata not set")
            };
            return
        }
        
        let credentials = URLCredential(user: self.username!, password: self.password!, persistence: .forSession)
        challenge.sender?.use(credentials, for: challenge)
        completionHandler(.useCredential, credentials)
    }
}
