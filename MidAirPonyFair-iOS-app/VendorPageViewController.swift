//
//  VendorPageViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 02/01/2021.
//

import UIKit

class VendorPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }


}

//extension VendorPageViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellIdentifier = String(describing: MenuCell.self)
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
//        
//        if let myCell = cell as? VendorCell{
//            myCell.ShopNameLabel.text =  shop[indexPath.row]
//        }
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        productID = productIDs[indexPath.row]
//        performSegue(withIdentifier: "ProdListToCreateEditProd", sender: nil)
//    }
//}
