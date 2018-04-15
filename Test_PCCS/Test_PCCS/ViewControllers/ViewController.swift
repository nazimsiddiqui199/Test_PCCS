//
//  ViewController.swift
//  Test_PCCS
//
//  Created by Nazim on 15/04/18.
//  Copyright © 2018 NazimApp. All rights reserved.
//

import UIKit
import Alamofire
import CoreTelephony


class ViewController: UIViewController {
    
    var appointmentList: [AppointmentList] = [AppointmentList]()
    @IBOutlet weak var tableView: UITableView!
    var apptDate: String!
    var apptPassword: String!
    var apptuserName: String!
    var settingScreen: SettingsViewController! = nil
    let urlName = "https://www.skylinecms.co.uk/alpha/RemoteEngineerAPI/GetAppointmentDetails"
    
    @IBOutlet weak var initiatorNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //We are agetting here some pre defined value so thet user can see the appt details, its just for demo purpose only
        getDefaultValuesForAppoint(userName: "ON", password: "andriodtest", date: Date())
        configureNavigayionBarView()
        getApponitMnetListFromServer()
        
          self.settingScreen = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.settingScreen.delegate = self
        
    }
    
    func getDefaultValuesForAppoint(userName: String, password: String, date: Date) -> Void {
        
        self.apptDate = self.getformatDate(date: date)
        self.apptPassword = password
        self.apptuserName = userName
        
    }
    
    func configureNavigayionBarView() -> Void {
        
        self.title = "Appointments"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Setting", style: .plain, target: self, action: #selector(settingsButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadButtonTapped))
        
    }
    
    @objc func settingsButtonTapped() -> Void {
        
        self.navigationController?.pushViewController(settingScreen, animated: true)
    }
    
    @objc func reloadButtonTapped() -> Void {
        
        self.appointmentList = [AppointmentList]()
        self.tableView.reloadData()
        self.getApponitMnetListFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appointmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let appointmentListCell = tableView.dequeueReusableCell(withIdentifier: "AppointmentListCell") as! AppointmentListCell
        appointmentListCell.configureCell(appointmentDetails: self.appointmentList[indexPath.row], cellObject: appointmentListCell)
        appointmentListCell.callButton.tag = indexPath.row
        appointmentListCell.mapButton.tag = indexPath.row
        appointmentListCell.callButton.addTarget(self, action: #selector(callAppointmnetButtonTapped(sender:)), for: .touchUpInside)
        appointmentListCell.mapButton.addTarget(self, action: #selector(showMapAppointButtonTapped(sender:)), for: .touchUpInside)
        return appointmentListCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func callAppointmnetButtonTapped(sender: UIButton) -> Void {
        
        let appointment = self.appointmentList[sender.tag];
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        
        if ((carrier?.isoCountryCode) != nil) {
            
            let url = URL(string: "tel:\(appointment.custPhone)")
            
            if UIApplication.shared.canOpenURL(url!){
                
                UIApplication.shared.canOpenURL(url!)
                
            }else{
                
                ShowAlert(title: "Cannot make a call", subtitle: "")
            }
            
        }else{
            
            ShowAlert(title: "Cannot make a call", subtitle: "It seems that your device doesn't have SIM card or your device is on airplane mode or there is no cellular coverage.")
        }
        
    }
    
    @objc func showMapAppointButtonTapped(sender: UIButton) -> Void {
        let appointment = self.appointmentList[sender.tag];
        let mapViewScreen = self.storyboard?.instantiateViewController(withIdentifier: "ShowMapViewController") as! ShowMapViewController
        mapViewScreen.appointMentDetails = appointment;
        self.navigationController?.pushViewController(mapViewScreen, animated: true)
    }
    
}

extension ViewController{
    
    func getApponitMnetListFromServer() -> Void {
        
        if Connection.isReachable() {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.dimBackground = true
        hud?.labelText = "Getting details"
        
        let stringParams : String =  "<GetAppointmentDetails>" +
            "<SLUsername>\(self.apptuserName!)</SLUsername>" +
            "<SLPassword>\(self.apptPassword!)</SLPassword>" +
            "<CurrentDate>\(self.apptDate!)</CurrentDate>" +
        "</GetAppointmentDetails>"
        
        debugPrint(stringParams)
        
        let url = URL(string: self.urlName)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = stringParams.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("application/xml", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(xmlRequest)
            .responseData { (response) in
                
                XMLConverter.convertXMLData(response.data!, completion: { (isCompleted, dictionary, error) in
                    
                    debugPrint(dictionary ?? "No Values");
                    
                    DispatchQueue.main.async {
                        
                     MBProgressHUD.hide(for: self.view, animated: true)
                        
                        if error == nil && dictionary != nil{
                        
                        let dictionaryValue = dictionary?.value(forKey: "Response") as! NSDictionary
                        
                            let responceCode = dictionaryValue.value(forKey: "ResponseCode") as! String
                            
                            if responceCode == "SC0001"{
                                
                                self.initiatorNameLabel.text = (dictionaryValue.value(forKey: "Defaults") as! [String: Any])["FullName"] as? String
                                debugPrint(dictionaryValue)
                                let appaointmenetList = dictionaryValue.value(forKey: "Appointments") as! NSDictionary
                                
                                let aptList = appaointmenetList.value(forKey: "Appointment") as! [[String: Any]]
                                
                                debugPrint(aptList);
                                debugPrint(aptList.count);
                                self.appointmentList = AppointmentList.getAllResponce(serverList: aptList)
                                self.tableView.reloadData()
                           
                            }else{
                                
                                self.ShowAlert(title: "No Appointments Found", subtitle: "Please refresh the list ao try to change the date")
                            }
                        }
                        
                    }
                    
                    
                })
                
        }
        
        }else{
            NetworkErrorAlert.showNetworkErorr(viewController: self.navigationController!)
        }
    }
}

extension ViewController{
    
    func ShowAlert(title: String, subtitle: String) -> Void {
        
        let alertController = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getformatDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}

extension ViewController: SettingDelegate{
    
    func SettingSelectedDetails(date: Date, username: String, password: String) {
        
        self.getDefaultValuesForAppoint(userName: username, password: password, date: date)
        self.getApponitMnetListFromServer()
        
    }
}

