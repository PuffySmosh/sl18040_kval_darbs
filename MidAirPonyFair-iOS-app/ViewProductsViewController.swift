//
//  ViewProductsViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 03/01/2021.
//

import UIKit
import Firebase

class ViewProductsViewController: UIViewController {

    @IBOutlet weak var ProductsTableView: UITableView!
    
    private let ref = Database.database().reference()
    let dbProducts = "Products"
    var productID = ""
    
    var products: [String] = []
    var productIDs: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
             
        ProductsTableView.delegate = self
        ProductsTableView.dataSource = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? CreateProductViewController else {return}
        destinationVC.productID = productID
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUID = Auth.auth().currentUser?.uid
        
        if(currentUID != nil) {
            getExistingProducts()
        }
    }
    
    func getExistingProducts() {
        guard let shopOwnerUID = Auth.auth().currentUser?.uid else { return }
        
        var count = 0
        
        ref.child(dbProducts).observe(.value, with: {(snapshot) in
            self.products = []
            guard let allProducts = snapshot.value as? [String: Any?] else { return }
            
            for (key, value) in allProducts {
                guard let filteredProducts = value as? [String: Any?] else { return }
                if (filteredProducts["shopOwnerUID"] as? String == shopOwnerUID) {
                    guard let productName = filteredProducts["prodName"] as? String else { return }
                    self.products.append(productName)
                    
                    guard let productID = key as? String else { return }
                    self.productIDs.append(productID)
                    
                    self.ProductsTableView.reloadData()
                    
                }
                
                print()
            }
        }
        )
    }
    
}

extension ViewProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = String(describing: MenuCell.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let myCell = cell as? MenuCell{
            myCell.menuItemLabel.text =  products[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productID = productIDs[indexPath.row]
        performSegue(withIdentifier: "ProdListToCreateEditProd", sender: nil)
    }
}
