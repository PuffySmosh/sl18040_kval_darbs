//
//  VendorInfoCell.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Sabīne Liepiņa
//

import UIKit

class VendorInfoCell: UITableViewCell {
    //Ref UI elements, init variables
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var social2Button: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    
    var showAlert: (() -> Void)?
    var openLink: ((String) -> Void)?
    
    var storeLink: String = ""
    var galleryLink: String? = ""
    var socialMedia1: String = ""
    var socialMedia2: String? = ""
    
    func configCell(desc: String, min: Int, max: Int, shipping: Bool, discountCode: String?) {
        descLabel.text = desc
        moneyLabel.text = "$\(min) - $\(max)"
        shippingLabel.text = shipping ? "International shipping" : "Domestic shipping only"
        discountLabel.isHidden = discountCode?.isEmpty == true
        discountLabel.text = "Discount code: " + (discountCode ?? "")
    }
    
    // When button pressed open link
    @IBAction func socialMedia1(_ sender: UIButton) {
        openLink?(socialMedia1)
    }
    
    // When button pressed, open link otherwise error
    @IBAction func socialMedia2(_ sender: UIButton) {
        if socialMedia2?.isEmpty != true, let link = socialMedia2 {
            openLink?(link)
        } else {
            showAlert?()
        }
    }
    
    // When button pressed, open link
    @IBAction func visitStore(_ sender: UIButton) {
        openLink?(storeLink)
    }
    
    // When button pressed, open link otherwise error
    @IBAction func viewGallery(_ sender: UIButton) {
        if galleryLink?.isEmpty != true, let link = galleryLink {
            openLink?(link)
        } else {
            showAlert?()
        }
    }
}
