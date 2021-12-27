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
    let commentDataSource = CommentDataSource()
    let commentUploadManager = CommentUploadManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedPost = selectedPost {
            commentDataSource.getComments(post: selectedPost)
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentDataSource.getNumberOfComment()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentsTableViewCell
        if let comment = commentDataSource.getCommentAtIndex(index: indexPath.row) {
            cell.commentLabel.text = comment.comment
            cell.commentOwnerLabel.text = comment.ownerUsername
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
