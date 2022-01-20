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
    @IBOutlet weak var userProfilePhoto: UIImageView!
    @IBOutlet weak var uploadPostButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    let refreshControl = UIRefreshControl()
    var selectedUser: User? = FireStoreConstants.shared.currentUser
    let userManager = UserManager()
    let profileFetchManager = ProfileFetchManager()
    var isCallerSegue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userManager.delegate = self
        self.profileFetchManager.delegate = self
        self.usernameLabel.text = self.selectedUser?.userName
        userProfilePhoto.layer.borderWidth = 1
        userProfilePhoto.layer.masksToBounds = false
        userProfilePhoto.layer.borderColor = UIColor.black.cgColor
        userProfilePhoto.layer.cornerRadius = userProfilePhoto.frame.height/2
        userProfilePhoto.clipsToBounds = true
        if (isCallerSegue) {
            self.logoutButton.isHidden = true
            self.uploadPostButton.isHidden = true
            self.editProfileButton.isHidden = true
           // self.hidesBottomBarWhenPushed = true
            
        }
        if let selectedUser = selectedUser {
            self.profileFetchManager.fetchPosts(user: selectedUser)
            self.profileFetchManager.fetchProfilePhoto(user: selectedUser) {image in
                if let image = image {
                    self.userProfilePhoto.image = image
                }
            }
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
            postCollectionView.refreshControl = refreshControl // not required when using UITableViewController
            refreshControl.tintColor = UIColor.white
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeProfilePhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        
        profileFetchManager.fetchPosts(user: self.selectedUser!)
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
        refreshControl.endRefreshing()
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width/3-1, height: self.view.frame.size.width/3-1)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        self.userManager.changeProfilePhoto(imageData: imageData)
        self.userProfilePhoto.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
