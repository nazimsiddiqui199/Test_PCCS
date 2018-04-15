//
//  ShowMapViewController.swift
//  Test_PCCS
//
//  Created by Nazim on 15/04/18.
//  Copyright © 2018 NazimApp. All rights reserved.
//

import UIKit
import GoogleMaps


class ShowMapViewController: UIViewController {
    
    var appointMentDetails: AppointmentList!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: Double(appointMentDetails.custLatitude)!, longitude: Double(appointMentDetails.custLongitude)!, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(appointMentDetails.custLatitude)!, longitude: Double(appointMentDetails.custLongitude)!)
        marker.title = appointMentDetails.postalCode
        marker.map = mapView
    }


}
