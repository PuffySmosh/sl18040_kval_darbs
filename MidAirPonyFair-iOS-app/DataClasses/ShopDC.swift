//
//  ShopDC.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Sabīne Liepiņa
//

import Foundation

// Object for storing shop/vendor information from firebase.
struct ShopDC {
    var username: String
    var vendorDesc: String
    var promoCode: String?
    var minPrice: Int
    var maxPrice: Int
    var internatShipping: Bool
    var socialLink1: String
    var socialLink2: String?
    var storeLink: String
    var galleryLink: String?
    
    init(username: String, vendorDesc: String, promoCode: String?, minPrice: Int, maxPrice: Int, internatShipping: Bool, socialLink1: String, socialLink2: String?, storeLink: String, galleryLink: String?) {
        self.username = username
        self.vendorDesc = vendorDesc
        self.promoCode = promoCode
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.internatShipping = internatShipping
        self.socialLink1 = socialLink1
        self.socialLink2 = socialLink2
        self.storeLink = storeLink
        self.galleryLink = galleryLink
    }
    
    // Validates if fields are blank
    func validateFields () -> Bool {
        // Validates the length of the description
        // TODO: Move this to a seperate function
//        let isDesc500 = vendorDesc.count <= 500
        
        return !username.isEmpty && !vendorDesc.isEmpty && !socialLink1.isEmpty && !storeLink.isEmpty
    }
    
    // Validates that the price is not below 0 and not larger than maxPrice
    func validatePrice () -> Bool {
        // Check that price can't be below 0
        let isMinIntOk = minPrice > 0
        let isMaxIntOk = maxPrice > 0
        
        // Check that minPrice is not larger than maxPrice
        let isMinOk = minPrice <= maxPrice
        
        return isMinIntOk && isMaxIntOk && isMinOk
    }
    
    // Takes the object and makes it into a dictionary to be passed to DB
    func passData() -> [String: Any?] {
            return [
                "username": username,
                "vendorDesc": vendorDesc,
                "promoCode": promoCode,
                "minPrice": minPrice,
                "maxPrice": maxPrice,
                "internShipping": internatShipping,
                "socialLink1": socialLink1,
                "socialLink2": socialLink2,
                "storeLink": storeLink,
                "galleryLink": galleryLink,
            ]
    }
    
}
