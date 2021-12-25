//
//  ProfileViewController.swift
//  guntagram
//
//  Created by Ali Sutcu on 25.12.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    let userManager = UserManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userManager.delegate = self
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

    @IBAction func logoutButtonPressed(_ sender: Any) {
        self.userManager.logoutUser()
    }
}

extension ProfileViewController: UserManagerProtocol {
    func userDidLogout() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func errorOccured(error: Error?) {
        print(error)
    }
    
    
}
