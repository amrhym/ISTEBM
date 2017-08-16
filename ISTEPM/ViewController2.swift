//
//  ViewController2.swift
//  ISTEPM
//
//  Created by amr Elshendidy on 8/14/17.
//  Copyright © 2017 amr Elshendidy. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

  
    @IBOutlet weak var LogOutButton: UIButton!

    @IBOutlet weak var RunTasksButton: UIButton!
    @IBOutlet weak var DeleteTasksButton: UIButton!
    @IBOutlet weak var YourTasksButton: UIButton!
    @IBOutlet weak var AddTaskButton: UIButton!
    @IBOutlet weak var UserInformationButton: UIButton!
    @IBOutlet weak var UserNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
         let preferences = UserDefaults.standard
        LogOutButton.isHidden = false
        LogOutButton.backgroundColor = UIColor.clear
        LogOutButton.layer.cornerRadius = 5
        LogOutButton.layer.borderWidth = 1
        LogOutButton.layer.borderColor = UIColor.black.cgColor
        //user information button styling
        RunTasksButton.backgroundColor = UIColor.clear
        RunTasksButton.layer.cornerRadius = 5
        RunTasksButton.layer.borderWidth = 1
        RunTasksButton.layer.borderColor = UIColor.black.cgColor
   
        YourTasksButton.backgroundColor = UIColor.clear
        YourTasksButton.layer.cornerRadius = 5
        YourTasksButton.layer.borderWidth = 1
        YourTasksButton.layer.borderColor = UIColor.black.cgColor
        UserInformationButton.backgroundColor = UIColor.clear
        UserInformationButton.layer.cornerRadius = 5
        UserInformationButton.layer.borderWidth = 1
        UserInformationButton.layer.borderColor = UIColor.black.cgColor
        AddTaskButton.backgroundColor = UIColor.clear
        AddTaskButton.layer.cornerRadius = 5
        AddTaskButton.layer.borderWidth = 1
        AddTaskButton.layer.borderColor = UIColor.black.cgColor
        //******************************
        UserNameLabel.text = "Hi " + (preferences.object(forKey: "ImnName") as? String)!
        // Do any additional setup after loading the view.
    }

    @IBAction func Logout_Action(_ sender: Any) {
        let preferences = UserDefaults.standard
        preferences.removeObject(forKey: "session")
        preferences.removeObject(forKey: "username")
         preferences.removeObject(forKey: "password")
         preferences.removeObject(forKey: "Projects")
         preferences.removeObject(forKey: "ImnName")
         preferences.removeObject(forKey: "ID")
         preferences.removeObject(forKey: "EMail")
         preferences.removeObject(forKey: "Created")
         preferences.removeObject(forKey: "Name")
         preferences.removeObject(forKey: "NameCode")
         preferences.removeObject(forKey: "ModerationStatus")
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
