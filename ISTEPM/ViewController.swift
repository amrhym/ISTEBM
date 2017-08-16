//
//  ViewController.swift
//  ISTEPM
//
//  Created by amr Elshendidy on 8/12/17.
//  Copyright © 2017 amr Elshendidy. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITextFieldDelegate, NSURLConnectionDelegate, XMLParserDelegate {
    @IBOutlet weak var UserNameText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    var currentElementName = ""
    var strXMLData:String = ""
    var login_session:String = ""
    var username: String? = nil
    var password: String? = nil
    
    lazy var conn: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorLabel.isHidden = true
        let preferences = UserDefaults.standard
        if preferences.object(forKey: "session") != nil
        {
            
            login_session = preferences.object(forKey: "session") as! String
            check_session()
            
        }
        else
        {
            LoginToDo()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginAction(_ sender: Any) {
        if(loginButton.titleLabel?.text == "Logout")
        {
            let preferences = UserDefaults.standard
            preferences.removeObject(forKey: "session")
            
            LoginToDo()
        }
        else{
            login_now(username:UserNameText.text!, password: PasswordText.text!)
            getProjects(username:UserNameText.text!, password: PasswordText.text!)
        }
        //******************************
      
        
        
        
        
    }
    
    func doesHaveCredentials() -> Bool {
        guard let _ = self.username else { return false }
        guard let _ = self.password else { return false }
        return true
    }
    func getProjects(username:String, password:String){
        self.username = username.trimmingCharacters(in: CharacterSet.whitespaces)
        self.password  = password.trimmingCharacters(in: CharacterSet.whitespaces)
        let soapMessage = "<x:Envelope xmlns:x=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:soa=\"http://schemas.microsoft.com/sharepoint/soap/\"><x:Header/><x:Body><soa:GetListItems><soa:listName>Projects</soa:listName><soa:query><Query xmlns=\"http://schemas.microsoft.com/sharepoint/soap/\"><Where><Eq><FieldRef Name=\"Status\" /><Value Type=\"Text\">Active</Value></Eq></Where><OrderBy><FieldRef xmlns = \"http://schemas.microsoft.com/sharepoint/soap\" Name = \"Title\" Ascending = \"TRUE\" /></OrderBy></Query> </soa:query><soa:rowLimit>10000</soa:rowLimit></soa:GetListItems></x:Body></x:Envelope>"
        let urlString = "http://emp.istnetworks.com/_vti_bin/Lists.asmx"
        let url = URL(string: urlString)
        var companies:[String] = [String]()
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
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
         
            companies = self.parsexmlProject(tagname: "Title", xmlstring: g!)
            
            //  let preferences = UserDefaults.standard
            // preferences.set(companies, forKey: "coo")
            for sd in companies
            {
                print("*************************************")
                print(sd)
                
             
            }
            let preferences = UserDefaults.standard
            preferences.set(companies, forKey: "Projects")
            guard let server_response = g as? String else
            {
                return
            }
        })
        
        task.resume()
        

       
    }
    
    func login_now(username:String, password:String)
    {
        let post_data: NSDictionary = NSMutableDictionary()
        self.username = username.trimmingCharacters(in: CharacterSet.whitespaces)
        self.password  = password.trimmingCharacters(in: CharacterSet.whitespaces)
        post_data.setValue(username, forKey: "username")
        post_data.setValue(password, forKey: "password")
        
        let soapMessage = "<x:Envelope xmlns:x=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:soa=\"http://schemas.microsoft.com/sharepoint/soap/\"><x:Header></x:Header><x:Body><soa:GetListItems><soa:listName>UserInfo</soa:listName><soa:viewName/><soa:query><Query xmlns=\"http://schemas.microsoft.com/sharepoint/soap/\"><Where><Eq><FieldRef Name=\"Name\" /><Value Type=\"Text\">ISTKSAEPM\\"+username.trimmingCharacters(in: CharacterSet.whitespaces)+"</Value></Eq></Where></Query></soa:query><soa:viewFields/><soa:rowLimit>1000</soa:rowLimit></soa:GetListItems></x:Body></x:Envelope>"

        let urlString = "http://emp.istnetworks.com/_vti_bin/Lists.asmx"
        let url = URL(string: urlString)
       
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
      
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")

        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false

        let task = conn.dataTask(with: theRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print ("error")
                DispatchQueue.main.async(execute: self.LoginFailed)
                return
            }
      
            print(response)

            print(error)
            
            
            print(String(data: data!, encoding: .utf8))
            var d = String(data: data!, encoding: .utf8)
            var Nameu = self.parsexml(tagname: "ImnName", xmlstring: d!, itemNum: 1)
            var ID = self.parsexml(tagname: "ID", xmlstring: d!, itemNum: 1)
            var Email = self.parsexml(tagname: "EMail", xmlstring: d!, itemNum: 1)
            var CreatedOn = self.parsexml(tagname: "Created", xmlstring: d!, itemNum: 1)
            var UsName = self.parsexml(tagname: "Name", xmlstring: d!, itemNum: 1)
            var ModerationStatus = self.parsexml(tagname: "_ModerationStatus", xmlstring: d!, itemNum: 1)
            
            
            print(Nameu)
            guard let server_response = d as? String else
            {
                return
            }
            
            
            if let data_block = server_response as? String
            {
                if let session_data = data_block as? String
                {
                    self.login_session = session_data
                    
                    let preferences = UserDefaults.standard
                    preferences.set(session_data, forKey: "session")
                    preferences.set(self.username, forKey: "username")
                    preferences.set(self.password, forKey: "password")
                    preferences.set(Nameu, forKey: "ImnName")
                    preferences.set(ID, forKey: "ID")
                    preferences.set(Email, forKey: "EMail")
                    preferences.set(CreatedOn, forKey: "Created")
                    preferences.set(UsName, forKey: "Name")
                    preferences.set(ID+";#"+Nameu, forKey: "NameCode")
                    preferences.set(ModerationStatus, forKey: "ModerationStatus")
                    DispatchQueue.main.async(execute: self.LoginDone)
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainModule") as! ViewController2
                    self.present(nextViewController, animated:true, completion:nil)
                    
                    
                }
            }
        })
     
        task.resume()
        
        
        
    }
    
    func LoginDone()
    {
       /* UserNameText.isEnabled = false
        PasswordText.isEnabled = false
        
        loginButton.isEnabled = true
        ErrorLabel.isHidden = true
        
        loginButton.setTitle("Logout", for: .normal)*/
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainModule") as! ViewController2
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func LoginToDo()
    {
        UserNameText.isEnabled = true
        PasswordText.isEnabled = true
        
        loginButton.isEnabled = true
        
        
        loginButton.setTitle("Login", for: .normal)
    }
    func LoginFailed()
    {
        ErrorLabel.isHidden = false
        ErrorLabel.text = "login failed please try again"
        ErrorLabel.textColor = UIColor.red
    }
    func check_session()
    {
        let post_data: NSDictionary = NSMutableDictionary()
        
            let preferences = UserDefaults.standard
        post_data.setValue(login_session, forKey: "session")
        if(login_session.contains(preferences.object(forKey: "session") as! String))
        {
            DispatchQueue.main.async(execute: self.LoginDone)
            
            
        }
        else
        {
            DispatchQueue.main.async(execute: self.LoginToDo)
        }
        
        
        
    }
    func countItemsProject(xmlstring:String)-> Int{
        let tok =  xmlstring.components(separatedBy: "z:row")
        var NumOfItems = tok.count-1
        
        return NumOfItems
    }
    func parsexmlProject(tagname:String ,xmlstring:String)-> [String]{
        var Num = 0
        let tok =  xmlstring.components(separatedBy: "z:row")
        var NumOfItems = tok.count-1
        print("number of items : " , NumOfItems)
        var val = ""
        var companies:[String] = [String]()
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
                print("*****"+val.replacingOccurrences(of: tagname+"='", with: ""))
                companies.append(val.replacingOccurrences(of: tagname+"='", with: ""))
            }
            
            i = i+1
            Num = Num+1
        }
        return companies
    }
   
    func countItems(xmlstring:String)-> Int{
        let tok =  xmlstring.components(separatedBy: "z:row")
        var NumOfItems = tok.count-1
        
        return NumOfItems
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
extension ViewController: URLSessionDelegate {
    
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

