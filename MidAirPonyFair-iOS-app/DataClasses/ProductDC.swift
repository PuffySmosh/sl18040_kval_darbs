//
//  ProductDC.swift
//  
//
//  Created by Sabīne Liepiņa
//

import Foundation

// Object for storing product information from firebase.
struct ProductDC {
    var prodName: String
    var prodDesc: String
    var prodLink: String
    var multiColour: Bool
    var multiSize: Bool
    var customisable: Bool
    var basePrice: Int
    var shopOwnerUID: String
    
    // Initialising all the needed values
    init(prodName: String, prodDesc: String, prodLink: String, multiColour: Bool, multiSize: Bool, customisable: Bool, basePrice: Int, shopOwnerUID: String) {
        self.prodName = prodName
        self.prodDesc = prodDesc
        self.prodLink = prodLink
        self.multiColour = multiColour
        self.multiSize = multiSize
        self.customisable = customisable
        self.basePrice = basePrice
        self.shopOwnerUID = shopOwnerUID
    }
    
    // Validates if fields are blank
    func validateFields() -> Bool {
        // Validates the length of the description
        // TODO: Move this to a seperate function
//        let isDesc255 = prodDesc.count <= 255
        
        return !prodName.isEmpty && !prodDesc.isEmpty && !prodLink.isEmpty && !shopOwnerUID.isEmpty
    }
    
    // Validates that the price is an int
    func validatePrice () -> Bool {
        // Check that price can't be below 0
        let isPriceOk = basePrice > 0
        
        return isPriceOk
    }
    
    // Takes the object and makes it into a dictionary to be passed to DB
    func passData() -> [String: Any] {
        return [
            "prodName": prodName,
            "prodDesc": prodDesc,
            "prodLink": prodLink,
            "multiColour": multiColour,
            "multiSize": multiSize,
            "customisable": customisable,
            "basePrice": basePrice,
            "shopOwnerUID": shopOwnerUID
        ]
    }
}
