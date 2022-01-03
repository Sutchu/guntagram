//
//  ProfileViewController.swift
//  guntagram
//
//  Created by Ali Sutcu on 25.12.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var selectedUser: User? = FireStoreConstants.shared.currentUser
    let userManager = UserManager()
    let profileFetchManager = ProfileFetchManager()
    var isCallerSegue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userManager.delegate = self
        self.profileFetchManager.delegate = self
        self.usernameLabel.text = self.selectedUser?.userName
        if (isCallerSegue) {
            self.logoutButton.setTitle("", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let selectedUser = selectedUser {
            self.profileFetchManager.fetchPosts(user: selectedUser)
        }
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        self.userManager.logoutUser()
    }
}

extension ProfileViewController: UserManagerProtocol {
    func userDidLogout() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func errorOccured(error: Error?) {
        print(error ?? "An error occured")
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileFetchManager.getPostCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilePost", for: indexPath) as! ProfileCollectionViewCell
        if let post = profileFetchManager.getPostAt(index: indexPath.row) {
            cell.setImageFromPost(post: post)
        }
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    
}

extension ProfileViewController: ProfileFetchManagerProtocol {
    func postLoaded() {
        self.postCountLabel.text = String(profileFetchManager.getPostCount())
        self.likeCountLabel.text = String(profileFetchManager.getTotalLikeCount())
        self.postCollectionView.reloadData()
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width/3-1, height: self.view.frame.size.width/3-1)
    }
}
