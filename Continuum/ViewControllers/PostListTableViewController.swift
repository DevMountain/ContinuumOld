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
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postSearchBar.delegate = self
//        tableView.prefetchDataSource = self
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
    
    
    var queriedPosts = [Post]()
    var postRecords: [CKRecord] = []
    private func loadPhotos(cursor:  CKQueryOperation.Cursor? = nil) {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
        let operation: CKQueryOperation
        
        if let cursor = cursor {
            operation = CKQueryOperation(cursor: cursor)
        } else {
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: "Post", predicate: predicate)
            query.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            operation = CKQueryOperation(query: query)
        }
        operation.desiredKeys = ["caption", "photoData", "timestamp"]
        operation.resultsLimit = 5
        operation.queuePriority = .veryHigh
        operation.qualityOfService = .userInteractive
  
        
        operation.recordFetchedBlock = { [unowned self] record in
            guard let post = Post(record: record) else { return }
            self.queriedPosts.append(post)
            print(self.queriedPosts.count)
            DispatchQueue.main.sync {
                let indexPath = IndexPath(item: self.queriedPosts.count - 1, section: 0)
                print(indexPath)
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
        }
        let publicDB = CKContainer.default().publicCloudDatabase
        operation.queryCompletionBlock = { [unowned self] cursor, error in
            if let error = error {
                print("Error fethcing posts \(error)")
            } else if let cursor = cursor {
                self.loadPhotos(cursor: cursor)
                print("Fetching more results \(self.queriedPosts.count)")
            } else {
                print("Done")
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                }
            }
        }
        publicDB.add(operation)
        
    }
    
    
    func fetchAllPosts() {
        PostController.shared.fetchQueriedPosts { (firstPosts, continuedPosts) in
            if firstPosts != nil {
//                guard let firstPosts = firstPosts else { return }
//                let indexPath = IndexPath(row: firstPosts.count - 1, section: 0)
                DispatchQueue.main.async {

                    self.tableView.reloadData()
                }
            }
            if continuedPosts != nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
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
            let post = queriedPosts[indexPath.row]
            guard let url = post.imageAsset?.fileURL else {print("No tep url"); return }
            print("Prefetching \(post.caption)")
            URLSession.shared.dataTask(with: url).resume()
        }
    }
    
    
    
}
