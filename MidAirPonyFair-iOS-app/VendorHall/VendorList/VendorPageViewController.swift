//
//  VendorPageViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Sabīne Liepiņa
//

import UIKit
import Firebase

// Creating an object for storing data for the vendor cell
struct VendorShow {
    let name: String
    let shopId: String
    let min: Int
    let max: Int
}

class VendorPageViewController: UIViewController {
    // Initialising all the UI elements and constant variables
    private var ds = [VendorShow]()
    private var vendorID = ""
    
    @IBOutlet weak var vendorTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vendorTableView.delegate = self
        vendorTableView.dataSource = self
        getData()
    }
    
    // Gets data from DB to fill out the table view
    func getData() {
        //Firebase request
        let ref = Database.database().reference()
        
        ref.child("Shops").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            for (key, shop) in value {
                guard let shop = shop as? [String: Any],
                      let name = shop["username"] as? String,
                      let min = shop["minPrice"] as? Int,
                      let max = shop["maxPrice"] as? Int
                else { return }
                
                // TODO: Remove "name:" from obj via init using _
                let vendor = VendorShow(name: name, shopId: key, min: min, max: max)
                self?.ds.append(vendor)
                
            }
            self?.vendorTableView.reloadData()
        })
    }
    
    // Preparations for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // As that segue as destination, pass the vendorID
        guard let destinationVC = segue.destination as? ViewVendorViewController else {return}
        destinationVC.vendorID = vendorID
    }
}

// This makes sure that everything in the tableView works how it should.
extension VendorPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ds.count
    }
    
    // Cell setup
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = String(describing: VendorCell.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let myCell = cell as? VendorCell{
            myCell.setShopNameLabel(nameLabelText: ds[indexPath.row].name, pricesLabelText: "$\(ds[indexPath.row].min) - $\(ds[indexPath.row].max)")
        }
        
        return cell
    }
    
    // When pressed, perform segue (move screens)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vendorID = ds[indexPath.row].shopId
        performSegue(withIdentifier: "VendorListToShop", sender: nil)
    }
}
