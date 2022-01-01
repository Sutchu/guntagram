//
//  CommentsViewController.swift
//  guntagram
//
//  Created by Cem Kılınç on 27.12.2021.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentsTable: UITableView!
    var selectedPost : Post?
    let commentFetchManager = CommentFetchManager()
    let commentUploadManager = CommentUploadManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedPost = selectedPost {
            commentUploadManager.delegate = self
            commentFetchManager.delegate = self
            commentFetchManager.fetchComments(post: selectedPost)
        }
        //self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if let commentText = self.commentTextField.text, let selectedPost = self.selectedPost {
            if(!commentText.isEqual("")) {
                commentUploadManager.uploadComment(comment: commentText, postReference: selectedPost.postReference)
                commentTextField.text = ""
            }
        }
    }

}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentFetchManager.getNumberOfComment()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentsTableViewCell
        if let comment = commentFetchManager.getCommentAtIndex(index: indexPath.row) {
            cell.commentLabel.text = comment.comment
            cell.commentOwnerLabel.text = "\(comment.ownerUsername) : "
        }
        return cell
    }
    
    
}

extension CommentsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
}

extension CommentsViewController: CommentUploadManagerDelegate {
    func commentUploaded() {
        if let selectedPost = self.selectedPost {
            self.commentFetchManager.fetchComments(post: selectedPost)
        }
    }
    
    func uploadFailed(error: Error) {
        print(error)
    }
    
}

extension CommentsViewController: CommentFetchManagerDelegate {
    func fetchingFailed(error: Error) {
        print(error)
    }
    
    func fetchCompleted() {
        self.commentsTable.reloadData()
    }
    
    
}
