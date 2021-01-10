//
//  LogInViewController.swift
//  MidAirPonyFair-iOS-app
//
//  Created by Irita Grigaluna on 20/12/2020.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    var reloadList: (() -> Void)?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
            
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nextScreenButton: UIButton!
    
    var email: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        email = emailTextField.text!
        password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                self.errorLabel.textColor = UIColor.red
                self.errorLabel.text = error!.localizedDescription
            }
            else {
                self.reloadList?()
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        Auth.auth().currentUser?.uid
        
        email = ""
        password = ""
    }
}
