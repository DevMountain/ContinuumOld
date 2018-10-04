//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class PostListTableViewController: UITableViewController, UISearchBarDelegate, PostsWereAddedToDelegate {

    
    @IBOutlet weak var postSearchBar: UISearchBar!
    
    var resultsArray: [SearchableRecord]?
    
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postSearchBar.delegate = self
        tableView.prefetchDataSource = self
//        PostController.shared.delegate = self
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged(_:)), name: PostController.PostsChangedNotification, object: nil)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        PostController.shared.fetchQueriedPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultsArray = PostController.shared.posts
        tableView.reloadData()
    }
    
    @objc func postsChanged(_ notification: Notification) {

        let indexPath = IndexPath(item: PostController.shared.posts.count - 1, section: 0)
        
        self.tableView.insertRows(at: [indexPath], with: .fade)
    }
    
    func postsWereAddedTo() {

        let indexPath = IndexPath(item: PostController.shared.posts.count - 1, section: 0)

        self.tableView.insertRows(at: [indexPath], with: .fade)
    }
    
    


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isSearching ? resultsArray?.count ?? 0: PostController.shared.posts.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell
//        let post = resultsArray?[indexPath.row] as? Post
        let dataSource = isSearching ? resultsArray : PostController.shared.posts
        let post = dataSource?[indexPath.row]
        cell?.post = post as? Post
        return cell ?? UITableViewCell()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let posts = PostController.shared.posts
        let filteredPosts = posts.filter { $0.matches(searchTerm: searchText) }.compactMap { $0 as SearchableRecord }
        resultsArray = filteredPosts
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        resultsArray = PostController.shared.posts
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDetailVC"{
            let destinationVC = segue.destination as? PostDetailTableViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let post = PostController.shared.posts[indexPath.row]
            destinationVC?.post = post
        }
    }

}

extension PostListTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            let post = PostController.shared.posts[indexPath.row]
            guard let url = post.imageAsset?.fileURL else { return }
            URLSession.shared.dataTask(with: url).resume()
        }
    }
    

}
