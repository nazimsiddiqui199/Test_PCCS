//
//  SettingsViewController.swift
//  Test_PCCS
//
//  Created by Nazim on 15/04/18.
//  Copyright © 2018 NazimApp. All rights reserved.
//

import UIKit

protocol SettingDelegate: class {
    func SettingSelectedDetails(date: Date, username: String, password: String)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var userNametextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var dateTextfield: UITextField!
    var datePicker = UIDatePicker()
    weak var delegate: SettingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.datePicker.datePickerMode = .date
        self.dateTextfield.inputView = self.datePicker
        self.datePicker.addTarget(self, action: #selector(datePickerDateChanged), for: .valueChanged)
        setDefaultVlauesToSettingsScreen()
    }
    
    func setDefaultVlauesToSettingsScreen() -> Void {
        
        self.userNametextField.text = "ON"
        self.passwordTextField.text = "andriodtest"
        self.dateTextfield.text = self.getformatDate(date: Date())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated);
        if self.delegate != nil {
            
            self.delegate?.SettingSelectedDetails(date: self.datePicker.date, username: self.userNametextField.text!, password: self.passwordTextField.text!)
        }
    }
    
    @objc func datePickerDateChanged() -> Void {
        
      self.dateTextfield.text = getformatDate(date: self.datePicker.date)
    }
    
    func getformatDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
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
