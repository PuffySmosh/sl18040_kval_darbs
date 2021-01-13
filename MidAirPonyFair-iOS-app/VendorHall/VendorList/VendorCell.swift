//
//  VendorCell.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 09/01/2021.
//

import UIKit

class VendorCell: UITableViewCell {

    @IBOutlet weak var ShopNameLabel: UILabel!
    @IBOutlet weak var PricesLabel: UILabel!
    
    
    func setShopNameLabel (nameLabelText: String, pricesLabelText: String) {
        ShopNameLabel.text = nameLabelText
        PricesLabel.text = pricesLabelText
    }
}
