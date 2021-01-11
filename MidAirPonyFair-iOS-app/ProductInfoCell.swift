//
//  ProductInfoCell.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 11/01/2021.
//

import UIKit

class ProductInfoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var pricelabel: UILabel!
    @IBOutlet weak var stuffLabel: UILabel!
    
    func configCell(title: String, desc: String, price: Int, custom: Bool, size: Bool, color: Bool) {
        titleLabel.text = title
        descLabel.text = desc
        pricelabel.text = "$\(price)"
        var stuffText = ""
        if color {
            stuffText.append("Multiple colors available \n")
        } else {
            stuffText.append("One color only \n")
        }
        
        if size {
            stuffText.append("Multiple sizes available \n")
        } else {
            stuffText.append("One size only \n")
        }
        
        if custom {
            stuffText.append("Personalisable")
        } else {
            stuffText.append("Non-personalisable")
        }
        stuffLabel.text = stuffText
    }
}
