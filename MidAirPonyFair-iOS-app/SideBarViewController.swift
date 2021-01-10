//
//  SideMenuViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 02/01/2021.
//

import UIKit
import Firebase

class SideBarViewController: UIViewController {
    
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TableView.delegate = self
        TableView.dataSource = self
        
        loggedIn()
    }
    
    let currentUID = Auth.auth().currentUser?.uid
    var menuItems = [String]()
    
    func loggedIn () {
        if (currentUID != nil) {
            menuItems = ["peepee","poopoo","bruh","aaaaaaaaaaaa", "POOOPIEEEE"]
        }
        else {
            menuItems = ["only bruh"]
        }
    }
}

extension SideBarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = String(describing: MenuCell.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let myCell = cell as? MenuCell{
            myCell.setLabel(labelText: menuItems[indexPath.row])
        }
        
        return cell
    }
    
}
