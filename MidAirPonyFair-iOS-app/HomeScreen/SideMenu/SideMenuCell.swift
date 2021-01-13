//
//  SideMenuCell.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 12/01/2021.
//

import UIKit

class SideMenuCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    class func instanceFromNib() -> UINib {
        return UINib(nibName: String(describing: SideMenuCell.self), bundle: nil)
    }
}
