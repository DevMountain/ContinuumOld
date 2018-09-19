//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by DevMountain on 9/17/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var postSearchBar: UISearchBar!
    
    var resultsArray: [SearchableRecord]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postSearchBar.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultsArray = PostController.shared.posts
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsArray?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell
        let post = resultsArray?[indexPath.row] as? Post
        cell?.post = post
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

