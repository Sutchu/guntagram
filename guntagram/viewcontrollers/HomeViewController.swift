//
//  HomeViewController.swift
//  guntagram
//
//  Created by Ali Sutcu on 16.12.2021.
//

import UIKit
import Firebase
import FirebaseStorage

class HomeViewController: UIViewController {
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

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
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBAction func uploadPostButtonPressed(_ sender: Any) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true)
            
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
        if let userId = Auth.auth().currentUser?.uid {
            let timestamp = NSDate().timeIntervalSince1970
            let imagePath = "images/\(userId)-\(timestamp).png"
            let userReference = db.collection("users").document(userId)
            
            let postReference = self.createPostInDatabase(userReference: userReference, imagePath: imagePath, timeStamp: timestamp)
            self.sendImageToStorage(imageData: imageData, imagePath: imagePath, timeStamp: timestamp)
            self.addPostReferenceToUserInDatabase(postReference: postReference, userReference: userReference)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func sendImageToStorage(imageData: Data, imagePath: String, timeStamp: TimeInterval) {
        storage.child(imagePath).putData(imageData, metadata: nil, completion: {_, error in
            guard error == nil else {
                print("Failed to uplod resim")
                return
            }
        })
    }
    
    func createPostInDatabase(userReference: DocumentReference, imagePath: String, timeStamp: TimeInterval) -> DocumentReference {
        
        return db.collection("posts").addDocument(data: [
            "like_count": 0,
            "upload_time": timeStamp,
            "owner": userReference,
            "image_path": imagePath
        ]) { (error) in
            if let e = error {
                print(e)
            } else {
                print("user created suksesful")
            }
        }
    }
    
    func addPostReferenceToUserInDatabase(postReference: DocumentReference, userReference: DocumentReference) {
        userReference.updateData([
            "posts": FieldValue.arrayUnion([postReference])
        ])
    }
}
