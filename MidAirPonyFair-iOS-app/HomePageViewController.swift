//
//  HomePageViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 02/01/2021.
//

import UIKit
import Firebase
import SideMenu

class HomePageViewController: UIViewController {

    var sideListTableView = SideMenuListController()
    var menu: SideMenuNavigationController?
    
    var reloadList: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        reloadList = { [weak self] in
            self?.sideListTableView.reloadList()
        }
        sideListTableView.selectSegue = { [weak self] givenMenuItem in
            self?.selectSegue(menuItem: givenMenuItem)
        }
        
        menu = SideMenuNavigationController(rootViewController: sideListTableView)
        menu?.leftSide = true
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? LogInViewController else {return}
        destinationVC.reloadList = reloadList
    }
    
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    
    func selectSegue (menuItem: MenuItems) {
        switch menuItem {
        case .logOut:
            do {
                try Auth.auth().signOut()
                    reloadList?()
            }
            catch {
                print("Unexpected error: \(error)")
            }
        case .teamPage:
            performSegue(withIdentifier: "HomeToTeam", sender: nil)
        case .createEditShop:
            performSegue(withIdentifier: "HomeToCreateShop", sender: nil)
        case .viewProducts:
            performSegue(withIdentifier: "HomeToProdList", sender: nil)
        //remove default after all options added
        default:
            print("poopie")
        }
    }
}

class SideMenuListController: UITableViewController {
    
    var selectSegue : ((MenuItems) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let currentUID = Auth.auth().currentUser?.uid
        loggedIn(currentUID: currentUID)
    }
    
    
    var menuItems = [MenuItems]()
    
    func loggedIn (currentUID: String?) {
        if (currentUID != nil) {
            menuItems = [.vendorHall, .teamPage, .createEditShop, .viewProducts, .logOut]
        }
        else {
            menuItems = [.vendorHall, .teamPage, .logIn]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = menuItems[indexPath.row].rawValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectSegue?(menuItems[indexPath.row])
    }
    
    func reloadList() {
        let currentUID = Auth.auth().currentUser?.uid
        loggedIn(currentUID: currentUID)
        tableView.reloadData()
    }
}

enum MenuItems: String {
    case logOut = "Log Out"
    case logIn = "Log In"

    case viewProducts = "View Products"
    case createEditShop = "Create/Edit Shop"
    
    case teamPage = "Meet the Team"
    case vendorHall = "Vemdor Hall"
}
