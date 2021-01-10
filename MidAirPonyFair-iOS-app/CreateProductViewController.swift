//
//  CreateProductViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 03/01/2021.
//

import UIKit
import Firebase

class CreateProductViewController: UIViewController {

    @IBOutlet weak var ProductNameTextField: UITextField!
    @IBOutlet weak var ProductDescTextView: UITextView!
    @IBOutlet weak var ProductURLTextField: UITextField!
    
    @IBOutlet weak var ProductColorVariantSwitch: UISwitch!
    @IBOutlet weak var ProductSizeVariantSwitch: UISwitch!
    @IBOutlet weak var ProductCustomisabilitySwitch: UISwitch!
    
    @IBOutlet weak var ProductPriceTextField: UITextField!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    private let ref = Database.database().reference()
    let dbProducts = "Products"
    var productID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if(!productID.isEmpty) {
            getExistingData()
        }
        
    }
    
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
    
    @IBAction func SubmitButtonPressed(_ sender: Any) {
        
            guard
                let prodName = ProductNameTextField.text,
                let prodDesc = ProductDescTextView.text,
                let prodLink = ProductURLTextField.text,

                let basePrice = Int(ProductPriceTextField.text ?? "0"),

                let shopOwnerUID = Auth.auth().currentUser?.uid
                else { return }

            let product = ProductDC(prodName: prodName, prodDesc: prodDesc, prodLink: prodLink, multiColour: ProductColorVariantSwitch.isOn, multiSize: ProductSizeVariantSwitch.isOn, customisable: ProductCustomisabilitySwitch.isOn, basePrice: basePrice, shopOwnerUID: shopOwnerUID)

            if(product.validate() == false) {
                ErrorLabel.text = "yeet"
            }
            else {
                if(productID.isEmpty) {
                    ref.child(dbProducts).childByAutoId().setValue(product.passData())
                }
                else {
                    ref.child(dbProducts).child(productID).setValue(product.passData())
                }

                
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    

