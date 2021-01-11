//
//  VendorPageViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 02/01/2021.
//

import UIKit
import Firebase

struct VendorShow {
    let name: String
    let shopId: String
    let min: Int
    let max: Int
}

class VendorPageViewController: UIViewController {
    
    private var ds = [VendorShow]()
    private var vendorID = ""
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableview.delegate = self
        tableview.dataSource = self
        getData()
    }
    
    func getData() {
        //Firebase req
        let ref = Database.database().reference()
        
        ref.child("Shops").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let value = snapshot.value as? [String: Any] else { return }
            for (key, shop) in value {
                guard let shop = shop as? [String: Any],
                      let name = shop["username"] as? String,
                      let min = shop["minPrice"] as? Int,
                      let max = shop["maxPrice"] as? Int
                else { return }
                
                //remove "name:" from obj via init using _
                let vendor = VendorShow(name: name, shopId: key, min: min, max: max)
                self?.ds.append(vendor)
                
            }
            self?.tableview.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ViewVendorVC else {return}
        destinationVC.vendorID = vendorID
    }
}

extension VendorPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = String(describing: VendorCell.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let myCell = cell as? VendorCell{
            myCell.setShopNameLabel(nameLabelText: ds[indexPath.row].name, pricesLabelText: "$\(ds[indexPath.row].min) - $\(ds[indexPath.row].max)")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vendorID = ds[indexPath.row].shopId
        performSegue(withIdentifier: "VendorShop", sender: nil)
    }
}
