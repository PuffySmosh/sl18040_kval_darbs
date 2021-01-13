//
//  SectionTitleView.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Sabīne Liepiņa
//

import UIKit

class SectionTitleView: UIView {
    // Ref the title
    @IBOutlet weak var titleLabel: UILabel!
    
    // Change the Nib to a UIView for the section header
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SectionTitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
