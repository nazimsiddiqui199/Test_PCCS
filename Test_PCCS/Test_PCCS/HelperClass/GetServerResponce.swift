//
//  AppointmentList.swift
//  Test_PCCS
//
//  Created by Nazim on 15/04/18.
//  Copyright © 2018 NazimApp. All rights reserved.
//

import UIKit
import Alamofire

class AppointmentList{
    
    let custumerName: String?
    let customerAddress: String?
    let apptDetails: String
    let custLatitude: String
    let custLongitude: String
    let custPhone: String
    let postalCode: String?
    
    class func getAllResponce(serverList:  [[String: Any]]) -> ([AppointmentList]) {
        
        var filteredListResponce: [AppointmentList] = []
        
        for responce in serverList{
            filteredListResponce.append(AppointmentList.init(dictionary: responce))
        }
        return (filteredListResponce)
    }
    
   
    init(custumerName: String, customerAddress: String, apptDetails: String, custLatitude: String, custLongitude: String, custPhone: String, postalCode: String) {
        
        self.custumerName = custumerName
        self.customerAddress = customerAddress
        self.apptDetails = apptDetails
        self.custLongitude = custLongitude
        self.custLatitude = custLatitude
        self.custPhone = custPhone
        self.postalCode = postalCode
    }
    
    convenience init(dictionary: [String: Any]){
        
        let costmerDetails = dictionary["CustomerDetails"] as! [String: Any]
        
        let custumerName = "\(costmerDetails["CustomerTitle"] as! String) \(costmerDetails["CustomerForename"] as! String) \(costmerDetails["CustomerSurname"] as! String)"
        let customerAddress = "\(costmerDetails["CustomerCompanyName"] as! String),\(costmerDetails["CollectionBuildingName"] as! String),\(costmerDetails["CollectionStreet"] as! String),\(costmerDetails["CustomerAddressArea"] as! String),\(costmerDetails["CustomerAddressTown"] as! String),\(costmerDetails["CustomerCounty"] as! String)"
        let apptDetails = (dictionary["WarrantyDetails"] as! [String: Any])["ChargeType"] as! String
        let custLatitude = costmerDetails["ApptLatitude"] as! String
        let custLongitude = costmerDetails["ApptLongitude"] as! String
        let custPhone = costmerDetails["CustomerMobileNo"] as! String
        let postalCode = costmerDetails["CollectionPostCode"] as! String
        
        self.init(custumerName: custumerName, customerAddress: customerAddress, apptDetails: apptDetails, custLatitude: custLatitude, custLongitude: custLongitude, custPhone: custPhone, postalCode: postalCode)
    }
}
