//
//  NetworkErrorAlert.swift
//  DealsSampleApp
//
//  Created by Nazim on 15/04/18.
//  Copyright © 2018 NazimApp. All rights reserved.
//

import UIKit

class NetworkErrorAlert: NSObject {
    
    class func showNetworkErorr(viewController: UIViewController){
        
        let alertController = UIAlertController(title: "Are you offline?", message: "We couldn't connect to the internet.\nConnect to mobile data or wifi and try again.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }

}
