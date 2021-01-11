//
//  ViewVendorVC.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 11/01/2021.
//

import UIKit
import Firebase

struct VendorInfo {
    var owner: ShopDC?
    var produce: [ProductDC]
}

class ViewVendorVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var vendorID = ""
    var ds = VendorInfo(owner: nil, produce: [ProductDC]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    
    func getData() {
        let ref = Database.database().reference()
        let shopsRef = ref.child("Shops").child(vendorID)
        let produceRef = ref.child("Products")
        
        shopsRef.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in

            guard
                let value = snapshot.value as? [String: Any],
                let username = value["username"] as? String,
                let desc = value["vendorDesc"] as? String,
                let min = value["minPrice"] as? Int,
                let max = value["maxPrice"] as? Int,
                let socialLink1 = value["socialLink1"] as? String,
                let store = value["storeLink"] as? String,
                let shipping = value["internShipping"] as? Bool
            else { return }

            let code = value["promoCode"] as? String
            let socialLink2 = value["socialLink2"] as? String
            let gallery = value["galleryLink"] as? String

                let vendor = ShopDC(
                    username: username,
                    vendorDesc: desc,
                    promoCode: code,
                    minPrice: min,
                    maxPrice: max,
                    internatShipping: shipping,
                    socialLink1: socialLink1,
                    socialLink2: socialLink2,
                    storeLink: store,
                    galleryLink: gallery)
            
            self?.ds.owner = vendor
            
            produceRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let value = snapshot.value as? [String: Any] else { return }
                for (key, products) in value {
                    guard let product = products as? [String: Any],
                          let price = product["basePrice"] as? Int,
                          let desc = product["prodDesc"] as? String,
                          let name = product["prodName"] as? String,
                          let color = product["multiColour"] as? Bool,
                          let size = product["multiSize"] as? Bool,
                          let custom = product["customisable"] as? Bool,
                          let link = product["prodLink"] as? String
                    else { return }
                    
                    if (product["shopOwnerUID"] as? String) == self?.vendorID {
                        continue
                    }
                    
                    let prod = ProductDC(
                        prodName: name,
                        prodDesc: desc,
                        prodLink: link,
                        multiColour: color,
                        multiSize: size,
                        customisable: custom,
                        basePrice: price,
                        shopOwnerUID: key)
                    
                    self?.ds.produce.append(prod)
                }
                self?.tableView.reloadData()
            })
            
        })
    }
}

extension ViewVendorVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return ds.produce.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ds.owner?.username
        case 1:
            return "Products"
        default:
            return ""
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        // Do something if there is time
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section == 0
            ? String(describing: VendorInfoCell.self)
            : String(describing: ProductInfoCell.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let myCell = cell as? VendorInfoCell {
            guard let owner = ds.owner else { return cell }
            
            myCell.storeLink = owner.storeLink
            myCell.galleryLink = owner.galleryLink
            myCell.socialMedia1 = owner.socialLink1
            myCell.socialMedia2 = owner.socialLink2
            
            myCell.configCell(
                desc: owner.vendorDesc,
                min: owner.minPrice,
                max: owner.maxPrice,
                shipping: owner.internatShipping,
                discountCode: owner.promoCode)
            
            myCell.showAlert = { [weak self] in
                let alert = UIAlertController(title: "Oops", message: "There is no link for this", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            
            myCell.openLink = { (linkString) in
                guard let url = URL(string: linkString) else { return }
                UIApplication.shared.open(url)
            }

        } else if let myCell = cell as? ProductInfoCell {
            let product = ds.produce[indexPath.row]
            myCell.configCell(
                title: product.prodName,
                desc: product.prodDesc,
                price: product.basePrice,
                custom: product.customisable,
                size: product.multiSize,
                color: product.multiColour)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("kaka")
    }
}
