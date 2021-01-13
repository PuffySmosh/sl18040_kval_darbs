//
//  LogInViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Sabīne Liepiņa
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    // Initialising variables and elements in the view.
    var reloadList: (() -> Void)?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
            
    @IBOutlet weak var errorLabel: UILabel!
    
    var email: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    // If the login button is pressed -> authenticate.
    @IBAction func loginButtonPressed(_ sender: Any) {
        email = emailTextField.text!
        password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            // If there are encountered errors, display error.
            if error != nil {
                self.errorLabel.textColor = UIColor.red
                self.errorLabel.text = error!.localizedDescription
            }
            // Otherwise, reload the side menu list and go back to home screen.
            else {
                self.reloadList?()
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        // Reset the values, so nothing is saved.
        email = ""
        password = ""
    }
}
