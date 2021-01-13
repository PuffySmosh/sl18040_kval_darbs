//
//  ProductCell.swift
//  MidAirPonyFair-iOS-app
//
//  Created by by Sabīne Liepiņa
//

import UIKit

class ProductCell: UITableViewCell {
    // Ref UILabel
    @IBOutlet weak var prodItemLabel: UILabel!
    
    // Give label custom text
    func setLabel (labelText: String) {
        prodItemLabel.text = labelText
    }
}
