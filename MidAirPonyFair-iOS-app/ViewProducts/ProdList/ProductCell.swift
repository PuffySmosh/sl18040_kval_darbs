//
//  ProductCell.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 02/01/2021.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var prodItemLabel: UILabel!
    
    func setLabel (labelText: String) {
        prodItemLabel.text = labelText
    }
}
