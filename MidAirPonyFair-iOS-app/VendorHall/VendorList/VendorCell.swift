//
//  VendorCell.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Sabīne Liepiņa
//

import UIKit

class VendorCell: UITableViewCell {
    // Initialise UI elements
    @IBOutlet weak var ShopNameLabel: UILabel!
    @IBOutlet weak var PricesLabel: UILabel!
    
    // Set the labels with given text
    func setShopNameLabel (nameLabelText: String, pricesLabelText: String) {
        ShopNameLabel.text = nameLabelText
        PricesLabel.text = pricesLabelText
    }
}
