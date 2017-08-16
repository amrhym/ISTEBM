//
//  ViewControllertest.swift
//  ISTEPM
//
//  Created by amr Elshendidy on 8/15/17.
//  Copyright © 2017 amr Elshendidy. All rights reserved.
//

import UIKit

class ViewControllertest: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{
 
    @IBOutlet weak var asdf: UIPickerView!
var f = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
 let preferences = UserDefaults.standard
        var co = (preferences.object(forKey: "pick") as? [String])
        f = co!
        asdf.delegate = self
        asdf.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return f.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return f[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
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
