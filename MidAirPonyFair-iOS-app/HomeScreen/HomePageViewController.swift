//
//  HomePageViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Sabīne Liepiņa
//

import UIKit
import Firebase
import SideMenu

class HomePageViewController: UIViewController {

    // Initialising the side menu and creating a closure to reload the side menu.
    var sideListTableView = SideMenuListController()
    var menu: SideMenuNavigationController?
    
    var reloadList: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialises/creates the side menu
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Additional setup after loading the view.
        // Calling the funcionality of the closure, that was definded in sideListTableView.
        reloadList = { [weak self] in
            self?.sideListTableView.reloadList()
        }
        
        // selectSegue closure functionality - calls the function
        sideListTableView.selectSegue = { [weak self] givenMenuItem in
            self?.selectSegue(menuItem: givenMenuItem)
        }
        
        // Setting up the side menu to show up in the view properly
        menu = SideMenuNavigationController(rootViewController: sideListTableView)
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    // Giving reloadList to another view through the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? LogInViewController else {return}
        destinationVC.reloadList = reloadList
    }
    
    // Opens side menu.
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    
    // Depending on which navigation button was pressed, performs segue to that view.
    func selectSegue (menuItem: MenuItems) {
        menu?.dismiss(animated: true, completion: nil)
        
        switch menuItem {
        
        // If the user logs out, reload the side menu list.
        case .logOut:
            do {
                try Auth.auth().signOut()
                    reloadList?()
            }
            catch {
                print("Unexpected error: \(error)")
            }
        
        // Otherwise, bring the user to their selected destination.
        case .logIn:
            performSegue(withIdentifier: "HomeToLogIn", sender: nil)
        case .vendorHall:
            performSegue(withIdentifier: "HomeToVendorHall", sender: nil)
        case .teamPage:
            performSegue(withIdentifier: "HomeToTeam", sender: nil)
        case .createEditShop:
            performSegue(withIdentifier: "HomeToCreateShop", sender: nil)
        case .viewProducts:
            performSegue(withIdentifier: "HomeToProdList", sender: nil)
        
        }
    }
}

// Side navigation menu funcitonality.
class SideMenuListController: UITableViewController {
    
    // Initialising variables.
    var selectSegue : ((MenuItems) -> Void)?
    var menuItems = [MenuItems]()
    
    // When the view is loaded change, fills out the side menu.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.register(SideMenuCell.instanceFromNib(),
                           forCellReuseIdentifier: String(describing: SideMenuCell.self))
        
        // Checks if there is a current logged in user
        let currentUID = Auth.auth().currentUser?.uid
        loggedIn(currentUID: currentUID)
    }
    
    // Check if the user is logged in, and returns the list of menu items.
    func loggedIn (currentUID: String?) {
        if (currentUID != nil) {
            menuItems = [.vendorHall, .teamPage, .createEditShop, .viewProducts, .logOut]
        }
        else {
            menuItems = [.vendorHall, .teamPage, .logIn]
        }
    }
    
    // How many items we have in the view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    // Cell setup.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SideMenuCell.self), for: indexPath)
        
        if let cell = cell as? SideMenuCell {
            cell.titleLabel.text = menuItems[indexPath.row].rawValue
        }
        return cell
    }
    
    // If a side menu button was clicked, navigate to chosen view.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectSegue?(menuItems[indexPath.row])
    }
    
    // Height setup for rows
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // Depending on whether the user is logged in, reload to the correct list of items.
    func reloadList() {
        let currentUID = Auth.auth().currentUser?.uid
        loggedIn(currentUID: currentUID)
        tableView.reloadData()
    }
}

// A list of all the possibile menu items. Can be used through out the document.
enum MenuItems: String {
    case logOut = "Log Out"
    case logIn = "Log In"

    case viewProducts = "View Products"
    case createEditShop = "Create/Edit Shop"
    
    case teamPage = "Meet the Team"
    case vendorHall = "Vendor Hall"
}
