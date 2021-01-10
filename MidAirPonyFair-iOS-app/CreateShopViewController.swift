//
//  CreateShopViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 30/12/2020.
//

import UIKit
import Firebase

class CreateShopViewController: UIViewController {

    private let ref = Database.database().reference()
    let dbShops = "Shops"

    @IBOutlet weak var usernameEditText: UITextField!
    @IBOutlet weak var vendorDescEditText: UITextView!
    
    @IBOutlet weak var promoCodeEditText: UITextField!
    @IBOutlet weak var minPriceEditText: UITextField!
    @IBOutlet weak var maxPriceEditText: UITextField!
    
    @IBOutlet weak var internatShippingSwitch: UISwitch!
    
    @IBOutlet weak var socialLinkEditText: UITextField!
    @IBOutlet weak var otherSocialLinkEditText: UITextField!
    
    @IBOutlet weak var storeLinkEditText: UITextField!
    @IBOutlet weak var galleryLinkEditText: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    //next page = temp solution for this stuff
    @IBOutlet weak var nextPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let currentUID = Auth.auth().currentUser?.uid
        
        if(currentUID != nil) {
            getExistingData()
        }
        
    }
    
    func getExistingData() {
        guard let shopOwnerUID = Auth.auth().currentUser?.uid else { return }
        
        ref.child(dbShops).child(shopOwnerUID).observe(.value, with:  { (snapshot) in
            let existingShop = snapshot.value as? [String: Any?]
            
            guard
                let username = existingShop?["username"] as? String,
                let vendorDesc = existingShop?["vendorDesc"] as? String,
                let minPrice = existingShop?["minPrice"] as? Int,
                let maxPrice = existingShop?["maxPrice"] as? Int,
                let internShipping = existingShop?["internShipping"] as? Bool,
                let socialLink1 = existingShop?["socialLink1"] as? String,
                let storeLink = existingShop?["storeLink"] as? String
            else { return }
            
            let promoCode = existingShop?["promoCode"] as? String ?? ""
            let socialLink2 = existingShop?["socialLink2"] as? String ?? ""
            let galleryLink = existingShop?["galleryLink"] as? String ?? ""
            
            self.usernameEditText.text = "\(username)"
            self.vendorDescEditText.text = "\(vendorDesc)"
            self.promoCodeEditText.text = "\(promoCode)"
            self.minPriceEditText.text = "\(String(minPrice))"
            self.maxPriceEditText.text = "\(String(maxPrice))"
            self.internatShippingSwitch.isOn = internShipping
            self.socialLinkEditText.text = "\(socialLink1)"
            self.otherSocialLinkEditText.text = "\(socialLink2)"
            self.storeLinkEditText.text = "\(storeLink)"
            self.galleryLinkEditText.text = "\(galleryLink)"
            
        }) { (Error) in
            print(Error.localizedDescription)
        }
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
       
        guard
            let username = usernameEditText.text,
            let vendorDesc = vendorDescEditText.text,
            let minPrice = Int(minPriceEditText.text ?? "0"),
            let maxPrice = Int(maxPriceEditText.text ?? "0"),
            let socialLink1 = socialLinkEditText.text,
            let storeLink = storeLinkEditText.text
            else { return }
        
        let shop = ShopDC(username: username, vendorDesc: vendorDesc, promoCode: promoCodeEditText.text, minPrice: Int(minPrice), maxPrice: Int(maxPrice), internatShipping: internatShippingSwitch.isOn, socialLink1: socialLink1, socialLink2: otherSocialLinkEditText.text, storeLink: storeLink, galleryLink: galleryLinkEditText.text)
        
//        let shop : [String : Any?] = [
//            "username": usernameEditText.text,
//            "vendorDesc": vendorDescEditText.text,
//            "promoCode": promoCodeEditText.text,
//            "minPrice": minPriceEditText.text,
//            "maxPrice": maxPriceEditText.text,
//            "internShipping": internatShippingSwitch.isOn,
//            "socialLink1": socialLinkEditText.text,
//            "socialLink2": otherSocialLinkEditText.text,
//            "storeLink": storeLinkEditText.text,
//            "galleryLink": galleryLinkEditText.text,
////            "shopOwnerUID": Auth.auth().currentUser?.uid
//        ]
        
        if(shop.validate() == false) {
            errorLabel.text = "yeet"
        }
        else {
            guard let shopOwnerUID = Auth.auth().currentUser?.uid else { return }
            ref.child(dbShops).child(shopOwnerUID).setValue(shop.passData())
        
//            getExistingData()
            self.nextPageButton.sendActions(for: .touchUpInside)
        }
    }
}
