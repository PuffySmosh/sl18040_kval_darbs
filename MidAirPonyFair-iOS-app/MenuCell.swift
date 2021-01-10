//
//  MenuCell.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 02/01/2021.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var menuItemLabel: UILabel!
    
    func setLabel (labelText: String) {
        menuItemLabel.text = labelText
    }
}
