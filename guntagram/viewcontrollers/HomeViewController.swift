//
//  HomeViewController.swift
//  guntagram
//
//  Created by Ali Sutcu on 21.12.2021.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var postsTableView: UITableView!
    
    let dataSource = PostFetchManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.hidesBackButton = true
        dataSource.delegate = self
        dataSource.fetchAllPosts()
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

}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.getPostCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! PostTableViewCell
        let post = dataSource.getPostAtIndex(index: indexPath.row)
        cell.postImage.image = post.uiImage
        cell.likeLabel.text = "\(post.likeCount) likes, \(post.owner) "
        return cell
    }
    
}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = dataSource.getPostAtIndex(index: indexPath.row)
        return post.uiImage.size.height/post.uiImage.size.width * self.view.frame.width + 70
    }
}

extension HomeViewController: PostFetchManagerProtocol {
    func postLoaded() {
        self.postsTableView.reloadData()
    }
    
    
}
