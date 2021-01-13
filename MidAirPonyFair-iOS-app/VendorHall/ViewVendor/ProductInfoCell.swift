//
//  ProductInfoCell.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Sabīne Liepiņa
//

import UIKit

class ProductInfoCell: UITableViewCell {
    // Ref UI elements
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var pricelabel: UILabel!
    @IBOutlet weak var customisableLabel: UILabel!
    
    // Fill out cell with data from DB
    func configCell(title: String, desc: String, price: Int, custom: Bool, size: Bool, color: Bool) {
        titleLabel.text = title
        descLabel.text = desc
        pricelabel.text = "$\(price)"
        var customisableText = ""
        
        // If option is true -> title 1, else -> title 2
        // Fills out the same label
        if color {
            customisableText.append("Multiple colors available \n")
        } else {
            customisableText.append("One color only \n")
        }
        
        if size {
            customisableText.append("Multiple sizes available \n")
        } else {
            customisableText.append("One size only \n")
        }
        
        if custom {
            customisableText.append("Personalisable")
        } else {
            customisableText.append("Non-personalisable")
        }
        customisableLabel.text = customisableText
    }
}
