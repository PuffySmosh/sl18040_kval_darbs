//
//  SectionTitleView.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 11/01/2021.
//

import UIKit

class SectionTitleView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SectionTitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
