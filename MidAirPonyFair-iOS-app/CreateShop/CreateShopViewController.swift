//
//  CreateShopViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Sabīne Liepiņa
//

import UIKit
import Firebase

class CreateShopViewController: UIViewController {
    // Initialising all the UI elements and constant variables
    private let ref = Database.database().reference()
    let dbShops = "Shops"
    let msgErrorFields = "Mandatory fields cannot be empty."
    let msgErrorPrice = "The price has to be a positive whole number."

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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let currentUID = Auth.auth().currentUser?.uid
        errorLabel.text = ""
        configUI()
        
        if(currentUID != nil) {
            getExistingData()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Clears fields when closing the screen
        clearFields()
    }
    
    // Configures the look of text view UI element
    func configUI() {
        vendorDescEditText.layer.borderWidth = 1
        vendorDescEditText.layer.borderColor = UIColor.systemGray5.cgColor
        vendorDescEditText.layer.cornerRadius = 5
    }
    
    // Get database data of the shop
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
            
            // Fills out the fields with the gotten data
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
    
    // Clears fields
    func clearFields () {
        usernameEditText.text = ""
        vendorDescEditText.text = ""
        promoCodeEditText.text = ""
        minPriceEditText.text = ""
        maxPriceEditText.text = ""
        internatShippingSwitch.isOn = false
        socialLinkEditText.text = ""
        otherSocialLinkEditText.text = ""
        storeLinkEditText.text = ""
        galleryLinkEditText.text = ""
    }
    
    // When submit button is pressed - give error or save data in DB
    @IBAction func submitButtonPressed(_ sender: UIButton) {
       
        guard
            let username = usernameEditText.text,
            let vendorDesc = vendorDescEditText.text,
            let minPrice = Int(minPriceEditText.text ?? "0"),
            let maxPrice = Int(maxPriceEditText.text ?? "0"),
            let socialLink1 = socialLinkEditText.text,
            let storeLink = storeLinkEditText.text
        else { errorLabel.text = msgErrorFields; return }
        
        // Creates a shop object
        let shop = ShopDC(username: username, vendorDesc: vendorDesc, promoCode: promoCodeEditText.text, minPrice: Int(minPrice), maxPrice: Int(maxPrice), internatShipping: internatShippingSwitch.isOn, socialLink1: socialLink1, socialLink2: otherSocialLinkEditText.text, storeLink: storeLink, galleryLink: galleryLinkEditText.text)
        
        // Checks for any errors
        if(shop.validateFields() == false) {
            errorLabel.text = msgErrorFields
        } else if (shop.validatePrice() == false) {
            errorLabel.text = msgErrorPrice
        } else {
            // If no errors, save the shop object in the DB and close this screen
            guard let shopOwnerUID = Auth.auth().currentUser?.uid else { return }
            ref.child(dbShops).child(shopOwnerUID).setValue(shop.passData())
        
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
