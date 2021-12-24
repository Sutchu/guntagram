//
//  LoginViewController.swift
//  guntagram
//
//  Created by Ali Sutcu on 16.12.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    let userDataSource = UserDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataSource.delegate = self
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
    @IBAction func loginButtonPressed(_ sender: Any) {
        if let password = passwordTextField.text, let email = emailTextField.text {
            self.userDataSource.logInUser(email: email, password: password)
        }
        
    }
    
}

extension LoginViewController: UserDataSourceProtocol {
    
    func registerFailed(error: Error) {}
    
    func userIsRegistered() {}
    
    func loginFailed(error: Error) {
        print(error)
    }
    
    func userLoggedIn() {
        self.performSegue(withIdentifier: "Login", sender: self)
    }
    
}

