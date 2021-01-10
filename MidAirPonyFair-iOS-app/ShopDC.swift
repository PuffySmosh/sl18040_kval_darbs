//
//  ShopDC.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 02/01/2021.
//

import Foundation

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
    
    func validate () -> Bool {
        let isMinIntOk = minPrice > 0
        let isMaxIntOk = maxPrice > 0
        let isMinOk = minPrice <= maxPrice
        let isDesc500 = vendorDesc.count <= 500
        
        return !username.isEmpty && !vendorDesc.isEmpty && !socialLink1.isEmpty && !storeLink.isEmpty && isMinOk && isDesc500 && isMinIntOk && isMaxIntOk
    }
    
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
