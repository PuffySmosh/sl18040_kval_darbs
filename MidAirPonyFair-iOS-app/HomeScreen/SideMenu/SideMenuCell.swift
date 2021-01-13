//
//  SideMenuCell.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Sabīne Liepiņa
//

import UIKit

class SideMenuCell: UITableViewCell {
    // Init the title
    @IBOutlet weak var titleLabel: UILabel!

    // Returns the cell nib
    class func instanceFromNib() -> UINib {
        return UINib(nibName: String(describing: SideMenuCell.self), bundle: nil)
    }
}
