//
//  RegisterViewController.swift
//  guntagram
//
//  Created by Ali Sutcu on 16.12.2021.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    private let db = Firestore.firestore()

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    // Navigate to main screen if register is successfull
                    self.performSegue(withIdentifier: "Register", sender: self)
                    self.createUserInDatabase()
                }
              // ...
            }
        }
    }
    
    func createUserInDatabase() {
        if let user = Auth.auth().currentUser, let usermail = user.email {
            db.collection("users").document(user.uid).setData([
                "email": usermail,
                "posts": []
            ]) { (error) in
                if let e = error {
                    print(e)
                } else {
                    print("user created suksesful")
                }
                
            }
        }
    }
    
    
}
