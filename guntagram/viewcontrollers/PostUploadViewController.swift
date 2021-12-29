//
//  HomeViewController.swift
//  guntagram
//
//  Created by Ali Sutcu on 16.12.2021.
//

import UIKit
import Firebase
import FirebaseStorage

class PostUploadViewController: UIViewController {
    private let postDataManager = PostUploadManager()
    
    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postDataManager.delegate = self
        // Do any additional setup after loading the view.
        self.resultLabel.font = UIFont.init(name: "Grandista", size: CGFloat(12))
    }
}

extension PostUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
        self.postDataManager.uploadPost(imageData: imageData)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension PostUploadViewController: PostUploadManagerProtocol {
    func uploadFailed(error: Error) {
        self.resultLabel.text = "error"
    }
    
    func postUploaded() {
        self.resultLabel.text = "Success!"

    }
    
}
