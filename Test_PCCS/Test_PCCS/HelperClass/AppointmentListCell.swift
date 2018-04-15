//
//  AppointmentListCell.swift
//  Test_PCCS
//
//  Created by Nazim on 15/04/18.
//  Copyright © 2018 NazimApp. All rights reserved.
//

import UIKit

class AppointmentListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var appointNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var cellTopView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.animateViewWithShadowAnimation(viewToDisplay: self.cellTopView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(appointmentDetails: AppointmentList, cellObject: AppointmentListCell) -> Void {
        
        cellObject.nameLabel.text = appointmentDetails.custumerName
        cellObject.addressLabel.text = appointmentDetails.customerAddress
        cellObject.appointNameLabel.text = "Appointment for \(appointmentDetails.apptDetails)"
        
    }
    
    func animateViewWithShadowAnimation(viewToDisplay: UIView) -> Void {
    
    viewToDisplay.layer.shadowOffset = CGSize(width: 4, height: 4)
    viewToDisplay.layer.shadowColor = UIColor.darkGray.cgColor
    viewToDisplay.layer.shadowOpacity = 0.2
    viewToDisplay.layer.borderWidth = 0.0
    viewToDisplay.layer.cornerRadius = 2.0;
    viewToDisplay.layer.borderColor = UIColor.lightGray.cgColor
    }

}
