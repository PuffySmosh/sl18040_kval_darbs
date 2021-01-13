//
//  ProductDC.swift
//  
//
//  Created by Irita Grigaluna on 03/01/2021.
//

import Foundation

struct ProductDC {
    var prodName: String
    var prodDesc: String
    var prodLink: String
    var multiColour: Bool
    var multiSize: Bool
    var customisable: Bool
    var basePrice: Int
    var shopOwnerUID: String
    
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
    
    func validateFields() -> Bool {
        return !prodName.isEmpty && !prodDesc.isEmpty && !prodLink.isEmpty && !shopOwnerUID.isEmpty
    }
    
    func validatePrice () -> Bool {
        let isPriceOk = basePrice > 0
        
        return isPriceOk
    }
    
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
