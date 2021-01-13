//
//  CreateProductViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Sabīne Liepiņa
//

import UIKit
import Firebase

class CreateProductViewController: UIViewController {
    
    // Initialising all the UI elements and constant variables
    @IBOutlet weak var ProductNameTextField: UITextField!
    @IBOutlet weak var ProductDescTextView: UITextView!
    @IBOutlet weak var ProductURLTextField: UITextField!
    
    @IBOutlet weak var ProductColorVariantSwitch: UISwitch!
    @IBOutlet weak var ProductSizeVariantSwitch: UISwitch!
    @IBOutlet weak var ProductCustomisabilitySwitch: UISwitch!
    
    @IBOutlet weak var ProductPriceTextField: UITextField!
    
    @IBOutlet weak var DeleteBarButton: UIBarButtonItem!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    private let ref = Database.database().reference()
    let dbProducts = "Products"
    var productID = ""
    let msgErrorFields = "Mandatory fields cannot be empty."
    let msgErrorPrice = "The price has to be a positive whole number."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Configure UI stuff
        configUI()
        ErrorLabel.text = ""
        
        // If product exists, get existing data
        if(!productID.isEmpty) {
            getExistingData()
        } else {
            // Else disable the delete button
            DeleteBarButton.isEnabled = false
            DeleteBarButton.tintColor = .clear
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        productID = ""
        clearFields()
    }
    
    // Configures the look of text view UI element
    func configUI() {
        ProductDescTextView.layer.borderWidth = 1
        ProductDescTextView.layer.borderColor = UIColor.systemGray5.cgColor
        ProductDescTextView.layer.cornerRadius = 5
    }
    
    // Get database data of the product
    func getExistingData() {
        ref.child(dbProducts).child(productID).observe(.value, with:  { (snapshot) in
            let existingProd = snapshot.value as? [String: Any?]
            guard
                let prodName = existingProd?["prodName"] as? String,
                let prodDesc = existingProd?["prodDesc"] as? String,
                let prodLink = existingProd?["prodLink"] as? String,
                let multiColour = existingProd?["multiColour"] as? Bool,
                let multiSize = existingProd?["multiSize"] as? Bool,
                let customisable = existingProd?["customisable"] as? Bool,
                let basePrice = existingProd?["basePrice"] as? Int
            else { return }
            
            
            self.ProductNameTextField.text = "\(prodName)"
            self.ProductDescTextView.text = "\(prodDesc)"
            self.ProductURLTextField.text = "\(prodLink)"
            
            self.ProductColorVariantSwitch.isOn = multiColour
            self.ProductSizeVariantSwitch.isOn = multiSize
            self.ProductCustomisabilitySwitch.isOn = customisable
            
            self.ProductPriceTextField.text = "\(String(basePrice))"
            
            
        }) { (Error) in
            print(Error.localizedDescription)
        }
    }
    
    // If delete button is pressed, delete object in DB and close the window
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        ref.child(dbProducts).child(productID).removeValue()
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)

    }
    
    // Clears fields
    func clearFields () {
        ProductNameTextField.text = ""
        ProductDescTextView.text = ""
        ProductURLTextField.text = ""
        ProductPriceTextField.text = ""
        ProductColorVariantSwitch.isOn = false
        ProductSizeVariantSwitch.isOn = false
        ProductCustomisabilitySwitch.isOn = false
    }
    
    // If submit button is pressed
    @IBAction func SubmitButtonPressed(_ sender: Any) {
        
        guard
            let prodName = ProductNameTextField.text,
            let prodDesc = ProductDescTextView.text,
            let prodLink = ProductURLTextField.text,
            
            let basePrice = Int(ProductPriceTextField.text ?? "0"),
            
            let shopOwnerUID = Auth.auth().currentUser?.uid
        else { ErrorLabel.text = msgErrorFields; return }
        
        // Creates product object
        let product = ProductDC(prodName: prodName, prodDesc: prodDesc, prodLink: prodLink, multiColour: ProductColorVariantSwitch.isOn, multiSize: ProductSizeVariantSwitch.isOn, customisable: ProductCustomisabilitySwitch.isOn, basePrice: basePrice, shopOwnerUID: shopOwnerUID)
        
        // Checks for errors
        if(product.validateFields() == false) {
            ErrorLabel.text = msgErrorFields
        } else if(product.validatePrice() == false) {
            ErrorLabel.text = msgErrorPrice
        } else {
            // If no errors, check if product already exists and saves the object in the DB
            if(productID.isEmpty) {
                ref.child(dbProducts).childByAutoId().setValue(product.passData())
            }
            else {
                ref.child(dbProducts).child(productID).setValue(product.passData())
            }
            
            // Close this screen
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
}


