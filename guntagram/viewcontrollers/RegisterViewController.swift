//
//  RegisterViewController.swift
//  guntagram
//
//  Created by Ali Sutcu on 16.12.2021.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: LoginRegisterButton!
    
    let userDataSource = UserRegisterManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataSource.delegate = self
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        registerButton.isEnabled = false
        registerButton.alpha = 0.5
        
        clearInputFields()
    }
    
    func clearInputFields() {
        usernameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        if let email = emailTextField.text,
           let password = passwordTextField.text,
            let userName = usernameTextField.text {
            userDataSource.createNewUser(email: email, userName: userName, password: password)
            
            view?.endEditing(true) // dismiss keyboard
            registerButton.showLoading()
        }
    }
}

extension RegisterViewController: UserRegisterManagerProtocol {
    
    func userIsRegistered() {
        registerButton.hideLoading()
        self.performSegue(withIdentifier: "Register", sender: self)
    }
    
    func registerFailed(error: Error) {
        print(error)
        registerButton.hideLoading()
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (passwordTextField.text?.count ?? 0 > 5 && emailTextField.text?.count != 0 && usernameTextField.text?.count != 0) {
            registerButton.isEnabled = true
            registerButton.alpha = 1
        } else {
            registerButton.isEnabled = false
            registerButton.alpha = 0.5
        }
    }
}
