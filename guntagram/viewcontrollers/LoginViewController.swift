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
    @IBOutlet weak var loginButton: LoginRegisterButton!
    
    let userDataSource = UserLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataSource.delegate = self
        self.passwordTextField.delegate = self
        self.emailTextField.delegate = self
        
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        
        //clearInputFields()
    }
    
    func clearInputFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if let password = passwordTextField.text, let email = emailTextField.text {
            self.userDataSource.logInUser(email: email, password: password)
            view?.endEditing(true) // dismiss keyboard
            loginButton.showLoading()
        }
    }
    
}

extension LoginViewController: UserLoginManagerProtocol {
    
    func loginFailed(error: Error) {
        print(error)
        self.loginButton.hideLoading()
    }
    
    func userLoggedIn() {
        self.loginButton.hideLoading()
        self.performSegue(withIdentifier: "Login", sender: self)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (passwordTextField.text?.count ?? 0 > 5 && emailTextField.text?.count != 0) {
            loginButton.isEnabled = true
            loginButton.alpha = 1
        } else {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
        }
    }
}
