//
//  Connection.swift
//  DealsSampleApp
//
//  Created by Nazim on 15/04/18.
//  Copyright © 2018 NazimApp. All rights reserved.
//

import UIKit

class Connection{
    
    let reachability: Reachability!
    static let shared = Connection()
    
    init() {
        self.reachability = Reachability.init(hostName: "www.google.com")
        self.reachability.startNotifier()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(notification:)), name: NSNotification.Name.reachabilityChanged, object: nil)
    }
    
    class func isReachable() -> Bool{
        
        return self.shared.reachability.isReachable()
    }
    
    @objc func reachabilityChanged(notification: Notification){
        
        self.reachability.startNotifier()

    }
    
}
