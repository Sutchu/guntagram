//
//  LoginViewController.swift
//  guntagram
//
//  Created by Ali Sutcu on 16.12.2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    let userDataSource = UserLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataSource.delegate = self
        self.passwordTextField.delegate = self
        self.emailTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if let password = passwordTextField.text, let email = emailTextField.text {
            self.userDataSource.logInUser(email: email, password: password)
        }
    }
    
}

extension LoginViewController: UserLoginManagerProtocol {
    
    func loginFailed(error: Error) {
        print(error)
    }
    
    func userLoggedIn() {
        self.navigationController?.navigationBar.isHidden = true
        self.performSegue(withIdentifier: "Login", sender: self)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
}
