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
    
    let userLoginManager = UserLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLoginManager.delegate = self
        self.passwordTextField.delegate = self
        self.emailTextField.delegate = self
        
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
    }
    

    override func viewDidAppear(_ animated: Bool) {
        userLoginManager.checkSavedState()
        clearInputFields()
    }
    
    func clearInputFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if let password = passwordTextField.text, let email = emailTextField.text {
            self.userLoginManager.logInUser(email: email, password: password)
            view?.endEditing(true) // dismiss keyboard
            loginButton.showLoading()
        }
    }
    
}

extension LoginViewController: UserLoginManagerProtocol {
    
    func loginFailed(error: Error) {
        print(error)
        self.loginButton.hideLoading()
        let alert = UIAlertController(title: "Error Occured", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
