//
//  ViewProductsViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by by Sabīne Liepiņa
//

import UIKit
import Firebase

class ViewProductsViewController: UIViewController {
    // Init variables and ref the UI elements
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
    
    // Giving product to add/edit product view through the segue, clear productID after done.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? CreateProductViewController else {return}
        destinationVC.productID = productID
        productID = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUID = Auth.auth().currentUser?.uid
        
        if(currentUID != nil) {
            getExistingProducts()
        }
    }
    
    // Get database data of the products that vendor has
    func getExistingProducts() {
        guard let shopOwnerUID = Auth.auth().currentUser?.uid else { return }
                
        ref.child(dbProducts).observe(.value, with: {(snapshot) in
            self.products = []
            self.productIDs = []
            // Get out all products
            guard let allProducts = snapshot.value as? [String: Any?] else { return }
            
            // Filter products with matching shopOwnerUID
            for (key, value) in allProducts {
                guard let filteredProducts = value as? [String: Any?] else { return }
                if (filteredProducts["shopOwnerUID"] as? String == shopOwnerUID) {
                    guard let productName = filteredProducts["prodName"] as? String else { return }
                    // Save product name for table view
                    self.products.append(productName)
                    
                    // Save productID for segue
                    guard let productID = key as? String else { return }
                    self.productIDs.append(productID)
                    
                    // Reload the product list
                    self.ProductsTableView.reloadData()
                    
                }
            }
        }
        )
    }
    
}

// Config table view
extension ViewProductsViewController: UITableViewDelegate, UITableViewDataSource {
    // Give row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    // Cell setup
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = String(describing: ProductCell.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let myCell = cell as? ProductCell{
            myCell.prodItemLabel.text =  products[indexPath.row]
        }
        
        return cell
    }
    
    // If product is clicked pass the productID and perform segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productID = productIDs[indexPath.row]
        performSegue(withIdentifier: "ProdListToCreateEditProd", sender: nil)
    }
}
