//
//  ViewController3.swift
//  ISTEPM
//
//  Created by amr Elshendidy on 8/14/17.
//  Copyright © 2017 amr Elshendidy. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {

    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var UsName: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var CreatedOn: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      let preferences = UserDefaults.standard
        
        
        ID.text = "ID : " + (preferences.object(forKey: "ID") as? String)!
        UsName.text = "Username : " + (preferences.object(forKey: "username") as? String)!
        Name.text = "Name : " + (preferences.object(forKey: "ImnName") as? String)!
        Email.text = "Email : " + (preferences.object(forKey: "EMail") as? String)!
        CreatedOn.text = "Created : " + (preferences.object(forKey: "Created") as? String)!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
