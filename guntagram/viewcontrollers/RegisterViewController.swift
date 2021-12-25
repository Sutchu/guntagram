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
    
    @IBOutlet weak var loginButton: UIButton!
    
    let userDataSource = UserRegisterManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataSource.delegate = self
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func registerPressed(_ sender: Any) {
        if let email = emailTextField.text,
           let password = passwordTextField.text,
            let userName = usernameTextField.text {
                
            userDataSource.createNewUser(email: email, userName: userName, password: password)
        }
    }
}

extension RegisterViewController: UserRegisterManagerProtocol {
    
    func userIsRegistered() {
        self.performSegue(withIdentifier: "Register", sender: self)
    }
    
    func registerFailed(error: Error) {
        print(error)
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
}

